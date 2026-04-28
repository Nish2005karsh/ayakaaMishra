import 'package:flutter/foundation.dart';
import '../../const/api_routes.dart';
import '../../const/app_session.dart';
import '../../model/api_response_model.dart';
import '../../model/vehicle_model.dart';
import '../remote/dio_client.dart';

class VehicleRepository {
  Future<List<VehicleType>> getVehicleTypes() async {
    final companyId = AppSession.companyId;
    debugPrint('=== API CALL: vehicle_types ===');
    debugPrint('→ company_id: $companyId');

    final response = await DioClient.instance.get(
      ApiRoutes.vehicleTypes,
      queryParameters: {'company_id': companyId},
    );

    debugPrint('← response: ${response.data}');

    final data = response.data as Map<String, dynamic>;
    final status = ApiStatus.fromJson(data['status']);
    if (!status.isSuccess) {
      debugPrint('vehicle_types failed: ${status.message}');
      return [];
    }

    // API confirmed (from logs): response key is 'data', not 'vehicleTypes'
    final list = (data['data'] ?? data['vehicleTypes']) as List<dynamic>? ?? [];
    return list.map((e) => VehicleType.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Contract>> getContractList({required int vtId}) async {
    final companyId = AppSession.companyId;
    debugPrint('=== API CALL: contract_list ===');
    debugPrint('→ company_id: $companyId, vt_id: $vtId, v_id: 0');

    final response = await DioClient.instance.get(
      ApiRoutes.contractList,
      queryParameters: {
        'company_id': companyId,
        'vt_id': vtId,
        'v_id': 0,
      },
    );

    debugPrint('← response: ${response.data}');

    final data = response.data as Map<String, dynamic>;
    final status = ApiStatus.fromJson(data['status']);
    if (!status.isSuccess) {
      debugPrint('contract_list failed: ${status.message}');
      return [];
    }

    // Try both 'data' and 'contracts' keys — confirm from logs when contracts load
    final list = (data['data'] ?? data['contracts']) as List<dynamic>? ?? [];
    return list.map((e) => Contract.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ApiStatus> registerVehicle({
    required String vehicleNumber,
    required String vehicleName,
    required int vehicleTypeId,
    required int contractId,
  }) async {
    final driverId = AppSession.driverId;
    final companyId = AppSession.companyId;
    final vendorId = AppSession.vendorId;

    debugPrint('=== API CALL: vehicle_insert ===');
    debugPrint('→ d_id: $driverId, company_id: $companyId, vendor_id: $vendorId');
    debugPrint('→ v_number: $vehicleNumber, v_name: $vehicleName');
    debugPrint('→ vehicle_type_id: $vehicleTypeId, contract_id: $contractId');

    // SQL confirmed (from logs): backend column names differ from what we assumed.
    // vehicle_id = FK to vehicle type (not vehicle_type_id)
    // registerno = registration number (not v_number)
    // vehicle_addeBy + driver = d_id of driver adding the vehicle
    final response = await DioClient.instance.post(
      ApiRoutes.vehicleInsert,
      data: {
        'd_id': driverId,
        'company_id': companyId,
        'vendor_id': vendorId,
        'v_number': vehicleNumber,
        'registerno': vehicleNumber,
        'v_name': vehicleName,
        'vehicle_name': vehicleName,
        'vehicle_type_id': vehicleTypeId,
        'vehicle_id': vehicleTypeId,
        'vehicle_type': vehicleTypeId,
        'contract_id': contractId,
        'vehicle_status': 0,
        'vehicle_addeBy': driverId,
        'driver': driverId,
        'garage_name': '',
        'garage_geo_code': '',
        'comment': '',
        'contract_start_date': '',
      },
    );

    debugPrint('← response: ${response.data}');

    final data = response.data as Map<String, dynamic>;

    // vehicle_insert returns {code, message} flat — NOT {status:{code,message}} like other APIs.
    // Handle both formats defensively.
    final statusMap = (data['status'] is Map)
        ? data['status'] as Map<String, dynamic>
        : data;

    // Store vehicle ID returned by backend (needed for online/offline toggle)
    final returnedVehicleId = data['vehicle_id'] ?? data['v_id'];
    if (returnedVehicleId != null) {
      await AppSession.saveVehicleId(returnedVehicleId as int);
      debugPrint('← stored vehicle_id: $returnedVehicleId');
    }

    debugPrint('← status: ${statusMap['code']} — ${statusMap['message']}');
    return ApiStatus.fromJson(statusMap);
  }
}
