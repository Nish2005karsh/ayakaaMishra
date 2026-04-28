import 'package:shared_preferences/shared_preferences.dart';
import 'app_constants.dart';

// Singleton session wrapper around SharedPreferences.
// Call AppSession.init() before runApp().
// All repository classes read company_id / driver_id from here.
class AppSession {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isLoggedIn => accessToken.isNotEmpty;

  static String get accessToken =>
      _prefs.getString(AppConstants.keyAccessToken) ?? '';

  static int get userId =>
      _prefs.getInt(AppConstants.keyUserId) ?? 0;

  static int get driverId =>
      _prefs.getInt(AppConstants.keyDriverId) ?? 0;

  // TEAM NOTE (DECISIONS.md §5): stored from driver.driver_company on login.
  // When company_id becomes fully dynamic from API, update saveSession() only.
  static int get companyId =>
      _prefs.getInt(AppConstants.keyCompanyId) ?? AppConstants.fallbackCompanyId;

  static int get vendorId =>
      _prefs.getInt(AppConstants.keyVendorId) ?? AppConstants.fallbackVendorId;

  static String get driverName =>
      _prefs.getString(AppConstants.keyDriverName) ?? '';

  static String get profilePhoto =>
      _prefs.getString(AppConstants.keyProfilePhoto) ?? '';

  // Vehicle ID stored after successful vehicle_insert.
  // Required by update_vehicleState to identify which vehicle to toggle.
  static int get vehicleId =>
      _prefs.getInt(AppConstants.keyVehicleId) ?? 0;

  static Future<void> saveVehicleId(int vehicleId) async {
    await _prefs.setInt(AppConstants.keyVehicleId, vehicleId);
  }

  static Future<void> saveSession({
    required int userId,
    required int driverId,
    required int companyId,
    required int vendorId,
    required String accessToken,
    required String driverName,
    required String profilePhoto,
    required String driverData,
  }) async {
    await Future.wait([
      _prefs.setInt(AppConstants.keyUserId, userId),
      _prefs.setInt(AppConstants.keyDriverId, driverId),
      _prefs.setInt(AppConstants.keyCompanyId, companyId),
      _prefs.setInt(AppConstants.keyVendorId, vendorId),
      _prefs.setString(AppConstants.keyAccessToken, accessToken),
      _prefs.setString(AppConstants.keyDriverName, driverName),
      _prefs.setString(AppConstants.keyProfilePhoto, profilePhoto),
      _prefs.setString(AppConstants.keyDriverData, driverData),
    ]);
  }

  static Future<void> clearSession() async {
    await _prefs.clear();
  }
}
