import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class DriverSdkService {
  static const MethodChannel _channel = MethodChannel('com.ayakaa.driver_sdk');

  static final DriverSdkService _instance = DriverSdkService._internal();
  factory DriverSdkService() => _instance;
  DriverSdkService._internal() {
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<String> Function(String vehicleId)? onTokenRequested;

  Future<dynamic> _handleMethod(MethodCall call) async {
    if (call.method == 'getToken') {
      final vehicleId = call.arguments as String;
      return onTokenRequested != null ? await onTokenRequested!(vehicleId) : '';
    }
    return null;
  }

  Future<bool> initialize({
    required String providerId,
    required String vehicleId,
  }) async {
    try {
      final bool success = await _channel.invokeMethod('initialize', {
        'providerId': providerId,
        'vehicleId': vehicleId,
      });
      return success;
    } catch (e) {
      // MissingPluginException when native SDK not installed — safe to ignore
      debugPrint('DriverSdkService.initialize skipped: $e');
      return false;
    }
  }

  Future<bool> setVehicleState(bool isOnline) async {
    try {
      final bool success = await _channel.invokeMethod('setVehicleState', {
        'isOnline': isOnline,
      });
      return success;
    } catch (e) {
      debugPrint('DriverSdkService.setVehicleState skipped: $e');
      return false;
    }
  }

  Future<bool> setLocationTrackingEnabled(bool enabled) async {
    try {
      final bool success = await _channel.invokeMethod(
          'setLocationTrackingEnabled', {'enabled': enabled});
      return success;
    } catch (e) {
      debugPrint('DriverSdkService.setLocationTrackingEnabled skipped: $e');
      return false;
    }
  }

  /// Cleanup the Driver SDK. Call before logout to prevent crashes on next login.
  Future<bool> cleanup() async {
    try {
      final bool success = await _channel.invokeMethod('cleanup');
      return success;
    } catch (e) {
      debugPrint('DriverSdkService.cleanup skipped: $e');
      return false;
    }
  }
}
