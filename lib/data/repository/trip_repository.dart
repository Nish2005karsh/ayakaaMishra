import 'package:flutter/foundation.dart';
import '../../const/api_routes.dart';
import '../../const/app_session.dart';
import '../../model/api_response_model.dart';
import '../../model/trip_model.dart';
import '../remote/dio_client.dart';

class TripRepository {
  // GET /trip_list
  // Doc-confirmed params: company_id, driver_id, tripHistory (bool)
  Future<TripListResult> getTripList() async {
    final driverId = AppSession.driverId;
    final companyId = AppSession.companyId;
    debugPrint('=== API CALL: trip_list ===');
    debugPrint('→ driver_id: $driverId, company_id: $companyId, tripHistory: false');

    final response = await DioClient.instance.get(
      ApiRoutes.tripList,
      queryParameters: {
        'company_id': companyId,
        'driver_id': driverId,
        'tripHistory': false,
      },
    );
    debugPrint('← status: ${response.statusCode}');
    debugPrint('← data: ${response.data}');

    final data = response.data as Map<String, dynamic>;
    final status = ApiStatus.fromJson(data['status']);

    if (!status.isSuccess) {
      // "Something went wrong" with code 0 = backend bug meaning "no trips yet"
      final isNoTrips = status.message.toLowerCase().contains('something went wrong');
      if (isNoTrips) {
        debugPrint('trip_list: no trips assigned to this driver');
      } else {
        debugPrint('trip_list failed: ${status.message}');
      }
      return const TripListResult(upcoming: [], ongoing: [], completed: [], rejected: []);
    }

    // Doc-confirmed structure: data is an OBJECT with named keys (not a flat array)
    // { "upcoming": [...], "ongoing": [...], "completed": [...], "rejected": [...] }
    final rawData = data['data'];
    debugPrint('← rawData type: ${rawData.runtimeType}');

    if (rawData == null || rawData is List) {
      // Empty list or null → no trips
      debugPrint('← trip_list: empty data');
      return const TripListResult(upcoming: [], ongoing: [], completed: [], rejected: []);
    }

    if (rawData is Map) {
      List<TripModel> parse(String key, TripStatus s) =>
          ((rawData[key] as List<dynamic>?) ?? [])
              .map((e) => TripModel.fromJson(e as Map<String, dynamic>, status: s))
              .toList();

      final result = TripListResult(
        upcoming: parse('upcoming', TripStatus.upcoming),
        ongoing: parse('ongoing', TripStatus.ongoing),
        completed: parse('completed', TripStatus.completed),
        rejected: parse('rejected', TripStatus.rejected),
      );
      debugPrint('← trips: upcoming=${result.upcoming.length}, '
          'ongoing=${result.ongoing.length}, '
          'completed=${result.completed.length}, '
          'rejected=${result.rejected.length}');
      return result;
    }

    return const TripListResult(upcoming: [], ongoing: [], completed: [], rejected: []);
  }

  // GET /trip_details — API params: company_id, trip_id
  Future<Map<String, dynamic>> getTripDetails(String tripId) async {
    final companyId = AppSession.companyId;
    debugPrint('=== API CALL: trip_details ===');
    debugPrint('→ trip_id: $tripId, company_id: $companyId');

    final response = await DioClient.instance.get(
      ApiRoutes.tripDetails,
      queryParameters: {'trip_id': tripId, 'company_id': companyId},
    );
    debugPrint('← status: ${response.statusCode}');
    debugPrint('← data: ${response.data}');
    return response.data as Map<String, dynamic>;
  }

  // GET /trip_otp_verify
  // API params (from docs): company_id, trip_id, emp_id, otp
  Future<ApiStatus> verifyTripOtp({
    required String tripId,
    required int empId,
    required String otp,
  }) async {
    final companyId = AppSession.companyId;
    debugPrint('=== API CALL: trip_otp_verify ===');
    debugPrint('→ trip_id: $tripId, emp_id: $empId, otp: $otp, company_id: $companyId');

    final response = await DioClient.instance.get(
      ApiRoutes.tripOtpVerify,
      queryParameters: {
        'trip_id'   : tripId,   // API uses trip_id, not tripID
        'emp_id'    : empId,
        'otp'       : otp,
        'company_id': companyId, // API uses company_id, not d_id
      },
    );
    debugPrint('← data: ${response.data}');
    final data = response.data as Map<String, dynamic>;
    return ApiStatus.fromJson(data['status']);
  }

  // POST /no_show
  // Called when driver arrives but employee does not board
  Future<ApiStatus> reportNoShow({
    required String tripId,
    required int empId,
  }) async {
    final companyId = AppSession.companyId;
    final driverId = AppSession.driverId;
    debugPrint('=== API CALL: no_show ===');
    debugPrint('→ trip_id: $tripId, emp_id: $empId, company_id: $companyId');
    try {
      final response = await DioClient.instance.post(
        ApiRoutes.noShow,
        data: {
          'trip_id': tripId,
          'emp_id': empId,
          'company_id': companyId,
          'driver_id': driverId,
          'no_show_time': DateTime.now().toUtc().toIso8601String(),
        },
      );
      debugPrint('← no_show: ${response.data}');
      final data = response.data as Map<String, dynamic>;
      return ApiStatus.fromJson(data['status'] ?? data);
    } catch (e) {
      debugPrint('no_show failed: $e');
      return const ApiStatus(code: '1', message: 'Failed to report no show');
    }
  }

  // POST /driver_near_waypoint
  // Called once when driver enters 300m radius of the next pickup point
  Future<void> sendProximityAlert({
    required String tripId,
    required int empId,
    required double latitude,
    required double longitude,
    required double distanceMeters,
  }) async {
    final companyId = AppSession.companyId;
    final driverId = AppSession.driverId;
    debugPrint('=== API CALL: driver_near_waypoint ===');
    debugPrint('→ trip_id: $tripId, emp_id: $empId, distance: ${distanceMeters.toStringAsFixed(0)}m');
    try {
      await DioClient.instance.post(
        ApiRoutes.driverNearWaypoint,
        data: {
          'trip_id': tripId,
          'emp_id': empId,
          'company_id': companyId,
          'driver_id': driverId,
          'latitude': latitude,
          'longitude': longitude,
          'distance_meters': distanceMeters.toStringAsFixed(0),
          'triggered_at': DateTime.now().toUtc().toIso8601String(),
        },
      );
      debugPrint('← driver_near_waypoint: sent ✅');
    } catch (e) {
      debugPrint('driver_near_waypoint failed (non-critical): $e');
    }
  }

  // POST /trip_arrival
  // Called when driver physically arrives at a pickup/drop waypoint
  // Sends: trip_id, emp_id, company_id, actual_arrival_time (UTC ISO8601)
  Future<void> recordArrival({
    required String tripId,
    required int empId,
    required String actualArrivalTime,
  }) async {
    final companyId = AppSession.companyId;
    final driverId = AppSession.driverId;
    debugPrint('=== API CALL: trip_arrival ===');
    debugPrint('→ trip_id: $tripId, emp_id: $empId, arrival_time: $actualArrivalTime');
    try {
      final response = await DioClient.instance.post(
        ApiRoutes.tripArrival,
        data: {
          'trip_id': tripId,
          'emp_id': empId,
          'company_id': companyId,
          'driver_id': driverId,
          'actual_arrival_time': actualArrivalTime,
        },
      );
      debugPrint('← trip_arrival: ${response.data}');
    } catch (e) {
      debugPrint('trip_arrival failed (non-critical): $e');
    }
  }

  // POST /trip_complete
  // Called after the driver finishes the last waypoint. Flips trip_status
  // on the backend so the admin panel moves the trip out of "ongoing".
  Future<ApiStatus> completeTrip({required String tripId}) async {
    final companyId = AppSession.companyId;
    final driverId = AppSession.driverId;
    debugPrint('=== API CALL: trip_complete ===');
    debugPrint('→ trip_id: $tripId, company_id: $companyId, driver_id: $driverId');
    try {
      final response = await DioClient.instance.post(
        ApiRoutes.tripComplete,
        data: {
          'trip_id': tripId,
          'company_id': companyId,
          'driver_id': driverId,
          'completed_time': DateTime.now().toUtc().toIso8601String(),
        },
      );
      debugPrint('← trip_complete: ${response.data}');
      final data = response.data as Map<String, dynamic>;
      return ApiStatus.fromJson(data['status'] ?? data);
    } catch (e) {
      debugPrint('trip_complete failed: $e');
      return const ApiStatus(code: '1', message: 'Failed to mark trip complete');
    }
  }

  // GET /update_vehicleState
  // Doc-confirmed params: company_id, vehicle_id, vehicle_status
  // NOTE: vehicle_id must be obtained from /vehicle_insert response.
  // The backend does NOT currently return vehicle_id — see BACKEND_ISSUES.html.
  Future<ApiStatus> updateVehicleState({required bool isOnline}) async {
    final companyId = AppSession.companyId;
    final vehicleId = AppSession.vehicleId;
    final driverId = AppSession.driverId;
    
    // API: 0 = online, 1 = offline (per spec)
    final vehicleStatus = isOnline ? 0 : 1;

    debugPrint('=== API CALL: update_vehicleState ===');
    debugPrint('→ company_id: $companyId, vehicle_id: $vehicleId, d_id: $driverId, vehicle_status: $vehicleStatus (${isOnline ? 'ONLINE' : 'OFFLINE'})');

    final params = <String, dynamic>{
      'company_id': companyId,
      'vehicle_status': vehicleStatus,
      'd_id': driverId,
    };
    
    // Send both variants to be safe with backend inconsistencies
    if (vehicleId > 0) {
      params['vehicle_id'] = vehicleId;
      params['v_id'] = vehicleId;
    }

    final response = await DioClient.instance.get(
      ApiRoutes.updateVehicleState,
      queryParameters: params,
    );
    debugPrint('← data: ${response.data}');

    final data = response.data as Map<String, dynamic>;
    
    // Handle both nested {status: {code, message}} and flat {code, message} formats
    final statusMap = (data['status'] is Map)
        ? data['status'] as Map<String, dynamic>
        : data;
        
    return ApiStatus.fromJson(statusMap);
  }
}
