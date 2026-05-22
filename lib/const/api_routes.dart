class ApiRoutes {
  static const String _base = 'https://royalblue-kudu-237366.hostingersite.com/api';

  static const String driverLogin = '$_base/driver_login';
  static const String verifyOtp = '$_base/verify_otp';
  static const String vehicleInsert = '$_base/vehicle_insert';
  static const String documentNames = '$_base/documentNames';
  static const String uploadDocs = '$_base/upload_docs';
  static const String vehicleTypes = '$_base/vehicle_types';
  static const String documentNamesList = '$_base/document_names';
  static const String contractList = '$_base/contract_list';
  static const String tripList = '$_base/trip_list';
  static const String tripDetails = '$_base/trip_details';
  static const String documentDetails = '$_base/document_details';
  static const String updateVehicleState = '$_base/update_vehicleState';
  static const String tripOtpVerify = '$_base/trip_otp_verify';

  // Fleet Engine — web routes (no /api/ prefix)
  static const String _webBase = 'https://royalblue-kudu-237366.hostingersite.com';
  static const String getAccessToken    = '$_webBase/getAccessToken';
  static const String getDriverToken   = '$_webBase/getDriverToken';
  static const String createFleetTrip   = '$_webBase/create-trip';
  static const String updateFleetVehicle = '$_webBase/updateCustomVehicle';

  // Trip timing — actual driver arrival and employee pickup timestamps
  static const String tripArrival = '$_base/trip_arrival';

  // Proximity trigger — driver is near a waypoint
  static const String driverNearWaypoint = '$_base/driver_near_waypoint';

  // No show — employee did not board the cab
  static const String noShow = '$_base/no_show';

  // Live location — driver sends GPS when ONLINE to relay to Fleet Engine
  static const String updateDriverLocation = '$_base/update_driver_location';

  // Trip completion — flips trip_status so admin panel moves it to "completed"
  static const String tripComplete = '$_base/trip_complete';
}
