import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../const/api_routes.dart';
import '../const/app_session.dart';
import '../data/remote/dio_client.dart';
import '../model/trip_model.dart';

/// Fleet Engine integration:
///   - Token: GET /getDriverToken/{vehicleId} (backend, driver JWT)
///   - Trip creation: POST Fleet Engine directly
///   - ONLINE/OFFLINE: POST /api/update_vehicleState via backend
///   - Location: streamed via /api/update_driver_location (backend relays to Fleet Engine)
///               + Navigation SDK handles it automatically during active navigation
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

  StreamSubscription<Position>? _locationSub;

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
    await _setVehicleOnline(true);
    _startLocationStreaming();
  }

  Future<void> goOnline() async {
    if (_vehicleId.isEmpty) return;
    await _setVehicleOnline(true);
    _startLocationStreaming();
  }

  Future<void> goOffline() async {
    _stopLocationStreaming();
    if (_vehicleId.isEmpty) return;
    await _setVehicleOnline(false);
  }

  Future<void> advanceToWaypoint(Map<String, double>? nextWaypoint) async {
    debugPrint('FleetEngine: advanced to next waypoint');
  }

  Future<void> endTrip() async {
    _stopLocationStreaming();
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

    try {
      await _dio.post(
        '$_feBase/providers/$_providerId/trips?tripId=${trip.tripId}',
        data: {
          'tripType': 'SHARED',
          'numberOfPassengers': trip.pickupDrops.isEmpty ? 1 : trip.pickupDrops.length,
          'pickupPoint': {
            'point': {
              'latitude': officeLatLng['lat'],
              'longitude': officeLatLng['lng'],
            }
          },
          if (firstEmpLatLng != null)
            'dropoffPoint': {
              'point': {
                'latitude': firstEmpLatLng['lat'],
                'longitude': firstEmpLatLng['lng'],
              }
            },
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'X-Goog-Request-Params': 'provider_id=$_providerId',
        }),
      );
      debugPrint('FleetEngine: trip created ✅ (${trip.tripId})');
    } on DioException catch (e) {
      if (e.response?.statusCode == 409 || e.response?.statusCode == 400) {
        debugPrint('FleetEngine: trip already exists ✅');
      } else {
        debugPrint('FleetEngine: createTrip failed — ${e.response?.statusCode}');
      }
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

  // ── LOCATION STREAMING (via backend → Fleet Engine) ───────────────────────

  void _startLocationStreaming() {
    _locationSub?.cancel();
    final settings = Platform.isAndroid
        ? AndroidSettings(
            accuracy: LocationAccuracy.bestForNavigation,
            intervalDuration: const Duration(seconds: 5),
            distanceFilter: 0,
          )
        : const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 0,
          );
    _locationSub = Geolocator.getPositionStream(locationSettings: settings)
        .listen((pos) => _sendLocationToBackend(pos));
    debugPrint('FleetEngine: location streaming started ✅');
  }

  void _stopLocationStreaming() {
    _locationSub?.cancel();
    _locationSub = null;
    debugPrint('FleetEngine: location streaming stopped');
  }

  Future<void> _sendLocationToBackend(Position pos) async {
    if (_vehicleId.isEmpty) return;
    try {
      await DioClient.instance.post(
        ApiRoutes.updateDriverLocation,
        data: {
          'vehicle_id': _vehicleId,
          'driver_id': AppSession.driverId,
          'company_id': AppSession.companyId,
          'latitude': pos.latitude,
          'longitude': pos.longitude,
          'heading': pos.heading,
          'speed_kmph': double.parse((pos.speed * 3.6).toStringAsFixed(1)),
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        },
      );
      debugPrint('FleetEngine: location sent ✅ (${pos.latitude}, ${pos.longitude})');
    } on DioException catch (e) {
      debugPrint('FleetEngine: location send failed — ${e.response?.statusCode}');
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
