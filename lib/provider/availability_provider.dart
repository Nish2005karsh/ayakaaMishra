import 'package:flutter/foundation.dart';
import '../const/app_session.dart';
import '../data/repository/trip_repository.dart';
import '../service/fleet_engine_service.dart';
import '../service/driver_sdk_service.dart';

class AvailabilityProvider extends ChangeNotifier {
  final TripRepository _repo;

  AvailabilityProvider(this._repo) {
    _isOnline = AppSession.isOnline;
  }

  bool _isOnline = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isOnline => _isOnline;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> toggle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newState = !_isOnline;
      final status = await _repo.updateVehicleState(isOnline: newState);
      if (status.isSuccess) {
        _isOnline = newState;
        await AppSession.saveOnlineState(newState);
        debugPrint('=== Driver is now ${_isOnline ? 'ONLINE' : 'OFFLINE'} ===');
        if (newState) {
          FleetEngineService().goOnline();
          DriverSdkService().setVehicleState(true);
          DriverSdkService().setLocationTrackingEnabled(true);
        } else {
          FleetEngineService().goOffline();
          DriverSdkService().setLocationTrackingEnabled(false);
          DriverSdkService().setVehicleState(false);
        }
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

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
