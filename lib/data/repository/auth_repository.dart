import 'package:flutter/foundation.dart';
import '../../const/api_routes.dart';
import '../../const/app_session.dart';
import '../../model/api_response_model.dart';
import '../../model/driver_model.dart';
import '../remote/dio_client.dart';

class AuthRepository {
  // Returns (userId, statusMessage). Throws on network error.
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

  // Returns full driver + access token on success. Throws on network error.
  Future<({DriverModel? driver, String accessToken, String profilePhoto, ApiStatus status})>
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
      return (driver: null, accessToken: '', profilePhoto: '', status: status);
    }

    final driver = DriverModel.fromJson(data['driver'] as Map<String, dynamic>);
    final token = data['access_token']?.toString() ?? '';
    final photo = data['profile_photo']?.toString() ?? '';

    debugPrint('← driver: ${driver.driverName}, company: ${driver.driverCompany}');

    await AppSession.saveSession(
      userId: driver.userId,
      driverId: driver.dId,
      companyId: driver.driverCompany,
      vendorId: driver.vendorId,
      accessToken: token,
      driverName: driver.driverName,
      profilePhoto: photo,
      driverData: driver.toJsonString(),
    );

    return (driver: driver, accessToken: token, profilePhoto: photo, status: status);
  }

  Future<void> logout() async {
    debugPrint('=== SESSION: logout — clearing stored data ===');
    await AppSession.clearSession();
  }
}
