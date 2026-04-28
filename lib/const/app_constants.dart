class AppConstants {
  static const String appName = 'AYAKAA Driver';

  // SharedPreferences keys
  static const String keyAccessToken = 'access_token';
  static const String keyUserId = 'user_id';
  static const String keyDriverId = 'd_id';
  static const String keyCompanyId = 'company_id';
  static const String keyVendorId = 'vendor_id';
  static const String keyDriverData = 'driver_data';
  static const String keyDriverName = 'driver_name';
  static const String keyProfilePhoto = 'profile_photo';
  static const String keyVehicleId = 'vehicle_id'; // stored after vehicle_insert

  // TEAM NOTE (see DECISIONS.md §5): company_id comes from driver.driver_company
  // in the OTP verify response. Fallback 5 matches API example default.
  static const int fallbackCompanyId = 5;

  // vendor_id — open question, hardcoded from API examples (see DECISIONS.md §9 Q5)
  static const int fallbackVendorId = 1;

  static const String photoBaseUrl =
      'https://royalblue-kudu-237366.hostingersite.com/';
}
