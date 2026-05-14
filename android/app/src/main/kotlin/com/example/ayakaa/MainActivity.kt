package com.example.ayakaa

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val DRIVER_SDK_CHANNEL = "com.ayakaa.driver_sdk"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DRIVER_SDK_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "initialize" -> {
                        // Navigation SDK initialization handled by google_navigation_flutter plugin
                        // Driver SDK (transportation-driver) requires Google Mobility Services approval
                        result.success(true)
                    }
                    "setVehicleState" -> {
                        val isOnline = call.argument<Boolean>("isOnline") ?: false
                        // reporter.setVehicleState(if (isOnline) VehicleState.ONLINE else VehicleState.OFFLINE)
                        // Requires transportation-driver SDK — pending Google Mobility Services approval
                        result.success(false)
                    }
                    "setLocationTrackingEnabled" -> {
                        val enabled = call.argument<Boolean>("enabled") ?: false
                        // if (enabled) reporter.enableLocationTracking() else reporter.disableLocationTracking()
                        // Requires transportation-driver SDK — pending Google Mobility Services approval
                        result.success(false)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
