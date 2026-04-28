import 'package:flutter/foundation.dart';
import '../data/repository/vehicle_repository.dart';
import '../model/vehicle_model.dart';

enum VehicleFormState { idle, loadingTypes, loadingContracts, submitting, success, error }

class VehicleProvider extends ChangeNotifier {
  final VehicleRepository _repo;

  VehicleProvider(this._repo);

  VehicleFormState state = VehicleFormState.idle;
  String errorMessage = '';

  List<VehicleType> vehicleTypes = [];
  List<Contract> contracts = [];

  VehicleType? selectedType;
  Contract? selectedContract;

  bool get isLoadingTypes => state == VehicleFormState.loadingTypes;
  bool get isLoadingContracts => state == VehicleFormState.loadingContracts;
  bool get isSubmitting => state == VehicleFormState.submitting;
  bool get isSuccess => state == VehicleFormState.success;

  Future<void> loadVehicleTypes() async {
    state = VehicleFormState.loadingTypes;
    errorMessage = '';
    notifyListeners();
    try {
      vehicleTypes = await _repo.getVehicleTypes();
      state = VehicleFormState.idle;
    } catch (e) {
      debugPrint('VehicleProvider loadVehicleTypes error: $e');
      errorMessage = 'Failed to load vehicle types. Check connection.';
      state = VehicleFormState.error;
    }
    notifyListeners();
  }

  Future<void> onVehicleTypeSelected(VehicleType type) async {
    selectedType = type;
    selectedContract = null;
    contracts = [];
    state = VehicleFormState.loadingContracts;
    notifyListeners();
    try {
      contracts = await _repo.getContractList(vtId: type.vtId);
      state = VehicleFormState.idle;
    } catch (e) {
      debugPrint('VehicleProvider loadContracts error: $e');
      errorMessage = 'Failed to load contracts. Check connection.';
      state = VehicleFormState.error;
    }
    notifyListeners();
  }

  void selectContract(Contract contract) {
    selectedContract = contract;
    notifyListeners();
  }

  Future<bool> registerVehicle({
    required String vehicleNumber,
    required String vehicleName,
  }) async {
    if (selectedType == null || selectedContract == null) return false;

    state = VehicleFormState.submitting;
    errorMessage = '';
    notifyListeners();

    try {
      final status = await _repo.registerVehicle(
        vehicleNumber: vehicleNumber,
        vehicleName: vehicleName,
        vehicleTypeId: selectedType!.vtId,
        contractId: selectedContract!.contractId,
      );

      // "Already registered" is a soft success — driver has a vehicle, proceed to dashboard
      final isAlreadyRegistered =
          status.message.toLowerCase().contains('already registered');

      if (status.isSuccess || isAlreadyRegistered) {
        errorMessage = isAlreadyRegistered
            ? 'Vehicle already registered. Continuing to dashboard.'
            : '';
        state = VehicleFormState.success;
        notifyListeners();
        return true;
      } else {
        errorMessage = status.message;
        state = VehicleFormState.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('VehicleProvider registerVehicle error: $e');
      errorMessage = 'Network error. Please check your connection.';
      state = VehicleFormState.error;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    state = VehicleFormState.idle;
    errorMessage = '';
    selectedType = null;
    selectedContract = null;
    contracts = [];
    notifyListeners();
  }
}
