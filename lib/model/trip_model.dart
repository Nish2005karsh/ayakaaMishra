class PickupDrop {
  final int empId;
  final String empName;
  final String empAddress;  // API: location_address
  final String empGeocode;  // API: geolocation
  final String otp;
  final String boardingTime; // API: boarding_time — scheduled pickup time
  final String dropTime;     // API: drop_time — scheduled drop time

  const PickupDrop({
    required this.empId,
    required this.empName,
    required this.empAddress,
    required this.empGeocode,
    required this.otp,
    this.boardingTime = '',
    this.dropTime = '',
  });

  factory PickupDrop.fromJson(Map<String, dynamic> j) => PickupDrop(
        empId: j['emp_id'] ?? 0,
        empName: j['emp_name']?.toString() ?? '',
        empAddress: j['location_address']?.toString() ??
            j['emp_address']?.toString() ?? '',
        empGeocode: j['geolocation']?.toString() ??
            j['emp_geocode']?.toString() ?? '',
        otp: j['otp']?.toString() ?? '',
        boardingTime: j['boarding_time']?.toString() ?? '',
        dropTime: j['drop_time']?.toString() ?? '',
      );
}

class TripModel {
  final String tripId;
  final String direction;
  final String tripDate;
  final String tripTime;
  final double tripDistance;
  final String officeName;
  final String officeLocation;
  final String employeeAddress;
  final int employeeCount;
  final List<PickupDrop> pickupDrops;
  final TripStatus status;

  const TripModel({
    required this.tripId,
    required this.direction,
    required this.tripDate,
    required this.tripTime,
    required this.tripDistance,
    required this.officeName,
    required this.officeLocation,
    required this.employeeAddress,
    required this.employeeCount,
    required this.pickupDrops,
    required this.status,
  });

  static String _extractTripId(Map<String, dynamic> j) {
    // Try direct fields first
    final direct = j['tripID'] ?? j['trip_id'] ?? j['tripId'];
    if (direct != null && direct.toString().isNotEmpty) return direct.toString();
    // Fall back to waypoints.vehicle.currentTrips[0]
    try {
      final wp = j['waypoints'];
      if (wp is Map) {
        final trips = wp['vehicle']?['currentTrips'];
        if (trips is List && trips.isNotEmpty) return trips.first.toString();
        final wps = wp['waypoints'];
        if (wps is List && wps.isNotEmpty) return wps.first['tripId']?.toString() ?? '';
      }
    } catch (_) {}
    return '';
  }

  factory TripModel.fromJson(Map<String, dynamic> j,
      {TripStatus status = TripStatus.upcoming}) {
    final drops = (j['pickupDrops'] as List<dynamic>? ?? [])
        .map((e) => PickupDrop.fromJson(e as Map<String, dynamic>))
        .toList();
    return TripModel(
      tripId: _extractTripId(j),
      direction: j['trip_direction']?.toString() ?? '',
      tripDate: j['trip_date']?.toString() ?? '',
      tripTime: j['trip_time']?.toString() ?? '',
      tripDistance: (j['trip_distance'] ?? 0).toDouble(),
      officeName: j['office_name']?.toString() ?? '',
      officeLocation: j['office_location']?.toString() ?? '',
      // API returns 'employee_address' (area-level, not per-employee)
      employeeAddress: j['employee_address']?.toString() ?? '',
      employeeCount: j['employee_count'] ?? drops.length,
      pickupDrops: drops,
      status: status,
    );
  }

  String get formattedTime {
    if (tripTime.length >= 5) return tripTime.substring(0, 5);
    return tripTime;
  }

  String get distanceLabel => '${tripDistance.toStringAsFixed(1)} km';
}

enum TripStatus { upcoming, ongoing, completed, rejected }

class TripListResult {
  final List<TripModel> upcoming;
  final List<TripModel> ongoing;
  final List<TripModel> completed;
  final List<TripModel> rejected;

  const TripListResult({
    required this.upcoming,
    required this.ongoing,
    required this.completed,
    required this.rejected,
  });

  bool get isEmpty =>
      upcoming.isEmpty &&
      ongoing.isEmpty &&
      completed.isEmpty &&
      rejected.isEmpty;

  int get totalCount =>
      upcoming.length + ongoing.length + completed.length + rejected.length;
}
