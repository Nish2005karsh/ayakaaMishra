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
          // If the SDK failed to initialize at app start (e.g. location
          // permission wasn't granted yet) the calls below would silently
          // no-op because VehicleReporter is null. Retry init once here
          // — by now the user has interacted with the app and permissions
          // should be granted.
          final ok1 = await DriverSdkService().setLocationTrackingEnabled(true);
          if (!ok1) {
            final fleetVehicleId = AppSession.fleetVehicleId;
            if (fleetVehicleId.isNotEmpty) {
              debugPrint('Driver SDK not ready, re-initializing before online toggle');
              await DriverSdkService().initialize(
                providerId: 'ayaka-transassist-mobility',
                vehicleId: fleetVehicleId,
              );
              await DriverSdkService().setLocationTrackingEnabled(true);
            }
          }
          // CRITICAL: enableLocationTracking MUST be called BEFORE setVehicleState(ONLINE)
          // per Google docs, otherwise IllegalStateException → location appears static.
          await DriverSdkService().setVehicleState(true);
          FleetEngineService().goOnline();
        } else {
          await DriverSdkService().setVehicleState(false);
          await DriverSdkService().setLocationTrackingEnabled(false);
          FleetEngineService().goOffline();
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
