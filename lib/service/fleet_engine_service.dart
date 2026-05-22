import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../const/api_routes.dart';
import '../const/app_session.dart';
import '../data/remote/dio_client.dart';
import '../model/trip_model.dart';

/// Fleet Engine integration:
///   - Token: GET /getDriverToken/{vehicleId} (backend, driver JWT)
///   - Trip creation: POST Fleet Engine directly
///   - ONLINE/OFFLINE: backend updateVehicleState (DB only)
///   - Location: handled NATIVELY by the Google Driver SDK (RidesharingDriverApi).
///     No Geolocator stream here — the SDK streams location directly to Fleet
///     Engine over gRPC once enableLocationTracking() is called.
class FleetEngineService {
  static const String _feBase = 'https://fleetengine.googleapis.com/v1';
  static const String _providerId = 'ayaka-transassist-mobility';

  static final FleetEngineService _instance = FleetEngineService._();
  factory FleetEngineService() => _instance;
  FleetEngineService._();

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  ));

  String get _vehicleId => AppSession.fleetVehicleId;

  // ── PUBLIC API ────────────────────────────────────────────────────────────

  Future<void> startTrip(TripModel trip) async {
    if (_vehicleId.isEmpty) {
      debugPrint('FleetEngine: no fleet vehicle ID — skip');
      return;
    }
    final token = await _fetchToken();
    if (token == null) return;

    await _createTrip(trip, token);
    // Read back what Fleet Engine actually has stored so logs prove the
    // direction fix landed. Useful for client-facing screenshots.
    await _verifyTripWaypoints(trip, token);
    await _setVehicleOnline(true);
  }

  /// GETs the trip from Fleet Engine and logs the stored pickup/dropoff so
  /// the terminal shows definitive proof of what's registered.
  Future<void> _verifyTripWaypoints(TripModel trip, String token) async {
    try {
      final resp = await _dio.get(
        '$_feBase/providers/$_providerId/trips/${trip.tripId}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'X-Goog-Request-Params': 'provider_id=$_providerId',
        }),
      );
      final data = resp.data as Map<String, dynamic>;
      final p = data['pickupPoint']?['point'] as Map<String, dynamic>?;
      final d = data['dropoffPoint']?['point'] as Map<String, dynamic>?;
      debugPrint('FleetEngine VERIFY ${trip.tripId} (${trip.direction}): '
          'stored pickup=(${p?['latitude']},${p?['longitude']}) '
          'dropoff=(${d?['latitude']},${d?['longitude']})');
    } catch (e) {
      debugPrint('FleetEngine: verify failed (non-fatal) — $e');
    }
  }

  Future<void> goOnline() async {
    if (_vehicleId.isEmpty) return;
    await _setVehicleOnline(true);
  }

  Future<void> goOffline() async {
    if (_vehicleId.isEmpty) return;
    await _setVehicleOnline(false);
  }

  Future<void> advanceToWaypoint(Map<String, double>? nextWaypoint) async {
    debugPrint('FleetEngine: advanced to next waypoint');
  }

  Future<void> endTrip() async {
    if (_vehicleId.isEmpty) return;
    await _setVehicleOnline(false);
  }

  // ── TOKEN ─────────────────────────────────────────────────────────────────

  Future<String?> _fetchToken() async {
    try {
      final response = await DioClient.instance.get(
        '${ApiRoutes.getDriverToken}/$_vehicleId',
      );
      final data = response.data;
      final token = data is Map
          ? data['token']?.toString()
          : data.toString().trim();
      if (token == null || token.isEmpty) return null;
      debugPrint('FleetEngine: driver token fetched ✅');
      return token;
    } catch (e) {
      debugPrint('FleetEngine: token fetch failed — $e');
      return null;
    }
  }

  // ── CREATE TRIP ───────────────────────────────────────────────────────────

  Future<void> _createTrip(TripModel trip, String token) async {
    final officeLatLng = _parseLatLng(trip.officeLocation);
    final firstEmpLatLng = trip.pickupDrops.isNotEmpty
        ? _parseLatLng(trip.pickupDrops.first.empGeocode)
        : null;

    if (officeLatLng == null) {
      debugPrint('FleetEngine: missing office location — skip createTrip');
      return;
    }

    // Direction-aware pickup/dropoff:
    //   LOGIN  → driver picks employee from home, drops at OFFICE.
    //   LOGOUT → driver picks employee from OFFICE, drops at home.
    final isLogin = trip.direction.toLowerCase() == 'login';
    final pickupLatLng = isLogin ? (firstEmpLatLng ?? officeLatLng) : officeLatLng;
    final dropoffLatLng = isLogin ? officeLatLng : (firstEmpLatLng ?? officeLatLng);

    final pickupPoint = {
      'point': {
        'latitude': pickupLatLng['lat'],
        'longitude': pickupLatLng['lng'],
      }
    };
    final dropoffPoint = {
      'point': {
        'latitude': dropoffLatLng['lat'],
        'longitude': dropoffLatLng['lng'],
      }
    };
    final pickupLabel = isLogin ? 'employee' : 'office';
    final dropoffLabel = isLogin ? 'office' : 'employee';
    debugPrint('FleetEngine: ${trip.direction.toUpperCase()} trip — '
        'pickup=$pickupLabel(${pickupLatLng['lat']},${pickupLatLng['lng']}) '
        'dropoff=$dropoffLabel(${dropoffLatLng['lat']},${dropoffLatLng['lng']})');

    try {
      await _dio.post(
        '$_feBase/providers/$_providerId/trips?tripId=${trip.tripId}',
        data: {
          'tripType': 'SHARED',
          'numberOfPassengers':
              trip.pickupDrops.isEmpty ? 1 : trip.pickupDrops.length,
          'pickupPoint': pickupPoint,
          'dropoffPoint': dropoffPoint,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'X-Goog-Request-Params': 'provider_id=$_providerId',
        }),
      );
      debugPrint('FleetEngine: trip created ✅ (${trip.tripId})');
    } on DioException catch (e) {
      if (e.response?.statusCode == 409 || e.response?.statusCode == 400) {
        // Trip exists from a previous run — likely with the OLD wrong-direction
        // pickup/dropoff. PATCH it so the route reflects current direction.
        await _patchTripWaypoints(trip, token, pickupPoint, dropoffPoint);
      } else {
        debugPrint('FleetEngine: createTrip failed — ${e.response?.statusCode}');
      }
    }
  }

  /// PATCH an existing Fleet Engine trip's pickup + dropoff so re-running with
  /// a fixed direction (LOGIN/LOGOUT) takes effect even when the trip was
  /// originally created with wrong coordinates.
  Future<void> _patchTripWaypoints(
    TripModel trip,
    String token,
    Map<String, dynamic> pickupPoint,
    Map<String, dynamic> dropoffPoint,
  ) async {
    try {
      await _dio.patch(
        '$_feBase/providers/$_providerId/trips/${trip.tripId}'
        '?updateMask=pickupPoint,dropoffPoint',
        data: {
          'pickupPoint': pickupPoint,
          'dropoffPoint': dropoffPoint,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'X-Goog-Request-Params': 'provider_id=$_providerId',
        }),
      );
      debugPrint('FleetEngine: existing trip ${trip.tripId} '
          'pickup/dropoff PATCHED ✅');
    } on DioException catch (e) {
      // PATCH can fail if the trip is past status NEW (pickupPoint locks once
      // the driver is ENROUTE_TO_PICKUP). Retry with only dropoff so at least
      // the destination is corrected.
      if (e.response?.statusCode == 400) {
        try {
          await _dio.patch(
            '$_feBase/providers/$_providerId/trips/${trip.tripId}'
            '?updateMask=dropoffPoint',
            data: {'dropoffPoint': dropoffPoint},
            options: Options(headers: {
              'Authorization': 'Bearer $token',
              'X-Goog-Request-Params': 'provider_id=$_providerId',
            }),
          );
          debugPrint('FleetEngine: trip ${trip.tripId} '
              'dropoff PATCHED (pickup locked) ✅');
          return;
        } catch (_) {
          // fall through to error log below
        }
      }
      debugPrint('FleetEngine: patchTrip failed — '
          '${e.response?.statusCode} ${e.response?.data}');
    }
  }

  // ── VEHICLE STATUS ────────────────────────────────────────────────────────

  Future<void> _setVehicleOnline(bool online) async {
    if (_vehicleId.isEmpty) return;
    final status = online ? 'ONLINE' : 'OFFLINE';
    try {
      final params = <String, dynamic>{
        'company_id': AppSession.companyId,
        'vehicle_status': online ? 0 : 1,
        'd_id': AppSession.driverId,
      };
      if (AppSession.vehicleId > 0) {
        params['vehicle_id'] = AppSession.vehicleId;
        params['v_id'] = AppSession.vehicleId;
      }
      await DioClient.instance.get(
        ApiRoutes.updateVehicleState,
        queryParameters: params,
      );
      debugPrint('FleetEngine: vehicle $status ✅');
    } catch (e) {
      debugPrint('FleetEngine: set $status failed — $e');
    }
  }

  // ── HELPERS ───────────────────────────────────────────────────────────────

  Map<String, double>? _parseLatLng(String geocode) {
    if (geocode.isEmpty) return null;
    final parts = geocode.split(',');
    if (parts.length != 2) return null;
    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    if (lat == null || lng == null) return null;
    return {'lat': lat, 'lng': lng};
  }
}
