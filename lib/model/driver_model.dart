import 'dart:convert';

class DriverModel {
  final int dId;
  final int userId;
  final String driverName;
  final String driverMail;
  final String driverDob;
  final String driverCity;
  final String driverMobileNo;
  final String driverAltMobileNo;
  final String driverId;
  final String garage;
  final String garageGeocode;
  final String driverCurrentAddress;
  final String driverPermentAddress;
  final String driverGender;
  final int vendorId;
  final int addedById;
  final int driverCompany;
  final String imeiNumber;
  final String simNumber;
  final int driverStatus;
  final String? rejectReason;
  final int driverApproval;

  const DriverModel({
    required this.dId,
    required this.userId,
    required this.driverName,
    required this.driverMail,
    required this.driverDob,
    required this.driverCity,
    required this.driverMobileNo,
    required this.driverAltMobileNo,
    required this.driverId,
    required this.garage,
    required this.garageGeocode,
    required this.driverCurrentAddress,
    required this.driverPermentAddress,
    required this.driverGender,
    required this.vendorId,
    required this.addedById,
    required this.driverCompany,
    required this.imeiNumber,
    required this.simNumber,
    required this.driverStatus,
    this.rejectReason,
    required this.driverApproval,
  });

  factory DriverModel.fromJson(Map<String, dynamic> j) {
    return DriverModel(
      dId: j['d_id'] ?? 0,
      userId: j['user_id'] ?? 0,
      driverName: j['driver_name'] ?? '',
      driverMail: j['driver_mail'] ?? '',
      driverDob: j['driver_dob'] ?? '',
      driverCity: j['driver_city'] ?? '',
      driverMobileNo: j['driver_mobileNo'] ?? '',
      driverAltMobileNo: j['driver_Alt_mobileNo'] ?? '',
      driverId: j['driver_id'] ?? '',
      garage: j['garage'] ?? '',
      garageGeocode: j['garage_geocode'] ?? '',
      driverCurrentAddress: j['driver_currentAddress'] ?? '',
      driverPermentAddress: j['driver_permentAddress'] ?? '',
      driverGender: j['driver_gender'] ?? '',
      vendorId: j['vendor_id'] ?? 1,
      addedById: j['added_by_id'] ?? 0,
      driverCompany: j['driver_company'] ?? 5,
      imeiNumber: j['imei_number'] ?? '',
      simNumber: j['sim_number'] ?? '',
      driverStatus: j['driver_status'] ?? 0,
      rejectReason: j['reject_reson'],
      driverApproval: j['driver_approval'] ?? 0,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
        'd_id': dId,
        'user_id': userId,
        'driver_name': driverName,
        'driver_mail': driverMail,
        'driver_dob': driverDob,
        'driver_city': driverCity,
        'driver_mobileNo': driverMobileNo,
        'driver_Alt_mobileNo': driverAltMobileNo,
        'driver_id': driverId,
        'garage': garage,
        'garage_geocode': garageGeocode,
        'driver_currentAddress': driverCurrentAddress,
        'driver_permentAddress': driverPermentAddress,
        'driver_gender': driverGender,
        'vendor_id': vendorId,
        'added_by_id': addedById,
        'driver_company': driverCompany,
        'imei_number': imeiNumber,
        'sim_number': simNumber,
        'driver_status': driverStatus,
        'reject_reson': rejectReason,
        'driver_approval': driverApproval,
      };

  factory DriverModel.fromJsonString(String source) =>
      DriverModel.fromJson(jsonDecode(source));
}
