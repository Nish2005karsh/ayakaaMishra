import 'package:flutter/foundation.dart';
import '../../const/api_routes.dart';
import '../../const/app_session.dart';
import '../../model/api_response_model.dart';
import '../../model/driver_model.dart';
import '../remote/dio_client.dart';
import '../../service/driver_sdk_service.dart';
import '../../service/driver_token_cache.dart';

class AuthRepository {
  Future<({int userId, ApiStatus status})> driverLogin(String mobile) async {
    debugPrint('=== API CALL: driver_login ===');
    debugPrint('→ mobile: $mobile');

    final response = await DioClient.instance.post(
      ApiRoutes.driverLogin,
      data: {'mobile': mobile},
    );

    debugPrint('← response: ${response.data}');

    final data = response.data as Map<String, dynamic>;
    final status = ApiStatus.fromJson(data['status']);
    final userId = data['user_id'] as int? ?? 0;

    return (userId: userId, status: status);
  }

  Future<({DriverModel? driver, String accessToken, String profilePhoto, int vehicleId, ApiStatus status})>
      verifyOtp(int userId, String otp) async {
    debugPrint('=== API CALL: verify_otp ===');
    debugPrint('→ user_id: $userId, otp: $otp');

    final response = await DioClient.instance.post(
      ApiRoutes.verifyOtp,
      data: {'user_id': userId, 'otp': otp},
    );

    debugPrint('← response status: ${response.data['status']}');

    final data = response.data as Map<String, dynamic>;
    final status = ApiStatus.fromJson(data['status']);

    if (!status.isSuccess) {
      return (driver: null, accessToken: '', profilePhoto: '', vehicleId: 0, status: status);
    }

    final driverJson = data['driver'] as Map<String, dynamic>;
    debugPrint('DEBUG: Full Driver JSON: $driverJson');
    final driver = DriverModel.fromJson(driverJson);
    final token = data['access_token']?.toString() ?? '';
    final photo = data['profile_photo']?.toString() ?? '';

    // vehicle_id is nested inside the driver object as 'veh_id' (integer)
    // Top-level data['vehicle_id'] / data['v_id'] don't exist in this API.
    final rawVehicleId =
        data['vehicle_id'] ??
        data['v_id'] ??
        driverJson['veh_id'] ??
        driverJson['v_id'];
    final vehicleId = rawVehicleId is int
        ? rawVehicleId
        : int.tryParse(rawVehicleId?.toString() ?? '0') ?? 0;

    // Fleet Engine vehicle ID string — used for REST API calls
    final fleetVehicleId = driverJson['vehicleID']?.toString() ?? '';

    debugPrint('← driver: ${driver.driverName}, company: ${driver.driverCompany}, vehicle_id: $vehicleId');

    await AppSession.saveSession(
      userId: driver.userId,
      driverId: driver.dId,
      companyId: driver.driverCompany,
      vendorId: driver.vendorId,
      accessToken: token,
      driverName: driver.driverName,
      profilePhoto: photo,
      driverData: driver.toJsonString(),
      vehicleId: vehicleId,
      fleetVehicleId: fleetVehicleId,
    );

    debugPrint('Provider ID: ayaka-transassist-mobility');
    debugPrint('Fleet Vehicle ID: $fleetVehicleId');
    debugPrint('DB Vehicle ID: $vehicleId');

    // Driver SDK — Android only, only when fleet vehicle ID is linked.
    // The token callback is configured globally in main.dart with caching,
    // so we don't override it here — we just trigger the initialize.
    if (!kIsWeb && fleetVehicleId.isNotEmpty) {
      try {
        final ok = await DriverSdkService().initialize(
          providerId: 'ayaka-transassist-mobility',
          vehicleId: fleetVehicleId,
        );
        debugPrint('Driver SDK initialize result: $ok (vehicleId=$fleetVehicleId)');
      } catch (e) {
        debugPrint('DriverSdkService init skipped: $e');
      }
    }

    return (driver: driver, accessToken: token, profilePhoto: photo, vehicleId: vehicleId, status: status);
  }

  Future<void> logout() async {
    debugPrint('=== SESSION: logout — clearing stored data ===');
    if (!kIsWeb) {
      try {
        await DriverSdkService().cleanup();
        debugPrint('Driver SDK cleaned up before logout');
      } catch (e) {
        debugPrint('Driver SDK cleanup skipped: $e');
      }
    }
    // Drop the cached JWT so the next driver can't reuse the previous
    // driver's token if they log in on the same device.
    DriverTokenCache.clear();
    await AppSession.clearSession();
  }
}
