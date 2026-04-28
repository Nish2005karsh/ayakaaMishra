import 'package:flutter/foundation.dart';
import '../const/app_session.dart';
import '../data/repository/trip_repository.dart';

class AvailabilityProvider extends ChangeNotifier {
  final TripRepository _repo;

  AvailabilityProvider(this._repo);

  bool _isOnline = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isOnline => _isOnline;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> toggle() async {
    // Backend requires a valid vehicle_id.
    // If we don't have one stored, the driver must register a vehicle first.
    // (BACKEND ISSUE: vehicle_insert "already registered" response does not return v_id.
    //  Ask backend to include v_id in that response, or add GET /driver_vehicle endpoint.)
    if (AppSession.vehicleId == 0) {
      _errorMessage =
          'Vehicle not linked. Please open Vehicle Registration once to link your vehicle.';
      debugPrint('=== update_vehicleState blocked: vehicle_id not stored ===');
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newState = !_isOnline;
      final status = await _repo.updateVehicleState(isOnline: newState);
      if (status.isSuccess) {
        _isOnline = newState;
        debugPrint('=== Driver is now ${_isOnline ? 'ONLINE' : 'OFFLINE'} ===');
      } else {
        _errorMessage = status.message;
        debugPrint('update_vehicleState failed: ${status.message}');
      }
    } catch (e) {
      _errorMessage = 'Failed to update status. Check your connection.';
      debugPrint('AvailabilityProvider toggle error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
