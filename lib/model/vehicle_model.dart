class VehicleType {
  final int vtId;
  final String vehicleType;

  const VehicleType({required this.vtId, required this.vehicleType});

  factory VehicleType.fromJson(Map<String, dynamic> j) {
    return VehicleType(
      // API returns vehicle_type_id + vehicle_type_name (confirmed from logs)
      vtId: j['vehicle_type_id'] ?? j['vt_id'] ?? 0,
      vehicleType: j['vehicle_type_name']?.toString() ?? j['vehicle_type']?.toString() ?? '',
    );
  }

  @override
  String toString() => vehicleType;
}

class Contract {
  final int contractId;
  final String contractName;

  const Contract({required this.contractId, required this.contractName});

  factory Contract.fromJson(Map<String, dynamic> j) {
    return Contract(
      contractId: j['contract_id'] ?? 0,
      contractName: j['contract_name']?.toString() ?? '',
    );
  }

  @override
  String toString() => contractName;
}
