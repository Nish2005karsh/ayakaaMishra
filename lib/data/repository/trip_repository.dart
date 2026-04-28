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

  // GET /trip_details
  Future<Map<String, dynamic>> getTripDetails(String tripId) async {
    final driverId = AppSession.driverId;
    debugPrint('=== API CALL: trip_details ===');
    debugPrint('→ tripID: $tripId, d_id: $driverId');

    final response = await DioClient.instance.get(
      ApiRoutes.tripDetails,
      queryParameters: {'tripID': tripId, 'd_id': driverId},
    );
    debugPrint('← status: ${response.statusCode}');
    debugPrint('← data: ${response.data}');
    return response.data as Map<String, dynamic>;
  }

  // GET /trip_otp_verify
  Future<ApiStatus> verifyTripOtp({
    required String tripId,
    required int empId,
    required String otp,
  }) async {
    final driverId = AppSession.driverId;
    debugPrint('=== API CALL: trip_otp_verify ===');
    debugPrint('→ tripID: $tripId, emp_id: $empId, otp: $otp, d_id: $driverId');

    final response = await DioClient.instance.get(
      ApiRoutes.tripOtpVerify,
      queryParameters: {
        'tripID': tripId,
        'emp_id': empId,
        'otp': otp,
        'd_id': driverId,
      },
    );
    debugPrint('← data: ${response.data}');
    final data = response.data as Map<String, dynamic>;
    return ApiStatus.fromJson(data['status']);
  }

  // GET /update_vehicleState
  // Doc-confirmed params: company_id, vehicle_id, vehicle_status
  // NOTE: vehicle_id must be obtained from /vehicle_insert response.
  // The backend does NOT currently return vehicle_id — see BACKEND_ISSUES.html.
  Future<ApiStatus> updateVehicleState({required bool isOnline}) async {
    final companyId = AppSession.companyId;
    final vehicleId = AppSession.vehicleId;
    // API: 0 = online, 1 = offline (per spec)
    final vehicleStatus = isOnline ? 0 : 1;

    debugPrint('=== API CALL: update_vehicleState ===');
    debugPrint('→ company_id: $companyId, vehicle_id: $vehicleId, vehicle_status: $vehicleStatus (${isOnline ? 'ONLINE' : 'OFFLINE'})');

    // Only include vehicle_id when valid — backend rejects 0
    final params = <String, dynamic>{
      'company_id': companyId,
      'vehicle_status': vehicleStatus,
    };
    if (vehicleId > 0) params['vehicle_id'] = vehicleId;

    final response = await DioClient.instance.get(
      ApiRoutes.updateVehicleState,
      queryParameters: params,
    );
    debugPrint('← data: ${response.data}');

    final data = response.data as Map<String, dynamic>;
    return ApiStatus.fromJson(data['status']);
  }
}
