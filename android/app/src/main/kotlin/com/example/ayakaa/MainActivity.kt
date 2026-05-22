package com.example.ayakaa

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

// Google Driver SDK v6.0.0 imports
import com.google.android.libraries.mapsplatform.transportation.driver.api.base.data.AuthTokenContext
import com.google.android.libraries.mapsplatform.transportation.driver.api.base.data.DriverContext
import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.RidesharingDriverApi
import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.vehiclereporter.RidesharingVehicleReporter
import com.google.android.libraries.navigation.NavigationApi
import com.google.android.libraries.navigation.Navigator
import com.google.android.libraries.navigation.RoadSnappedLocationProvider

class MainActivity : FlutterActivity() {

    private val DRIVER_SDK_CHANNEL = "com.ayakaa.driver_sdk"
    private var ridesharingDriverApi: RidesharingDriverApi? = null
    private var vehicleReporter: RidesharingVehicleReporter? = null
    private var navigator: Navigator? = null
    private var termsAlreadyShown = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DRIVER_SDK_CHANNEL)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "initialize" -> {
                    val providerId = call.argument<String>("providerId") ?: ""
                    val vehicleId = call.argument<String>("vehicleId") ?: ""
                    Log.d("DRIVER_SDK", "initialize called: providerId=$providerId, vehicleId=$vehicleId")
                    initializeDriverSdk(providerId, vehicleId, channel, result)
                }
                "setVehicleState" -> {
                    val isOnline = call.argument<Boolean>("isOnline") ?: false
                    Log.d("DRIVER_SDK", "setVehicleState called: isOnline=$isOnline")
                    if (vehicleReporter != null) {
                        vehicleReporter?.setVehicleState(
                            if (isOnline) RidesharingVehicleReporter.VehicleState.ONLINE
                            else RidesharingVehicleReporter.VehicleState.OFFLINE
                        )
                        result.success(true)
                    } else {
                        Log.e("DRIVER_SDK", "VehicleReporter not initialized")
                        result.success(false)
                    }
                }
                "setLocationTrackingEnabled" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    Log.d("DRIVER_SDK", "setLocationTrackingEnabled called: enabled=$enabled")
                    if (vehicleReporter != null) {
                        if (enabled) {
                            // Force 5-second reporting interval so location keeps
                            // flowing to Fleet Engine even when driver is ONLINE
                            // but not in active navigation (matches client's app).
                            try {
                                vehicleReporter?.setLocationReportingInterval(
                                    5L,
                                    TimeUnit.SECONDS
                                )
                                Log.d("DRIVER_SDK", "Location reporting interval set to 5s")
                            } catch (e: Exception) {
                                Log.w("DRIVER_SDK", "setLocationReportingInterval failed: ${e.message}")
                            }
                            vehicleReporter?.enableLocationTracking()
                        } else {
                            vehicleReporter?.disableLocationTracking()
                        }
                        result.success(true)
                    } else {
                        Log.e("DRIVER_SDK", "VehicleReporter not initialized")
                        result.success(false)
                    }
                }
                "cleanup" -> {
                    Log.d("DRIVER_SDK", "cleanup called")
                    try {
                        vehicleReporter?.disableLocationTracking()
                        vehicleReporter?.setVehicleState(RidesharingVehicleReporter.VehicleState.OFFLINE)
                    } catch (e: Exception) {
                        Log.w("DRIVER_SDK", "cleanup soft error: ${e.message}")
                    }
                    try {
                        RidesharingDriverApi.clearInstance()
                    } catch (e: Exception) {
                        Log.w("DRIVER_SDK", "clearInstance soft error: ${e.message}")
                    }
                    vehicleReporter = null
                    ridesharingDriverApi = null
                    navigator = null
                    Log.d("DRIVER_SDK", "cleanup done")
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun initializeDriverSdk(
        providerId: String,
        vehicleId: String,
        channel: MethodChannel,
        result: MethodChannel.Result
    ) {
        // 1. Initialize Navigation SDK and get Navigator
        NavigationApi.getNavigator(this, object : NavigationApi.NavigatorListener {
            override fun onNavigatorReady(nav: Navigator) {
                navigator = nav

                // 2. Build synchronous AuthTokenFactory that fetches from Flutter via MethodChannel
                val authTokenFactory = AuthTokenContext.AuthTokenFactory { ctx ->
                    val latch = CountDownLatch(1)
                    var fetchedToken: String = ""
                    var fetchError: String? = null

                    runOnUiThread {
                        channel.invokeMethod("getToken", ctx.vehicleId, object : MethodChannel.Result {
                            override fun success(token: Any?) {
                                fetchedToken = (token as? String) ?: ""
                                latch.countDown()
                            }
                            override fun error(code: String, msg: String?, details: Any?) {
                                Log.e("DRIVER_SDK", "Token fetch failed: $msg")
                                fetchError = msg ?: code
                                latch.countDown()
                            }
                            override fun notImplemented() {
                                Log.e("DRIVER_SDK", "getToken not implemented in Flutter")
                                fetchError = "getToken not implemented"
                                latch.countDown()
                            }
                        })
                    }

                    val completed = latch.await(30, TimeUnit.SECONDS)
                    if (!completed) {
                        // Don't return "" — that surfaces as a generic 401 from Fleet
                        // Engine and the SDK won't retry the token fetch.
                        throw RuntimeException("Driver token fetch timed out after 30s")
                    }
                    if (fetchError != null) {
                        throw RuntimeException("Driver token fetch failed: $fetchError")
                    }
                    if (fetchedToken.isEmpty()) {
                        throw RuntimeException("Driver token fetch returned empty string")
                    }
                    fetchedToken
                }

                // 3. Build DriverContext (RoadSnappedLocationProvider is required)
                val roadSnappedLocationProvider: RoadSnappedLocationProvider? =
                    NavigationApi.getRoadSnappedLocationProvider(application)
                if (roadSnappedLocationProvider == null) {
                    Log.e("DRIVER_SDK", "RoadSnappedLocationProvider is null")
                    result.error("NO_RSLP", "RoadSnappedLocationProvider is null", null)
                    return
                }

                val driverContext = DriverContext.builder(application)
                    .setProviderId(providerId)
                    .setVehicleId(vehicleId)
                    .setAuthTokenFactory(authTokenFactory)
                    .setNavigator(navigator!!)
                    .setRoadSnappedLocationProvider(roadSnappedLocationProvider)
                    .build()

                // 4. Create RidesharingDriverApi and get the vehicle reporter.
                // If a stale singleton exists from a previous app session that was
                // force-killed (without proper cleanup), createInstance throws
                // IllegalStateException("RidesharingDriverApi already initialized").
                // Reuse the existing instance in that case, or clear and recreate.
                try {
                    // Try to reuse existing instance first (avoids crash on cold start
                    // after a force-close).
                    val existing: RidesharingDriverApi? = try {
                        RidesharingDriverApi.getInstance()
                    } catch (_: Exception) {
                        null
                    }

                    ridesharingDriverApi = if (existing != null) {
                        Log.d("DRIVER_SDK", "Reusing existing RidesharingDriverApi instance")
                        existing
                    } else {
                        Log.d("DRIVER_SDK", "Creating new RidesharingDriverApi instance")
                        RidesharingDriverApi.createInstance(driverContext)
                    }

                    vehicleReporter = ridesharingDriverApi?.ridesharingVehicleReporter

                    Log.d("DRIVER_SDK", "Driver SDK initialized successfully")
                    result.success(true)
                } catch (e: IllegalStateException) {
                    // Already-initialized fallback: clear and retry once.
                    Log.w("DRIVER_SDK", "createInstance threw IllegalStateException, clearing and retrying: ${e.message}")
                    try {
                        RidesharingDriverApi.clearInstance()
                        ridesharingDriverApi = RidesharingDriverApi.createInstance(driverContext)
                        vehicleReporter = ridesharingDriverApi?.ridesharingVehicleReporter
                        Log.d("DRIVER_SDK", "Driver SDK re-initialized after clear")
                        result.success(true)
                    } catch (e2: Exception) {
                        Log.e("DRIVER_SDK", "Retry failed: ${e2.message}")
                        result.error("INIT_ERROR", e2.message, null)
                    }
                } catch (e: Exception) {
                    Log.e("DRIVER_SDK", "Error creating RidesharingDriverApi: ${e.message}")
                    result.error("INIT_ERROR", e.message, null)
                }
            }

            override fun onError(@NavigationApi.ErrorCode errorCode: Int) {
                Log.e("DRIVER_SDK", "Navigation SDK error: $errorCode")
                // Error code 4 = TERMS_NOT_ACCEPTED. Show Google's terms dialog
                // once; on accept, retry initialization. (Confirmed by client's
                // reference app — same handling.)
                val isTerms = errorCode == NavigationApi.ErrorCode.TERMS_NOT_ACCEPTED ||
                    errorCode == 4
                if (isTerms && !termsAlreadyShown) {
                    termsAlreadyShown = true
                    Log.d("DRIVER_SDK", "Showing Navigation SDK terms & conditions dialog")
                    val listenerRef = this
                    runOnUiThread {
                        NavigationApi.showTermsAndConditionsDialog(
                            this@MainActivity,
                            "Ayaka Transassist",
                            "Accept navigation terms to continue"
                        ) { accepted ->
                            if (accepted) {
                                Log.d("DRIVER_SDK", "Terms accepted, retrying init")
                                NavigationApi.getNavigator(this@MainActivity, listenerRef)
                            } else {
                                Log.w("DRIVER_SDK", "Terms rejected by user")
                                result.error("TERMS_REJECTED", "User rejected navigation terms", null)
                            }
                        }
                    }
                } else {
                    result.error("NAV_SDK_ERROR", "Error code: $errorCode", null)
                }
            }
        })
    }
}
