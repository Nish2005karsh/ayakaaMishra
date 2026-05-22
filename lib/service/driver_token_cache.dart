import 'package:flutter/foundation.dart';
import '../const/api_routes.dart';
import '../data/remote/dio_client.dart';

/// In-memory cache for the Driver SDK JWT.
///
/// The native SDK's AuthTokenFactory requests a token frequently. Without
/// caching we hammer Hostinger and trigger bot-protection 403s. JWT default
/// expiry from the backend is 1 hour; we refresh 5 min early.
///
/// Cleared on logout via [clear] — without that, a stale token would survive
/// a logout/login cycle.
class DriverTokenCache {
  DriverTokenCache._();

  static String? _token;
  static DateTime? _expiry;
  static String? _vehicleId;

  /// Returns a fresh (cached or just-fetched) driver JWT for [vehicleId].
  ///
  /// Throws [StateError] when the backend returns no usable token AND there
  /// is no valid cached token to fall back on. The native AuthTokenFactory
  /// catches this and surfaces a real error to the Driver SDK instead of
  /// silently sending an empty Bearer header.
  static Future<String> fetch(String vehicleId) async {
    final now = DateTime.now();
    if (_token != null &&
        _expiry != null &&
        _vehicleId == vehicleId &&
        now.isBefore(_expiry!)) {
      return _token!;
    }
    try {
      final resp = await DioClient.instance
          .get('${ApiRoutes.getDriverToken}/$vehicleId');
      final data = resp.data;
      final token =
          data is Map ? data['token']?.toString() : data.toString().trim();
      if (token == null || token.isEmpty) {
        if (_token != null && _vehicleId == vehicleId) {
          debugPrint('Driver SDK: token fetch empty, reusing cached token');
          return _token!;
        }
        throw StateError('getDriverToken returned empty body for $vehicleId');
      }
      _token = token;
      _vehicleId = vehicleId;
      _expiry = now.add(const Duration(minutes: 55));
      debugPrint('Driver SDK: token fetched for $vehicleId (cached 55 min)');
      return token;
    } catch (e) {
      if (_token != null && _vehicleId == vehicleId && _expiry != null) {
        debugPrint('Driver SDK: token fetch failed ($e), reusing cached token');
        return _token!;
      }
      debugPrint('Driver SDK: token fetch failed and no cache — $e');
      rethrow;
    }
  }

  /// Drops the cached token. Call on logout so the next driver can't end
  /// up using the previous driver's JWT.
  static void clear() {
    _token = null;
    _expiry = null;
    _vehicleId = null;
    debugPrint('Driver SDK: token cache cleared');
  }
}
