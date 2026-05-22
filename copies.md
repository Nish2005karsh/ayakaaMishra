1.//package com.example.ayaka;
//
//import android.app.Application;
//import android.util.Log;
//import android.widget.Toast;
//
//import androidx.annotation.NonNull;
//
//import com.google.android.libraries.navigation.NavigationApi;
//import com.google.android.libraries.navigation.Navigator;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.base.data.DriverContext;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.base.data.AuthTokenContext;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.RidesharingDriverApi;
//
//public class App extends Application {
//
//    private static RidesharingDriverApi driverApi;
//    private static boolean isDriverSdkReady = false;
//
//    public static RidesharingDriverApi getDriverApi() {
//        return driverApi;
//    }
//
//    public static boolean isDriverSdkReady() {
//        return isDriverSdkReady;
//    }
//
//    @Override
//    public void onCreate() {
//        super.onCreate();
//        Log.d("DriverSDK", "App onCreate called");
//        initializeDriverSdk();
////        throw new RuntimeException("APP CLASS IS RUNNING");
//    }
//
//    private void initializeDriverSdk() {
//
//        NavigationApi.getNavigator(this, new NavigationApi.NavigatorListener() {
//
//            @Override
//            public void onNavigatorReady(@NonNull Navigator navigator) {
//                Log.d("DriverSDK", "Navigator READY");
//
//                DriverContext driverContext =
//                        DriverContext.builder(App.this)
//                                .setProviderId("providers/ayaka-transassist-mobility")
//                                .setVehicleId("vehicle1-corporate_wheels")
//                                .setNavigator(navigator)
//                                .setRoadSnappedLocationProvider(
//                                        NavigationApi.getRoadSnappedLocationProvider(App.this)
//                                )
//                                .setAuthTokenFactory(new MainActivity.StaticAuthTokenFactory())
//                                .build();
//
//                driverApi = RidesharingDriverApi.createInstance(driverContext);
//                isDriverSdkReady = true;
//
//                Log.d("DriverSDK", "✅ Driver SDK Initialized Successfully");
//            }
//
//            @Override
//            public void onError(@NavigationApi.ErrorCode int errorCode) {
//                Log.e("DriverSDK", "❌ Navigation Init Error: " + errorCode);
//                Toast.makeText(App.this, "Navigation Error Code: " + errorCode, Toast.LENGTH_LONG).show();
//
//            }
//        });
//    }
//}
//

//before change error for ridesharing api
//package com.example.ayaka;
//
//import android.app.Application;
//import android.util.Log;
//import android.widget.Toast;
//
//import androidx.annotation.NonNull;
//
//import com.google.android.libraries.navigation.NavigationApi;
//import com.google.android.libraries.navigation.Navigator;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.base.data.DriverContext;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.base.data.AuthTokenContext;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.RidesharingDriverApi;
//import com.google.android.gms.tasks.OnFailureListener;
//import com.google.android.gms.tasks.OnSuccessListener;
//import com.google.android.gms.tasks.Task;
//
//public class App extends Application {
//
//    private static DriverContext driverApi;
//    private static boolean isDriverSdkReady = false;
//
//    public static DriverContext getDriverApi() {
//        return driverApi;
//    }
//
//    public static boolean isDriverSdkReady() {
//        return isDriverSdkReady;
//    }
//
//    @Override
//    public void onCreate() {
//        super.onCreate();
//        Log.d("DriverSDK", "App onCreate called");
//        initializeDriverSdk();
////        throw new RuntimeException("APP CLASS IS RUNNING");
//    }
//
//    private void initializeDriverSdk() {
//        NavigationApi.getNavigator(this, new NavigationApi.NavigatorListener() {
//
//            @Override
//            public void onNavigatorReady(@NonNull Navigator navigator) {
//                Log.d("DriverSDK", "Navigator READY");
//
//                try {
//                    DriverContext driverContext = DriverContext.builder(App.this)
//                            .setProviderId("providers/ayaka-transassist-mobility")
//                            .setVehicleId("vehicle1-corporate_wheels")
//                            .setNavigator(navigator)
//                            .setRoadSnappedLocationProvider(
//                                    NavigationApi.getRoadSnappedLocationProvider(App.this)
//                            )
//                            .setAuthTokenFactory(new MainActivity.StaticAuthTokenFactory())
//                            .build();
//
//                    // 🔥 Direct assignment (No Task needed in this version)
//                    driverApi = RidesharingDriverApi.createInstance(driverContext);
//                    isDriverSdkReady = true;
//
//                    Log.d("DriverSDK", "✅ Driver SDK Initialized Successfully");
//
//                } catch (Exception e) {
//                    isDriverSdkReady = false;
//                    Log.e("DriverSDK", "❌ Driver SDK Initialization Failed: " + e.getMessage());
//                    e.printStackTrace();
//                }
//            }
//            @Override
//            public void onError(@NavigationApi.ErrorCode int errorCode) {
//                Log.e("DriverSDK", "❌ Navigation Init Error: " + errorCode);
//                // If errorCode is 2, you must accept the Navigation Terms & Conditions first!
//                Toast.makeText(App.this, "Navigation Error Code: " + errorCode, Toast.LENGTH_LONG).show();
//            }
//        });
//    }
//}

//working without any errors(latest)
//package com.example.ayaka;
//
//import android.app.Application;
//import android.util.Log;
//
//import androidx.annotation.NonNull;
//
//import com.google.android.libraries.navigation.NavigationApi;
//import com.google.android.libraries.navigation.Navigator;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.base.data.DriverContext;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.RidesharingDriverApi;
//
//public class App extends Application {
//
//    private static RidesharingDriverApi driverApi;
//    private static boolean isDriverSdkReady = false;
//
//    public static RidesharingDriverApi getDriverApi() {
//        return driverApi;
//    }
//
//    public static boolean isDriverSdkReady() {
//        return isDriverSdkReady;
//    }
//
//    @Override
//    public void onCreate() {
//        super.onCreate();
//        Log.d("DriverSDK", "App onCreate called");
//        initializeDriverSdk();
//    }
//
//    private void initializeDriverSdk() {
//
//        NavigationApi.getNavigator(this,
//                new NavigationApi.NavigatorListener() {
//
//                    @Override
//                    public void onNavigatorReady(@NonNull Navigator navigator) {
//
//                        Log.d("DriverSDK","Navigator READY");
//
//                        DriverContext driverContext =
//                                DriverContext.builder(App.this)
//                                        .setProviderId("providers/ayaka-transassist-mobility")
//                                        .setVehicleId("vehicle1-corporate_wheels")
//                                        .setNavigator(navigator)
//                                        .setRoadSnappedLocationProvider(
//                                                NavigationApi.getRoadSnappedLocationProvider(App.this)
//                                        )
//                                        .setAuthTokenFactory(
//                                                new MainActivity.StaticAuthTokenFactory()
//                                        )
//                                        .build();
//
//                        driverApi =
//                                RidesharingDriverApi.createInstance(driverContext);
//
//                        isDriverSdkReady = true;
//
//                        Log.d("DriverSDK",
//                                "✅ Driver SDK Initialized Successfully");
//                    }
//
//                    @Override
//                    public void onError(
//                            @NavigationApi.ErrorCode int errorCode) {
//
//                        isDriverSdkReady = false;
//
//                        Log.e("DriverSDK",
//                                "❌ Navigation Init Error: " + errorCode);
//                    }
//                });
//    }
//}


//jemini code

//logout problem
//package com.example.ayaka;
//
//import android.app.Application;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.RidesharingDriverApi;
//
//public class App extends Application {
//    private static RidesharingDriverApi driverApi;
//
//    public static void setDriverApi(RidesharingDriverApi api) {
//        driverApi = api;
//    }
//
//    public static RidesharingDriverApi getDriverApi() {
//        return driverApi;
//    }
//
//    public static boolean isDriverSdkReady() {
//        return driverApi != null;
//    }
//}

package com.example.ayaka;

import android.app.Application;
import android.util.Log;

import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.RidesharingDriverApi;

public class App extends Application {

    private static RidesharingDriverApi driverApi;

    public static RidesharingDriverApi getDriverApi() {
        return driverApi;
    }

    public static void setDriverApi(RidesharingDriverApi api) {
        driverApi = api;
    }

    /**
     * ✅ Call this on logout BEFORE creating a new session.
     * RidesharingDriverApi is a singleton — calling createInstance() when one
     * already exists throws IllegalStateException. clearDriverApi() shuts down
     * the old instance so a fresh one can be created on next login.
     */
    public static void clearDriverApi() {
        if (driverApi != null) {
            try {
                RidesharingDriverApi.clearInstance();
                Log.d("App", "✅ DriverApi shut down successfully");
            } catch (Exception e) {
                Log.w("App", "DriverApi shutdown warning: " + e.getMessage());
            }
            driverApi = null;
        } else {
            Log.d("App", "clearDriverApi: nothing to clear");
        }
    }
}
2.
//package com.example.ayaka;
//
//import android.Manifest;
//import android.content.Context;
//import android.content.Intent;
//import android.content.pm.PackageManager;
//import android.location.LocationManager;
//import android.os.Bundle;
//import android.os.Handler;
//import android.os.Looper;
//import android.provider.Settings;
//import android.util.Log;
//import android.view.View;
//import android.widget.Button;
//import android.widget.TextView;
//import android.widget.Toast;
//
//import androidx.annotation.NonNull;
//import androidx.appcompat.app.AppCompatActivity;
//import androidx.core.app.ActivityCompat;
//
//import com.google.android.gms.maps.CameraUpdateFactory;
//import com.google.android.gms.maps.GoogleMap;
//import com.google.android.gms.maps.OnMapReadyCallback;
//import com.google.android.gms.maps.model.BitmapDescriptorFactory;
//import com.google.android.gms.maps.model.LatLng;
//import com.google.android.gms.maps.model.LatLngBounds;
//import com.google.android.gms.maps.model.MarkerOptions;
//import com.google.android.gms.maps.model.PolylineOptions;
//
//import com.google.android.libraries.navigation.NavigationApi;
//import com.google.android.libraries.navigation.NavigationView;
//import com.google.android.libraries.navigation.Navigator;
//import com.google.android.libraries.navigation.RoadSnappedLocationProvider;
//import com.google.android.libraries.navigation.Waypoint;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.base.data.DriverContext;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.RidesharingDriverApi;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.vehiclereporter.RidesharingVehicleReporter;
//
//import com.google.android.material.bottomsheet.BottomSheetBehavior;
//
//import org.json.JSONArray;
//import org.json.JSONObject;
//
//import java.io.BufferedReader;
//import java.io.InputStreamReader;
//import java.net.HttpURLConnection;
//import java.net.URL;
//import java.util.ArrayList;
//
//public class MapActivity extends AppCompatActivity implements OnMapReadyCallback {
//
//    private static final String TAG                   = "MapActivity";
//    private static final int    LOCATION_PERMISSION   = 100;
//    private static final String PROVIDER_ID           = "ayaka-transassist-mobility";
//    private static final String GOOGLE_API_KEY        = "AIzaSyBNPLbzyyZzA3T1d5hSWkPE3tBW89MhKVw";
//
//    // ── Views ──────────────────────────────────────────────
//    private NavigationView            navigationView;
//    private GoogleMap                 mMap;
//    private BottomSheetBehavior<View> bottomSheetBehavior;
//
//    // ── Trip data ──────────────────────────────────────────
//    private String             startLocation, endLocation;
//    private ArrayList<String>  middleStops;
//    private ArrayList<String>  stopLabels;
//    private String             tripType;          // "Login" or "Logout"
//    private int                userId;
//    private ArrayList<Integer> empTripIds;  // per-employee trip_id from pickupDrop
//    private ArrayList<Integer> empIds;
//    private ArrayList<String>  empNames;
//    private ArrayList<String>  empMobiles; // ✅ mobile_number per employee
//    private String             startAddressText, endAddressText, date, time;
//    private double             distance;
//    private int                persons;
//
//    // ── SDK state ──────────────────────────────────────────
//    private Navigator                  navigator;
//    private RidesharingVehicleReporter vehicleReporter;
//    private boolean isDriverSdkReady      = false;
//    private boolean isNavigatorReady      = false;
//    private boolean shouldStartNavigation = false;
//    private boolean termsAlreadyShown     = false;
//
//    // ── Navigation state ───────────────────────────────────
//    // allStops: full ordered list [startLocation, middleStops..., endLocation]
//    private ArrayList<String> allStops;
//    private int currentStopIndex = 0;
//
//    // ✅ Maps marker title → stop index so tapping a marker shows the right OTP
//    private java.util.HashMap<String, Integer> markerStopIndexMap = new java.util.HashMap<>();
//
//    // ======================================================
//    // LIFECYCLE
//    // ======================================================
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_map);
//
//        startLocation    = getIntent().getStringExtra("start_location");
//        endLocation      = getIntent().getStringExtra("end_location");
//        middleStops      = getIntent().getStringArrayListExtra("middle_stops");
//        startAddressText = getIntent().getStringExtra("start_address");
//        endAddressText   = getIntent().getStringExtra("end_address");
//        date             = getIntent().getStringExtra("date");
//        time             = getIntent().getStringExtra("time");
//        distance         = getIntent().getDoubleExtra("distance", 0);
//        persons          = getIntent().getIntExtra("persons", 0);
//        tripType         = getIntent().getStringExtra("trip_type");
//        stopLabels       = getIntent().getStringArrayListExtra("stop_labels");
//        userId           = getIntent().getIntExtra("user_id", 0);
//        empTripIds       = getIntent().getIntegerArrayListExtra("emp_trip_ids");
//        empIds           = getIntent().getIntegerArrayListExtra("emp_ids");
//        empNames         = getIntent().getStringArrayListExtra("emp_names");
//        empMobiles       = getIntent().getStringArrayListExtra("emp_mobiles");
//
//        if (stopLabels == null) stopLabels  = new ArrayList<>();
//        if (empTripIds == null) empTripIds  = new ArrayList<>();
//        if (empIds     == null) empIds      = new ArrayList<>();
//        if (empNames   == null) empNames    = new ArrayList<>();
//        if (empMobiles == null) empMobiles  = new ArrayList<>();
//
//        navigationView = findViewById(R.id.navigation_view);
//        navigationView.onCreate(savedInstanceState);
//
//        setupBottomSheet();
//
//        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
//                != PackageManager.PERMISSION_GRANTED) {
//            ActivityCompat.requestPermissions(this,
//                    new String[]{Manifest.permission.ACCESS_FINE_LOCATION,
//                            Manifest.permission.ACCESS_COARSE_LOCATION},
//                    LOCATION_PERMISSION);
//        } else {
//            initSdk();
//        }
//    }
//
//    @Override protected void onStart()   { super.onStart();   navigationView.onStart(); }
//    @Override protected void onResume()  { super.onResume();  navigationView.onResume(); }
//    @Override protected void onPause()   { super.onPause();   navigationView.onPause(); }
//    @Override protected void onStop()    { super.onStop();    navigationView.onStop(); }
//    @Override protected void onDestroy() { super.onDestroy(); navigationView.onDestroy(); }
//
//    @Override
//    public void onSaveInstanceState(@NonNull Bundle out) {
//        super.onSaveInstanceState(out);
//        navigationView.onSaveInstanceState(out);
//    }
//
//    @Override
//    public void onRequestPermissionsResult(int code, @NonNull String[] perms, @NonNull int[] results) {
//        super.onRequestPermissionsResult(code, perms, results);
//        if (code == LOCATION_PERMISSION) {
//            if (results.length > 0 && results[0] == PackageManager.PERMISSION_GRANTED) {
//                initSdk();
//            } else {
//                Toast.makeText(this, "Location permission required", Toast.LENGTH_LONG).show();
//                navigationView.getMapAsync(this);
//            }
//        }
//    }
//
//    // ======================================================
//    // SDK INIT
//    // ======================================================
//
//    private void initSdk() {
//        if (!isLocationEnabled()) {
//            Toast.makeText(this, "Please enable GPS", Toast.LENGTH_LONG).show();
//            startActivity(new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS));
//        }
//
//        NavigationApi.getNavigator(this, new NavigationApi.NavigatorListener() {
//
//            @Override
//            public void onNavigatorReady(@NonNull Navigator nav) {
//                Log.d(TAG, "✅ onNavigatorReady");
//                navigator        = nav;
//                isNavigatorReady = true;
//                termsAlreadyShown = false;
//
//                navigationView.getMapAsync(MapActivity.this);
//                new Handler(Looper.getMainLooper()).postDelayed(() -> setupDriverApi(nav), 800);
//
//                if (shouldStartNavigation) {
//                    // allStops was already built in onStartTripClicked before
//                    // shouldStartNavigation was set — safe to call directly
//                    if (allStops == null || allStops.isEmpty()) {
//                        allStops = buildAllStops();  // safety fallback
//                    }
//                    startNavigation();
//                }
//            }
//
//            @Override
//            public void onError(@NavigationApi.ErrorCode int errorCode) {
//                boolean isTerms = (errorCode == NavigationApi.ErrorCode.TERMS_NOT_ACCEPTED)
//                        || (errorCode == 4);
//                if (isTerms && !termsAlreadyShown) {
//                    termsAlreadyShown = true;
//                    NavigationApi.showTermsAndConditionsDialog(MapActivity.this,
//                            "Ayaka Transassist", "Accept navigation terms",
//                            accepted -> {
//                                if (accepted) NavigationApi.getNavigator(MapActivity.this, this);
//                                else navigationView.getMapAsync(MapActivity.this);
//                            });
//                } else {
//                    navigationView.getMapAsync(MapActivity.this);
//                }
//            }
//        });
//    }
//
//    @Override
//    public void onMapReady(@NonNull GoogleMap googleMap) {
//        Log.d(TAG, "✅ onMapReady");
//        mMap = googleMap;
//        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
//                == PackageManager.PERMISSION_GRANTED) {
//            mMap.setMyLocationEnabled(true);
//            mMap.getUiSettings().setMyLocationButtonEnabled(true);
//        }
//        drawRoutePreview();
//    }
//
//    // ======================================================
//    // DRIVER SDK
//    // ======================================================
//
//    private void setupDriverApi(Navigator nav) {
//        if (App.getDriverApi() != null) {
//            Log.d(TAG, "✅ Reusing existing DriverApi");
//            isDriverSdkReady = true;
//            return;
//        }
//        try {
//            RoadSnappedLocationProvider provider =
//                    NavigationApi.getRoadSnappedLocationProvider(getApplication());
//            if (provider == null) return;
//
//            SessionManager session = new SessionManager(getApplicationContext());
//            String token     = session.getAccessToken();
//            String vehicleId = session.getVehicleId();
//            if (vehicleId == null || vehicleId.isEmpty() || token == null || token.isEmpty()) return;
//
//            DriverContext ctx = DriverContext.builder(getApplication())
//                    .setProviderId(PROVIDER_ID)
//                    .setVehicleId(vehicleId)
//                    .setNavigator(nav)
//                    .setRoadSnappedLocationProvider(provider)
//                    .setAuthTokenFactory(new StaticAuthTokenFactory(token))
//                    .build();
//
//            App.setDriverApi(RidesharingDriverApi.createInstance(ctx));
//            isDriverSdkReady = true;
//            Log.d(TAG, "✅ Driver SDK initialized");
//        } catch (Exception e) {
//            Log.e(TAG, "Driver SDK error: " + e.getMessage(), e);
//        }
//    }
//
//    // ======================================================
//    // BOTTOM SHEET
//    // ======================================================
//
//    private void setupBottomSheet() {
//        View bottomSheet = findViewById(R.id.bottomSheet);
//        bottomSheetBehavior = BottomSheetBehavior.from(bottomSheet);
//        bottomSheetBehavior.setState(BottomSheetBehavior.STATE_EXPANDED);
//
//        ((TextView) findViewById(R.id.startAddress)).setText("Start: " + startAddressText);
//        ((TextView) findViewById(R.id.endAddress)).setText("End: " + endAddressText);
//        ((TextView) findViewById(R.id.tripDistance)).setText(
//                String.format(java.util.Locale.getDefault(), "%.2f km", distance));
//        ((TextView) findViewById(R.id.personCount)).setText(String.valueOf(persons));
//        ((TextView) findViewById(R.id.tripDate)).setText(date);
//        ((TextView) findViewById(R.id.tripTime)).setText(time);
//
//        Button startTrip = findViewById(R.id.startTrip);
//        startTrip.setOnClickListener(v -> {
//            bottomSheetBehavior.setState(BottomSheetBehavior.STATE_HIDDEN);
//            onStartTripClicked();
//        });
//    }
//
//    // ======================================================
//    // START TRIP
//    // ======================================================
//
//    private void onStartTripClicked() {
//        if (!isLocationEnabled()) {
//            Toast.makeText(this, "Please enable GPS", Toast.LENGTH_LONG).show();
//            return;
//        }
//
//        if (!isDriverSdkReady && App.getDriverApi() != null) isDriverSdkReady = true;
//
//        if (isDriverSdkReady && App.getDriverApi() != null) {
//            try {
//                vehicleReporter = App.getDriverApi().getRidesharingVehicleReporter();
//                vehicleReporter.enableLocationTracking();
//                vehicleReporter.setVehicleState(RidesharingVehicleReporter.VehicleState.ONLINE);
//                Log.d(TAG, "✅ Fleet Engine tracking ON");
//            } catch (Exception e) {
//                Log.e(TAG, "VehicleReporter: " + e.getMessage());
//            }
//        }
//
//        startLoggingLocation();   // ✅ start FusedLocation logging
//        allStops = buildAllStops();
//        currentStopIndex = 0;
//
//        if (isNavigatorReady) {
//            navigateToStop(currentStopIndex);
//        } else {
//            shouldStartNavigation = true;
//            Toast.makeText(this, "Initializing navigation...", Toast.LENGTH_SHORT).show();
//        }
//    }
//
//    private void startNavigation() {
//        if (navigator == null || allStops == null || allStops.isEmpty()) return;
//        currentStopIndex = 0;
//        navigateToStop(currentStopIndex);
//    }
//
//    // ======================================================
//    // CORE NAVIGATION + OTP FLOW
//    //
//    // Stop sequence (allStops):
//    //   Login:  [emp0, emp1, ..., empN, office]
//    //   Logout: [office, emp0, emp1, ..., empN]
//    //
//    // OTP rules:
//    //   Login:  arrive at each employee → show OTP (ENROUTE_TO_DROPOFF)
//    //           arrive at office → trip complete (no OTP)
//    //   Logout: arrive at office → show boarding OTP for EACH employee
//    //                              (ENROUTE_TO_DROPOFF per emp_id)
//    //           arrive at each drop → show OTP (COMPLETE per emp_id)
//    // ======================================================
//
//    // Single reusable arrival listener — replaced each stop to prevent stacking
//    private Navigator.ArrivalListener currentArrivalListener = null;
//    private boolean arrivalHandled = false;   // prevent double-firing
//
//    private void navigateToStop(int index) {
//        if (navigator == null) return;
//        if (index >= allStops.size()) {
//            runOnUiThread(() -> Toast.makeText(this, "✅ Trip Complete!", Toast.LENGTH_LONG).show());
//            return;
//        }
//
//        String target = allStops.get(index);
//        LatLng dest   = parseLatLng(target);
//        if (dest == null) { Log.e(TAG, "Bad LatLng at stop " + index); return; }
//
//        String label = (stopLabels != null && index < stopLabels.size())
//                ? stopLabels.get(index) : "Stop " + (index + 1);
//
//        Log.d(TAG, "→ Navigating to stop " + index + ": " + label);
//        Toast.makeText(this, "Navigating to " + label, Toast.LENGTH_SHORT).show();
//
//        // ✅ Set destination
//        Waypoint wp = Waypoint.builder().setLatLng(dest.latitude, dest.longitude).build();
//        navigator.clearDestinations();
//        navigator.setDestination(wp);
//        navigator.startGuidance();
//
//        // ✅ Remove previous arrival listener before adding new one
//        //    This prevents listeners stacking up across multiple stops
//        if (currentArrivalListener != null) {
//            navigator.removeArrivalListener(currentArrivalListener);
//        }
//        arrivalHandled = false;
//
//        currentArrivalListener = event -> {
//            // ✅ Guard: ignore if already handled (listener can fire multiple times)
//            if (arrivalHandled) return;
//            arrivalHandled = true;
//
//            Log.d(TAG, "ArrivalListener fired for stop " + index);
//
//            // ✅ GPS proximity check (50m) before showing OTP
//            //    This confirms the driver is physically there,
//            //    not just that the Navigation SDK thinks they arrived
//            startArrivalCheck(dest, () ->
//                    runOnUiThread(() -> onArrivedAtStop(index)));
//        };
//
//        navigator.addArrivalListener(currentArrivalListener);
//    }
//
//    /**
//     * Called when driver physically arrives at a stop.
//     * Decides what OTP dialog(s) to show, then advances to next stop.
//     */
//    private void onArrivedAtStop(int index) {
//        String label = (stopLabels != null && index < stopLabels.size())
//                ? stopLabels.get(index) : "Stop " + (index + 1);
//        boolean isLastStop = (index == allStops.size() - 1);
//        boolean isLogin    = "Login".equalsIgnoreCase(tripType);
//
//        Log.d(TAG, "Arrived at stop " + index + " (" + label + ") isLast=" + isLastStop);
//
//        if (isLastStop) {
//            // ── Final stop ────────────────────────────────────────────
//            if (isLogin && "Office".equals(label)) {
//                // Login: reached office — mark trip COMPLETE in Fleet Engine
//                updateFleetEngineStatus(RidesharingVehicleReporter.VehicleState.ONLINE, "COMPLETE");
//                Toast.makeText(this, "✅ All employees at office! Trip complete.", Toast.LENGTH_LONG).show();
//            } else {
//                updateFleetEngineStatus(RidesharingVehicleReporter.VehicleState.ONLINE, "COMPLETE");
//                Toast.makeText(this, "✅ Trip Complete!", Toast.LENGTH_LONG).show();
//            }
//
//        } else if (!isLogin && "Office".equals(label)) {
//            // ── LOGOUT: arrived at office — show boarding OTP for each employee ──
//            // Driver must verify each employee's boarding OTP before leaving office
//            Toast.makeText(this, "Arrived at Office — verify employee boarding OTPs", Toast.LENGTH_SHORT).show();
//            showOfficeboardingOtpSequence(index, 0, () -> {
//                // All employees boarded — navigate to first drop
//                navigateToStop(index + 1);
//            });
//
//        } else {
//            // ── Normal stop (employee for login, or non-office) ───────
//            // OTP for employee stops is handled by marker tap
//            // Just show arrival toast and auto-advance
//            Toast.makeText(this, "Arrived at " + label, Toast.LENGTH_SHORT).show();
//            navigateToStop(index + 1);
//        }
//    }
//
//    /**
//     * For LOGOUT trips at office: show boarding OTP for each employee sequentially.
//     * empOffset tracks which employee in the allStops list we are verifying.
//     * Employees in allStops start at index officeIndex+1.
//     */
//    private void showOfficeboardingOtpSequence(int officeStopIndex, int empOffset, Runnable onAllBoarded) {
//        // Employees start after office (officeStopIndex + 1)
//        int empStopIndex = officeStopIndex + 1 + empOffset;
//
//        if (empStopIndex >= allStops.size()) {
//            Toast.makeText(this, "✅ All employees boarded!", Toast.LENGTH_SHORT).show();
//            onAllBoarded.run();  // caller handles Fleet Engine update
//            return;
//        }
//
//        String empLabel = (stopLabels != null && empStopIndex < stopLabels.size())
//                ? stopLabels.get(empStopIndex) : "Employee " + (empOffset + 1);
//
//        // Skip if this is not an employee stop
//        if ("Office".equals(empLabel)) {
//            onAllBoarded.run();
//            return;
//        }
//
//        int    empId      = getEmpIdForStop(empStopIndex);
//        String empName    = getEmpNameForStop(empStopIndex);
//        String empTripId  = getTripIdForStop(empStopIndex);
//
//        Log.d(TAG, "Office boarding OTP for " + empName + " stopIndex=" + empStopIndex
//                + " tripId=" + empTripId);
//
//        String empMobile = getEmpMobileForStop(empStopIndex);
//
//        // Show boarding OTP dialog — after verified, show next employee's dialog
//        showOtpDialogForStop(
//                empName,
//                empMobile,
//                empTripId,
//                empId,
//                OtpVerifyDialog.TYPE_PICKUP,
//                () -> showOfficeboardingOtpSequence(officeStopIndex, empOffset + 1, onAllBoarded)
//        );
//    }
//
//    /**
//     * Shows OtpVerifyDialog for one employee.
//     * empTripId = the trip_id from pickupDrop for this specific employee.
//     */
//    private void showOtpDialog(String empName, int empTripId, int empId,
//                               String type, Runnable onVerified) {
//        // Not used directly — use showOtpDialogForStop instead
//        showOtpDialogForStop(empName, "", String.valueOf(empTripId), empId, type, onVerified);
//    }
//
//    // ✅ Full method with mobile support
//    private void showOtpDialogForStop(String empName, String mobile, String tripIdStr,
//                                      int empId, String type, Runnable onVerified) {
//        Log.d(TAG, "OTP dialog: emp=" + empName + " mobile=" + mobile
//                + " tripId=" + tripIdStr + " empId=" + empId + " type=" + type);
//        OtpVerifyDialog.show(
//                getSupportFragmentManager(),
//                empName,
//                mobile,
//                userId,
//                tripIdStr,
//                empId,
//                type,
//                onVerified::run
//        );
//    }
//
//    // ── Stop data helpers ──────────────────────────────────
//
//    private int getEmpTripIdForStop(int stopIndex) {
//        if (empTripIds != null && stopIndex < empTripIds.size()) return empTripIds.get(stopIndex);
//        return -1;
//    }
//
//    // ✅ Returns trip_id as String for OTP API (uses empTripIds list)
//    private String getTripIdForStop(int stopIndex) {
//        if (empTripIds != null && stopIndex < empTripIds.size()) {
//            int id = empTripIds.get(stopIndex);
//            return id == -1 ? "" : String.valueOf(id);
//        }
//        return "";
//    }
//
//    // ✅ Returns mobile number for stop
//    private String getEmpMobileForStop(int stopIndex) {
//        if (empMobiles != null && stopIndex < empMobiles.size()) {
//            String m = empMobiles.get(stopIndex);
//            return m != null ? m : "";
//        }
//        return "";
//    }
//
//    private int getEmpIdForStop(int stopIndex) {
//        if (empIds != null && stopIndex < empIds.size()) return empIds.get(stopIndex);
//        return -1;
//    }
//
//    private String getEmpNameForStop(int stopIndex) {
//        if (empNames != null && stopIndex < empNames.size()) return empNames.get(stopIndex);
//        return "Employee";
//    }
//
//    private ArrayList<String> buildAllStops() {
//        ArrayList<String> stops = new ArrayList<>();
//        if (startLocation != null && !startLocation.isEmpty()) stops.add(startLocation);
//        if (middleStops   != null) stops.addAll(middleStops);
//        if (endLocation   != null && !endLocation.isEmpty())   stops.add(endLocation);
//        Log.d(TAG, "allStops (" + stops.size() + "): " + stops);
//        return stops;
//    }
//
//    // ======================================================
//    // ROUTE PREVIEW (shown before trip starts)
//    // ======================================================
//
//    private void drawRoutePreview() {
//        LatLng origin = parseLatLng(startLocation);
//        LatLng dest   = parseLatLng(endLocation);
//        if (origin == null || dest == null) return;
//        fetchRoute(origin, dest);
//    }
//
//    private void fetchRoute(LatLng origin, LatLng destination) {
//        new Thread(() -> {
//            try {
//                StringBuilder url = new StringBuilder(
//                        "https://maps.googleapis.com/maps/api/directions/json?");
//                url.append("origin=").append(origin.latitude).append(",").append(origin.longitude);
//                url.append("&destination=").append(destination.latitude).append(",").append(destination.longitude);
//                if (middleStops != null && !middleStops.isEmpty()) {
//                    url.append("&waypoints=");
//                    for (int i = 0; i < middleStops.size(); i++) {
//                        url.append(middleStops.get(i));
//                        if (i < middleStops.size() - 1) url.append("|");
//                    }
//                }
//                url.append("&mode=driving&key=").append(GOOGLE_API_KEY);
//
//                HttpURLConnection conn = (HttpURLConnection) new URL(url.toString()).openConnection();
//                conn.connect();
//
//                BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
//                StringBuilder json = new StringBuilder();
//                String line;
//                while ((line = reader.readLine()) != null) json.append(line);
//
//                JSONObject obj = new JSONObject(json.toString());
//                JSONArray routes = obj.getJSONArray("routes");
//                if (routes.length() == 0) return;
//
//                JSONObject route  = routes.getJSONObject(0);
//                String polyline   = route.getJSONObject("overview_polyline").getString("points");
//                ArrayList<LatLng> path = decodePolyline(polyline);
//                JSONArray legs    = route.getJSONArray("legs");
//
//                runOnUiThread(() -> {
//                    if (mMap != null) {
//                        drawPolyline(path);
//                        drawMarkers(legs);
//                    }
//                });
//            } catch (Exception e) {
//                Log.e(TAG, "fetchRoute: " + e.getMessage(), e);
//            }
//        }).start();
//    }
//
//    private void drawPolyline(ArrayList<LatLng> path) {
//        mMap.addPolyline(new PolylineOptions()
//                .addAll(path).width(10f).color(0xFF1976D2).geodesic(true));
//        LatLngBounds.Builder b = new LatLngBounds.Builder();
//        for (LatLng p : path) b.include(p);
//        mMap.animateCamera(CameraUpdateFactory.newLatLngBounds(b.build(), 150));
//    }
//
//    private void drawMarkers(JSONArray legs) {
//        try {
//            ArrayList<LatLng> points = new ArrayList<>();
//            for (int i = 0; i < legs.length(); i++) {
//                JSONObject leg = legs.getJSONObject(i);
//                if (i == 0) {
//                    JSONObject s = leg.getJSONObject("start_location");
//                    points.add(new LatLng(s.getDouble("lat"), s.getDouble("lng")));
//                }
//                JSONObject e = leg.getJSONObject("end_location");
//                points.add(new LatLng(e.getDouble("lat"), e.getDouble("lng")));
//            }
//
//            markerStopIndexMap.clear();
//
//            for (int i = 0; i < points.size(); i++) {
//                String label = (stopLabels != null && i < stopLabels.size())
//                        ? stopLabels.get(i)
//                        : (i == 0 ? "Start" : i == points.size()-1 ? "End" : "Stop " + i);
//
//                float color = (i == 0) ? BitmapDescriptorFactory.HUE_GREEN
//                        : (i == points.size()-1) ? BitmapDescriptorFactory.HUE_RED
//                        : BitmapDescriptorFactory.HUE_ORANGE;
//
//                // ✅ snippet = "Tap to verify OTP" for employee stops
//                boolean isOffice = "Office".equals(label);
//                String snippet = isOffice
//                        ? (i == 0 ? "First stop — Office" : "Final destination — Office")
//                        : "Tap to verify OTP";
//
//                com.google.android.gms.maps.model.Marker marker = mMap.addMarker(
//                        new MarkerOptions()
//                                .position(points.get(i))
//                                .title(label)
//                                .snippet(snippet)
//                                .icon(BitmapDescriptorFactory.defaultMarker(color)));
//
//                // ✅ Store stop index keyed by marker title (unique per stop)
//                if (marker != null) {
//                    markerStopIndexMap.put(marker.getId(), i);
//                }
//            }
//
//            // ✅ Set marker click listener — show OTP dialog on tap
//            mMap.setOnMarkerClickListener(marker -> {
//                marker.showInfoWindow();
//
//                Integer stopIndex = markerStopIndexMap.get(marker.getId());
//                if (stopIndex == null) return false;
//
//                String label = marker.getTitle();
//                if (label == null) return false;
//
//                // Trip must be started before OTP dialogs are shown
//                if (allStops == null) {
//                    Toast.makeText(this, "Start the trip first", Toast.LENGTH_SHORT).show();
//                    return false;
//                }
//
//                boolean isLoginTrip = "Login".equalsIgnoreCase(tripType);
//                String  tripIdStr   = getTripIdForStop(stopIndex);
//                String  mobile      = getEmpMobileForStop(stopIndex);
//                int     empId       = getEmpIdForStop(stopIndex);
//                String  name        = getEmpNameForStop(stopIndex);
//
//                Log.d(TAG, "Marker tapped: " + label + " stopIndex=" + stopIndex
//                        + " empId=" + empId + " tripId=" + tripIdStr);
//
//                // ── OFFICE MARKER (Logout only) ────────────────────────
//                if ("Office".equals(label)) {
//                    if (isLoginTrip) {
//                        Toast.makeText(this, "Office is the final destination", Toast.LENGTH_SHORT).show();
//                        return false;
//                    }
//                    // Logout: tap office → board all employees one by one
//                    showOfficeboardingOtpSequence(stopIndex, 0, () -> {
//                        // All boarded → Fleet Engine: ENROUTE_TO_DROPOFF
//                        updateFleetEngineStatus(
//                                RidesharingVehicleReporter.VehicleState.ONLINE,
//                                "ENROUTE_TO_DROPOFF");
//                        navigateToStop(stopIndex + 1);
//                    });
//                    return true;
//                }
//
//                // ── EMPLOYEE MARKER ────────────────────────────────────
//                if (isLoginTrip) {
//                    // Login: employee tap → boarding OTP → ENROUTE_TO_DROPOFF
//                    showOtpDialogForStop(name, mobile, tripIdStr, empId,
//                            OtpVerifyDialog.TYPE_PICKUP, () -> {
//                                updateFleetEngineStatus(
//                                        RidesharingVehicleReporter.VehicleState.ONLINE,
//                                        "ENROUTE_TO_DROPOFF");
//                                navigateToStop(stopIndex + 1);
//                            });
//                } else {
//                    // Logout: employee tap → drop-off OTP → COMPLETE
//                    showOtpDialogForStop(name, mobile, tripIdStr, empId,
//                            OtpVerifyDialog.TYPE_DROPOFF, () -> {
//                                updateFleetEngineStatus(
//                                        RidesharingVehicleReporter.VehicleState.ONLINE,
//                                        "COMPLETE");
//                                boolean isLast = (stopIndex == allStops.size() - 1);
//                                if (isLast) {
//                                    Toast.makeText(this, "✅ Trip Complete!", Toast.LENGTH_LONG).show();
//                                } else {
//                                    navigateToStop(stopIndex + 1);
//                                }
//                            });
//                }
//
//                return true;
//            });
//
//        } catch (Exception e) {
//            Log.e(TAG, "drawMarkers: " + e.getMessage());
//        }
//    }
//
//    // ======================================================
//    // FLEET ENGINE STATUS UPDATE
//    // ======================================================
//
//    /**
//     * Updates Fleet Engine vehicle state and logs the trip status transition.
//     *
//     * statusLabel is just for logging — Fleet Engine state is controlled via
//     * vehicleReporter. The actual per-trip status (ENROUTE_TO_DROPOFF / COMPLETE)
//     * is sent to your backend via the OTP API (/updateTrip_status) which then
//     * updates Fleet Engine server-side.
//     *
//     * On the driver SDK side, we toggle the vehicle state to signal activity:
//     *   ENROUTE_TO_DROPOFF → vehicle is ONLINE and actively on a trip
//     *   COMPLETE           → vehicle is ONLINE, trip leg done, ready for next
//     */
//    private void updateFleetEngineStatus(
//            RidesharingVehicleReporter.VehicleState state,
//            String statusLabel) {
//
//        if (vehicleReporter == null) {
//            Log.w(TAG, "updateFleetEngineStatus: vehicleReporter is null, skipping");
//            return;
//        }
//
//        try {
//            vehicleReporter.setVehicleState(state);
//            Log.d(TAG, "✅ Fleet Engine status → " + statusLabel
//                    + " (VehicleState=" + state + ")");
//        } catch (Exception e) {
//            Log.e(TAG, "Fleet Engine status update failed: " + e.getMessage());
//        }
//    }
//
//    // ======================================================
//    // ARRIVAL CHECK — confirm GPS proximity before triggering OTP
//    // ======================================================
//
//    private void startArrivalCheck(LatLng destination, Runnable onReached) {
//        com.google.android.gms.location.FusedLocationProviderClient client =
//                com.google.android.gms.location.LocationServices
//                        .getFusedLocationProviderClient(this);
//
//        Handler handler = new Handler(Looper.getMainLooper());
//
//        Runnable checker = new Runnable() {
//            @Override
//            public void run() {
//                if (ActivityCompat.checkSelfPermission(MapActivity.this,
//                        Manifest.permission.ACCESS_FINE_LOCATION)
//                        != PackageManager.PERMISSION_GRANTED) return;
//
//                client.getLastLocation().addOnSuccessListener(location -> {
//                    if (location == null) { handler.postDelayed(this, 2000); return; }
//
//                    float[] result = new float[1];
//                    android.location.Location.distanceBetween(
//                            location.getLatitude(), location.getLongitude(),
//                            destination.latitude, destination.longitude, result);
//
//                    Log.d(TAG, "Arrival check: " + result[0] + "m from destination");
//
//                    if (result[0] < 50) {
//                        onReached.run();
//                    } else {
//                        handler.postDelayed(this, 2000);
//                    }
//                });
//            }
//        };
//
//        handler.post(checker);
//    }
//
//    // ======================================================
//    // HELPERS
//    // ======================================================
//
//    private boolean isLocationEnabled() {
//        LocationManager lm = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
//        return lm != null && (lm.isProviderEnabled(LocationManager.GPS_PROVIDER)
//                || lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER));
//    }
//
//    private LatLng parseLatLng(String s) {
//        try {
//            String[] p = s.split(",");
//            return new LatLng(Double.parseDouble(p[0].trim()), Double.parseDouble(p[1].trim()));
//        } catch (Exception e) {
//            Log.e(TAG, "parseLatLng failed: " + s);
//            return null;
//        }
//    }
//
//    private ArrayList<LatLng> decodePolyline(String encoded) {
//        ArrayList<LatLng> poly = new ArrayList<>();
//        int index = 0, lat = 0, lng = 0;
//        while (index < encoded.length()) {
//            int b, shift = 0, result = 0;
//            do { b = encoded.charAt(index++) - 63; result |= (b & 0x1f) << shift; shift += 5; } while (b >= 0x20);
//            lat += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//            shift = 0; result = 0;
//            do { b = encoded.charAt(index++) - 63; result |= (b & 0x1f) << shift; shift += 5; } while (b >= 0x20);
//            lng += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//            poly.add(new LatLng(lat / 1E5, lng / 1E5));
//        }
//        return poly;
//    }
//
//    private void startLoggingLocation() {
//        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
//                != PackageManager.PERMISSION_GRANTED) return;
//
//        com.google.android.gms.location.FusedLocationProviderClient client =
//                com.google.android.gms.location.LocationServices.getFusedLocationProviderClient(this);
//
//        com.google.android.gms.location.LocationRequest req =
//                com.google.android.gms.location.LocationRequest.create()
//                        .setInterval(2000).setFastestInterval(1000)
//                        .setPriority(com.google.android.gms.location.LocationRequest.PRIORITY_HIGH_ACCURACY);
//
//        client.requestLocationUpdates(req,
//                new com.google.android.gms.location.LocationCallback() {
//                    @Override
//                    public void onLocationResult(@NonNull com.google.android.gms.location.LocationResult result) {
//                        for (android.location.Location loc : result.getLocations()) {
//                            Log.d("LOCATION_DEBUG", "Lat=" + loc.getLatitude() + " Lng=" + loc.getLongitude());
//                        }
//                    }
//                }, Looper.getMainLooper());
//    }
//}


//this is manual way do it fleet engine navigation
//package com.example.ayaka;
//
//import android.Manifest;
//import android.content.Context;
//import android.content.Intent;
//import android.content.pm.PackageManager;
//import android.location.LocationManager;
//import android.os.Bundle;
//import android.os.Handler;
//import android.os.Looper;
//import android.provider.Settings;
//import android.util.Log;
//import android.view.View;
//import android.widget.Button;
//import android.widget.TextView;
//import android.widget.Toast;
//
//import androidx.annotation.NonNull;
//import androidx.appcompat.app.AppCompatActivity;
//import androidx.core.app.ActivityCompat;
//
//import com.google.android.gms.maps.CameraUpdateFactory;
//import com.google.android.gms.maps.GoogleMap;
//import com.google.android.gms.maps.OnMapReadyCallback;
//import com.google.android.gms.maps.model.BitmapDescriptorFactory;
//import com.google.android.gms.maps.model.LatLng;
//import com.google.android.gms.maps.model.LatLngBounds;
//import com.google.android.gms.maps.model.MarkerOptions;
//import com.google.android.gms.maps.model.PolylineOptions;
//
//import com.google.android.libraries.navigation.NavigationApi;
//import com.google.android.libraries.navigation.NavigationView;
//import com.google.android.libraries.navigation.Navigator;
//import com.google.android.libraries.navigation.RoadSnappedLocationProvider;
//import com.google.android.libraries.navigation.Waypoint;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.base.data.DriverContext;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.RidesharingDriverApi;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.vehiclereporter.RidesharingVehicleReporter;
//
//import com.google.android.material.bottomsheet.BottomSheetBehavior;
//
//import org.json.JSONArray;
//import org.json.JSONObject;
//
//import java.io.BufferedReader;
//import java.io.InputStreamReader;
//import java.net.HttpURLConnection;
//import java.net.URL;
//import java.util.ArrayList;
//
//public class MapActivity extends AppCompatActivity implements OnMapReadyCallback {
//
//    private static final String TAG                   = "MapActivity";
//    private static final int    LOCATION_PERMISSION   = 100;
//    private static final String PROVIDER_ID           = "ayaka-transassist-mobility";
//    private static final String GOOGLE_API_KEY        = "AIzaSyBNPLbzyyZzA3T1d5hSWkPE3tBW89MhKVw";
//
//    // ── Views ──────────────────────────────────────────────
//    private NavigationView            navigationView;
//    private GoogleMap                 mMap;
//    private BottomSheetBehavior<View> bottomSheetBehavior;
//
//    // ── Trip data ──────────────────────────────────────────
//    private String             startLocation, endLocation;
//    private ArrayList<String>  middleStops;
//    private ArrayList<String>  stopLabels;
//    private String             tripType;          // "Login" or "Logout"
//    private int                userId;
//    private ArrayList<Integer> empTripIds;  // per-employee trip_id from pickupDrop
//    private ArrayList<Integer> empIds;
//    private ArrayList<String>  empNames;
//    private ArrayList<String>  empMobiles; // ✅ mobile_number per employee
//    private String             startAddressText, endAddressText, date, time;
//    private double             distance;
//    private int                persons;
//
//    // ── SDK state ──────────────────────────────────────────
//    private Navigator                  navigator;
//    private RidesharingVehicleReporter vehicleReporter;
//    private boolean isDriverSdkReady      = false;
//    private boolean isNavigatorReady      = false;
//    private boolean shouldStartNavigation = false;
//    private boolean termsAlreadyShown     = false;
//
//    // ── Navigation state ───────────────────────────────────
//    // allStops: full ordered list [startLocation, middleStops..., endLocation]
//    private ArrayList<String> allStops;
//    private int currentStopIndex = 0;
//
//    // ✅ Maps marker title → stop index so tapping a marker shows the right OTP
//    private java.util.HashMap<String, Integer> markerStopIndexMap = new java.util.HashMap<>();
//
//    // ======================================================
//    // LIFECYCLE
//    // ======================================================
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_map);
//
//        startLocation    = getIntent().getStringExtra("start_location");
//        endLocation      = getIntent().getStringExtra("end_location");
//        middleStops      = getIntent().getStringArrayListExtra("middle_stops");
//        startAddressText = getIntent().getStringExtra("start_address");
//        endAddressText   = getIntent().getStringExtra("end_address");
//        date             = getIntent().getStringExtra("date");
//        time             = getIntent().getStringExtra("time");
//        distance         = getIntent().getDoubleExtra("distance", 0);
//        persons          = getIntent().getIntExtra("persons", 0);
//        tripType         = getIntent().getStringExtra("trip_type");
//        stopLabels       = getIntent().getStringArrayListExtra("stop_labels");
//        userId           = getIntent().getIntExtra("user_id", 0);
//        empTripIds       = getIntent().getIntegerArrayListExtra("emp_trip_ids");
//        empIds           = getIntent().getIntegerArrayListExtra("emp_ids");
//        empNames         = getIntent().getStringArrayListExtra("emp_names");
//        empMobiles       = getIntent().getStringArrayListExtra("emp_mobiles");
//
//        if (stopLabels == null) stopLabels  = new ArrayList<>();
//        if (empTripIds == null) empTripIds  = new ArrayList<>();
//        if (empIds     == null) empIds      = new ArrayList<>();
//        if (empNames   == null) empNames    = new ArrayList<>();
//        if (empMobiles == null) empMobiles  = new ArrayList<>();
//
//        navigationView = findViewById(R.id.navigation_view);
//        navigationView.onCreate(savedInstanceState);
//
//        setupBottomSheet();
//
//        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
//                != PackageManager.PERMISSION_GRANTED) {
//            ActivityCompat.requestPermissions(this,
//                    new String[]{Manifest.permission.ACCESS_FINE_LOCATION,
//                            Manifest.permission.ACCESS_COARSE_LOCATION},
//                    LOCATION_PERMISSION);
//        } else {
//            initSdk();
//        }
//    }
//
//    @Override protected void onStart()   { super.onStart();   navigationView.onStart(); }
//    @Override protected void onResume()  { super.onResume();  navigationView.onResume(); }
//    @Override protected void onPause()   { super.onPause();   navigationView.onPause(); }
//    @Override protected void onStop()    { super.onStop();    navigationView.onStop(); }
//    @Override protected void onDestroy() { super.onDestroy(); navigationView.onDestroy(); }
//
//    @Override
//    public void onSaveInstanceState(@NonNull Bundle out) {
//        super.onSaveInstanceState(out);
//        navigationView.onSaveInstanceState(out);
//    }
//
//    @Override
//    public void onRequestPermissionsResult(int code, @NonNull String[] perms, @NonNull int[] results) {
//        super.onRequestPermissionsResult(code, perms, results);
//        if (code == LOCATION_PERMISSION) {
//            if (results.length > 0 && results[0] == PackageManager.PERMISSION_GRANTED) {
//                initSdk();
//            } else {
//                Toast.makeText(this, "Location permission required", Toast.LENGTH_LONG).show();
//                navigationView.getMapAsync(this);
//            }
//        }
//    }
//
//    // ======================================================
//    // SDK INIT
//    // ======================================================
//
//    private void initSdk() {
//        if (!isLocationEnabled()) {
//            Toast.makeText(this, "Please enable GPS", Toast.LENGTH_LONG).show();
//            startActivity(new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS));
//        }
//
//        NavigationApi.getNavigator(this, new NavigationApi.NavigatorListener() {
//
//            @Override
//            public void onNavigatorReady(@NonNull Navigator nav) {
//                Log.d(TAG, "✅ onNavigatorReady");
//                navigator        = nav;
//                isNavigatorReady = true;
//                termsAlreadyShown = false;
//
//                navigationView.getMapAsync(MapActivity.this);
//                new Handler(Looper.getMainLooper()).postDelayed(() -> setupDriverApi(nav), 800);
//
//                if (shouldStartNavigation) {
//                    // allStops was already built in onStartTripClicked before
//                    // shouldStartNavigation was set — safe to call directly
//                    if (allStops == null || allStops.isEmpty()) {
//                        allStops = buildAllStops();  // safety fallback
//                    }
//                    startNavigation();
//                }
//            }
//
//            @Override
//            public void onError(@NavigationApi.ErrorCode int errorCode) {
//                boolean isTerms = (errorCode == NavigationApi.ErrorCode.TERMS_NOT_ACCEPTED)
//                        || (errorCode == 4);
//                if (isTerms && !termsAlreadyShown) {
//                    termsAlreadyShown = true;
//                    NavigationApi.showTermsAndConditionsDialog(MapActivity.this,
//                            "Ayaka Transassist", "Accept navigation terms",
//                            accepted -> {
//                                if (accepted) NavigationApi.getNavigator(MapActivity.this, this);
//                                else navigationView.getMapAsync(MapActivity.this);
//                            });
//                } else {
//                    navigationView.getMapAsync(MapActivity.this);
//                }
//            }
//        });
//    }
//
//    @Override
//    public void onMapReady(@NonNull GoogleMap googleMap) {
//        Log.d(TAG, "✅ onMapReady");
//        mMap = googleMap;
//        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
//                == PackageManager.PERMISSION_GRANTED) {
//            mMap.setMyLocationEnabled(true);
//            mMap.getUiSettings().setMyLocationButtonEnabled(true);
//        }
//        drawRoutePreview();
//    }
//
//    // ======================================================
//    // DRIVER SDK
//    // ======================================================
//
//    private void setupDriverApi(Navigator nav) {
//        if (App.getDriverApi() != null) {
//            Log.d(TAG, "✅ Reusing existing DriverApi");
//            isDriverSdkReady = true;
//            return;
//        }
//        try {
//            RoadSnappedLocationProvider provider =
//                    NavigationApi.getRoadSnappedLocationProvider(getApplication());
//            if (provider == null) return;
//
//            SessionManager session = new SessionManager(getApplicationContext());
//            String token     = session.getAccessToken();
//            String vehicleId = session.getVehicleId();
//            if (vehicleId == null || vehicleId.isEmpty() || token == null || token.isEmpty()) return;
//
//            DriverContext ctx = DriverContext.builder(getApplication())
//                    .setProviderId(PROVIDER_ID)
//                    .setVehicleId(vehicleId)
//                    .setNavigator(nav)
//                    .setRoadSnappedLocationProvider(provider)
//                    .setAuthTokenFactory(new StaticAuthTokenFactory(token))
//                    .build();
//
//            App.setDriverApi(RidesharingDriverApi.createInstance(ctx));
//            isDriverSdkReady = true;
//            Log.d(TAG, "✅ Driver SDK initialized");
//        } catch (Exception e) {
//            Log.e(TAG, "Driver SDK error: " + e.getMessage(), e);
//        }
//    }
//
//    // ======================================================
//    // BOTTOM SHEET
//    // ======================================================
//
//    private void setupBottomSheet() {
//        View bottomSheet = findViewById(R.id.bottomSheet);
//        bottomSheetBehavior = BottomSheetBehavior.from(bottomSheet);
//        bottomSheetBehavior.setState(BottomSheetBehavior.STATE_EXPANDED);
//
//        ((TextView) findViewById(R.id.startAddress)).setText("Start: " + startAddressText);
//        ((TextView) findViewById(R.id.endAddress)).setText("End: " + endAddressText);
//        ((TextView) findViewById(R.id.tripDistance)).setText(
//                String.format(java.util.Locale.getDefault(), "%.2f km", distance));
//        ((TextView) findViewById(R.id.personCount)).setText(String.valueOf(persons));
//        ((TextView) findViewById(R.id.tripDate)).setText(date);
//        ((TextView) findViewById(R.id.tripTime)).setText(time);
//
//        Button startTrip = findViewById(R.id.startTrip);
//        startTrip.setOnClickListener(v -> {
//            bottomSheetBehavior.setState(BottomSheetBehavior.STATE_HIDDEN);
//            onStartTripClicked();
//        });
//    }
//
//    // ======================================================
//    // START TRIP
//    // ======================================================
//
//    private void onStartTripClicked() {
//        if (!isLocationEnabled()) {
//            Toast.makeText(this, "Please enable GPS", Toast.LENGTH_LONG).show();
//            return;
//        }
//
//        if (!isDriverSdkReady && App.getDriverApi() != null) isDriverSdkReady = true;
//
//        if (isDriverSdkReady && App.getDriverApi() != null) {
//            try {
//                vehicleReporter = App.getDriverApi().getRidesharingVehicleReporter();
//                vehicleReporter.enableLocationTracking();
//                vehicleReporter.setVehicleState(RidesharingVehicleReporter.VehicleState.ONLINE);
//                Log.d(TAG, "✅ Fleet Engine tracking ON");
//            } catch (Exception e) {
//                Log.e(TAG, "VehicleReporter: " + e.getMessage());
//            }
//        }
//
//        startLoggingLocation();   // ✅ start FusedLocation logging
//        allStops = buildAllStops();
//        currentStopIndex = 0;
//
//        if (isNavigatorReady) {
//            navigateToStop(currentStopIndex);
//        } else {
//            shouldStartNavigation = true;
//            Toast.makeText(this, "Initializing navigation...", Toast.LENGTH_SHORT).show();
//        }
//    }
//
//    private void startNavigation() {
//        if (navigator == null || allStops == null || allStops.isEmpty()) return;
//        currentStopIndex = 0;
//        navigateToStop(currentStopIndex);
//    }
//
//    // ======================================================
//    // CORE NAVIGATION + OTP FLOW
//    //
//    // Stop sequence (allStops):
//    //   Login:  [emp0, emp1, ..., empN, office]
//    //   Logout: [office, emp0, emp1, ..., empN]
//    //
//    // OTP rules:
//    //   Login:  arrive at each employee → show OTP (ENROUTE_TO_DROPOFF)
//    //           arrive at office → trip complete (no OTP)
//    //   Logout: arrive at office → show boarding OTP for EACH employee
//    //                              (ENROUTE_TO_DROPOFF per emp_id)
//    //           arrive at each drop → show OTP (COMPLETE per emp_id)
//    // ======================================================
//
//    // Single reusable arrival listener — replaced each stop to prevent stacking
//    private Navigator.ArrivalListener currentArrivalListener = null;
//    private boolean arrivalHandled = false;   // prevent double-firing
//
//    private void navigateToStop(int index) {
//        if (navigator == null) return;
//        if (index >= allStops.size()) {
//            runOnUiThread(() -> Toast.makeText(this, "✅ Trip Complete!", Toast.LENGTH_LONG).show());
//            return;
//        }
//
//        String target = allStops.get(index);
//        LatLng dest   = parseLatLng(target);
//        if (dest == null) { Log.e(TAG, "Bad LatLng at stop " + index); return; }
//
//        String label = (stopLabels != null && index < stopLabels.size())
//                ? stopLabels.get(index) : "Stop " + (index + 1);
//
//        Log.d(TAG, "→ Navigating to stop " + index + ": " + label);
//        Toast.makeText(this, "Navigating to " + label, Toast.LENGTH_SHORT).show();
//
//        // ✅ Set destination
//        Waypoint wp = Waypoint.builder().setLatLng(dest.latitude, dest.longitude).build();
//        navigator.clearDestinations();
//        navigator.setDestination(wp);
//        navigator.startGuidance();
//
//        // ✅ Remove previous arrival listener before adding new one
//        //    This prevents listeners stacking up across multiple stops
//        if (currentArrivalListener != null) {
//            navigator.removeArrivalListener(currentArrivalListener);
//        }
//        arrivalHandled = false;
//
//        currentArrivalListener = event -> {
//            // ✅ Guard: ignore if already handled (listener can fire multiple times)
//            if (arrivalHandled) return;
//            arrivalHandled = true;
//
//            Log.d(TAG, "ArrivalListener fired for stop " + index);
//
//            // ✅ GPS proximity check (50m) before showing OTP
//            //    This confirms the driver is physically there,
//            //    not just that the Navigation SDK thinks they arrived
//            startArrivalCheck(dest, () ->
//                    runOnUiThread(() -> onArrivedAtStop(index)));
//        };
//
//        navigator.addArrivalListener(currentArrivalListener);
//    }
//
//    /**
//     * Called when driver physically arrives at a stop.
//     * Decides what OTP dialog(s) to show, then advances to next stop.
//     */
//    private void onArrivedAtStop(int index) {
//        String label = (stopLabels != null && index < stopLabels.size())
//                ? stopLabels.get(index) : "Stop " + (index + 1);
//        boolean isLastStop = (index == allStops.size() - 1);
//        boolean isLogin    = "Login".equalsIgnoreCase(tripType);
//
//        Log.d(TAG, "Arrived at stop " + index + " (" + label + ") isLast=" + isLastStop);
//
//        if (isLastStop) {
//            // ── Final stop ────────────────────────────────────────────
//            if (isLogin && "Office".equals(label)) {
//                // Login: reached office — mark trip COMPLETE in Fleet Engine
//                updateFleetEngineStatus(RidesharingVehicleReporter.VehicleState.ONLINE, "COMPLETE");
//                Toast.makeText(this, "✅ All employees at office! Trip complete.", Toast.LENGTH_LONG).show();
//            } else {
//                updateFleetEngineStatus(RidesharingVehicleReporter.VehicleState.ONLINE, "COMPLETE");
//                Toast.makeText(this, "✅ Trip Complete!", Toast.LENGTH_LONG).show();
//            }
//
//        } else if (!isLogin && "Office".equals(label)) {
//            // ── LOGOUT: arrived at office — show boarding OTP for each employee ──
//            // Driver must verify each employee's boarding OTP before leaving office
//            Toast.makeText(this, "Arrived at Office — verify employee boarding OTPs", Toast.LENGTH_SHORT).show();
//            showOfficeboardingOtpSequence(index, 0, () -> {
//                // All employees boarded — navigate to first drop
//                navigateToStop(index + 1);
//            });
//
//        } else {
//            // ── Normal stop (employee for login, or non-office) ───────
//            // OTP for employee stops is handled by marker tap
//            // Just show arrival toast and auto-advance
//            Toast.makeText(this, "Arrived at " + label, Toast.LENGTH_SHORT).show();
//            navigateToStop(index + 1);
//        }
//    }
//
//    /**
//     * For LOGOUT trips at office: show boarding OTP for each employee sequentially.
//     * empOffset tracks which employee in the allStops list we are verifying.
//     * Employees in allStops start at index officeIndex+1.
//     */
//    private void showOfficeboardingOtpSequence(int officeStopIndex, int empOffset, Runnable onAllBoarded) {
//        // Employees start after office (officeStopIndex + 1)
//        int empStopIndex = officeStopIndex + 1 + empOffset;
//
//        if (empStopIndex >= allStops.size()) {
//            Toast.makeText(this, "✅ All employees boarded!", Toast.LENGTH_SHORT).show();
//            onAllBoarded.run();  // caller handles Fleet Engine update
//            return;
//        }
//
//        String empLabel = (stopLabels != null && empStopIndex < stopLabels.size())
//                ? stopLabels.get(empStopIndex) : "Employee " + (empOffset + 1);
//
//        // Skip if this is not an employee stop
//        if ("Office".equals(empLabel)) {
//            onAllBoarded.run();
//            return;
//        }
//
//        int    empId     = getEmpIdForStop(empStopIndex);
//        String empName   = getEmpNameForStop(empStopIndex);
//        String empTripId = getTripIdForStop(empStopIndex);
//        String empMobile = getEmpMobileForStop(empStopIndex);
//
//        // ✅ Full debug — check all values before showing dialog
//        Log.d(TAG, "=== OFFICE BOARDING OTP ===");
//        Log.d(TAG, "officeStopIndex = " + officeStopIndex);
//        Log.d(TAG, "empOffset       = " + empOffset);
//        Log.d(TAG, "empStopIndex    = " + empStopIndex);
//        Log.d(TAG, "empName         = " + empName);
//        Log.d(TAG, "empId           = " + empId);
//        Log.d(TAG, "empTripId       = [" + empTripId + "]");
//        Log.d(TAG, "empMobile       = " + empMobile);
//        Log.d(TAG, "type            = " + OtpVerifyDialog.TYPE_PICKUP);
//        Log.d(TAG, "userId          = " + userId);
//        Log.d(TAG, "===========================");
//
//        if (empTripId.isEmpty()) {
//            Log.e(TAG, "❌ empTripId is EMPTY for empStopIndex=" + empStopIndex
//                    + " — check empTripIds list");
//            Log.e(TAG, "empTripIds = " + empTripIds);
//            Toast.makeText(this, "Trip ID missing for " + empName, Toast.LENGTH_LONG).show();
//            return;
//        }
//
//        // Show boarding OTP dialog — after verified, show next employee's dialog
//        showOtpDialogForStop(
//                empName,
//                empMobile,
//                empTripId,
//                empId,
//                OtpVerifyDialog.TYPE_PICKUP,
//                () -> showOfficeboardingOtpSequence(officeStopIndex, empOffset + 1, onAllBoarded)
//        );
//    }
//
//    /**
//     * Shows OtpVerifyDialog for one employee.
//     * empTripId = the trip_id from pickupDrop for this specific employee.
//     */
//    private void showOtpDialog(String empName, int empTripId, int empId,
//                               String type, Runnable onVerified) {
//        // Not used directly — use showOtpDialogForStop instead
//        showOtpDialogForStop(empName, "", String.valueOf(empTripId), empId, type, onVerified);
//    }
//
//    // ✅ Full method with mobile support
//    private void showOtpDialogForStop(String empName, String mobile, String tripIdStr,
//                                      int empId, String type, Runnable onVerified) {
//        Log.d(TAG, "OTP dialog: emp=" + empName + " mobile=" + mobile
//                + " tripId=" + tripIdStr + " empId=" + empId + " type=" + type);
//        OtpVerifyDialog.show(
//                getSupportFragmentManager(),
//                empName,
//                mobile,
//                userId,
//                tripIdStr,
//                empId,
//                type,
//                onVerified::run
//        );
//    }
//
//    // ── Stop data helpers ──────────────────────────────────
//
//    private int getEmpTripIdForStop(int stopIndex) {
//        if (empTripIds != null && stopIndex < empTripIds.size()) return empTripIds.get(stopIndex);
//        return -1;
//    }
//
//    // ✅ Returns trip_id as String for OTP API (uses empTripIds list)
//    private String getTripIdForStop(int stopIndex) {
//        if (empTripIds != null && stopIndex < empTripIds.size()) {
//            int id = empTripIds.get(stopIndex);
//            return id == -1 ? "" : String.valueOf(id);
//        }
//        return "";
//    }
//
//    // ✅ Returns mobile number for stop
//    private String getEmpMobileForStop(int stopIndex) {
//        if (empMobiles != null && stopIndex < empMobiles.size()) {
//            String m = empMobiles.get(stopIndex);
//            return m != null ? m : "";
//        }
//        return "";
//    }
//
//    private int getEmpIdForStop(int stopIndex) {
//        if (empIds != null && stopIndex < empIds.size()) return empIds.get(stopIndex);
//        return -1;
//    }
//
//    private String getEmpNameForStop(int stopIndex) {
//        if (empNames != null && stopIndex < empNames.size()) return empNames.get(stopIndex);
//        return "Employee";
//    }
//
//    private ArrayList<String> buildAllStops() {
//        ArrayList<String> stops = new ArrayList<>();
//        if (startLocation != null && !startLocation.isEmpty()) stops.add(startLocation);
//        if (middleStops   != null) stops.addAll(middleStops);
//        if (endLocation   != null && !endLocation.isEmpty())   stops.add(endLocation);
//        Log.d(TAG, "allStops (" + stops.size() + "): " + stops);
//        return stops;
//    }
//
//    // ======================================================
//    // ROUTE PREVIEW (shown before trip starts)
//    // ======================================================
//
//    private void drawRoutePreview() {
//        LatLng origin = parseLatLng(startLocation);
//        LatLng dest   = parseLatLng(endLocation);
//        if (origin == null || dest == null) return;
//        fetchRoute(origin, dest);
//    }
//
//    private void fetchRoute(LatLng origin, LatLng destination) {
//        new Thread(() -> {
//            try {
//                StringBuilder url = new StringBuilder(
//                        "https://maps.googleapis.com/maps/api/directions/json?");
//                url.append("origin=").append(origin.latitude).append(",").append(origin.longitude);
//                url.append("&destination=").append(destination.latitude).append(",").append(destination.longitude);
//                if (middleStops != null && !middleStops.isEmpty()) {
//                    url.append("&waypoints=");
//                    for (int i = 0; i < middleStops.size(); i++) {
//                        url.append(middleStops.get(i));
//                        if (i < middleStops.size() - 1) url.append("|");
//                    }
//                }
//                url.append("&mode=driving&key=").append(GOOGLE_API_KEY);
//
//                HttpURLConnection conn = (HttpURLConnection) new URL(url.toString()).openConnection();
//                conn.connect();
//
//                BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
//                StringBuilder json = new StringBuilder();
//                String line;
//                while ((line = reader.readLine()) != null) json.append(line);
//
//                JSONObject obj = new JSONObject(json.toString());
//                JSONArray routes = obj.getJSONArray("routes");
//                if (routes.length() == 0) return;
//
//                JSONObject route  = routes.getJSONObject(0);
//                String polyline   = route.getJSONObject("overview_polyline").getString("points");
//                ArrayList<LatLng> path = decodePolyline(polyline);
//                JSONArray legs    = route.getJSONArray("legs");
//
//                runOnUiThread(() -> {
//                    if (mMap != null) {
//                        drawPolyline(path);
//                        drawMarkers(legs);
//                    }
//                });
//            } catch (Exception e) {
//                Log.e(TAG, "fetchRoute: " + e.getMessage(), e);
//            }
//        }).start();
//    }
//
//    private void drawPolyline(ArrayList<LatLng> path) {
//        mMap.addPolyline(new PolylineOptions()
//                .addAll(path).width(10f).color(0xFF1976D2).geodesic(true));
//        LatLngBounds.Builder b = new LatLngBounds.Builder();
//        for (LatLng p : path) b.include(p);
//        mMap.animateCamera(CameraUpdateFactory.newLatLngBounds(b.build(), 150));
//    }
//
//    private void drawMarkers(JSONArray legs) {
//        try {
//            ArrayList<LatLng> points = new ArrayList<>();
//            for (int i = 0; i < legs.length(); i++) {
//                JSONObject leg = legs.getJSONObject(i);
//                if (i == 0) {
//                    JSONObject s = leg.getJSONObject("start_location");
//                    points.add(new LatLng(s.getDouble("lat"), s.getDouble("lng")));
//                }
//                JSONObject e = leg.getJSONObject("end_location");
//                points.add(new LatLng(e.getDouble("lat"), e.getDouble("lng")));
//            }
//
//            markerStopIndexMap.clear();
//
//            for (int i = 0; i < points.size(); i++) {
//                String label = (stopLabels != null && i < stopLabels.size())
//                        ? stopLabels.get(i)
//                        : (i == 0 ? "Start" : i == points.size()-1 ? "End" : "Stop " + i);
//
//                float color = (i == 0) ? BitmapDescriptorFactory.HUE_GREEN
//                        : (i == points.size()-1) ? BitmapDescriptorFactory.HUE_RED
//                        : BitmapDescriptorFactory.HUE_ORANGE;
//
//                // ✅ snippet = "Tap to verify OTP" for employee stops
//                boolean isOffice = "Office".equals(label);
//                String snippet = isOffice
//                        ? (i == 0 ? "First stop — Office" : "Final destination — Office")
//                        : "Tap to verify OTP";
//
//                com.google.android.gms.maps.model.Marker marker = mMap.addMarker(
//                        new MarkerOptions()
//                                .position(points.get(i))
//                                .title(label)
//                                .snippet(snippet)
//                                .icon(BitmapDescriptorFactory.defaultMarker(color)));
//
//                // ✅ Store stop index keyed by marker title (unique per stop)
//                if (marker != null) {
//                    markerStopIndexMap.put(marker.getId(), i);
//                }
//            }
//
//            // ✅ Set marker click listener — show OTP dialog on tap
//            mMap.setOnMarkerClickListener(marker -> {
//                marker.showInfoWindow();
//
//                Integer stopIndex = markerStopIndexMap.get(marker.getId());
//                if (stopIndex == null) return false;
//
//                String label = marker.getTitle();
//                if (label == null) return false;
//
//                // Trip must be started before OTP dialogs are shown
//                if (allStops == null) {
//                    Toast.makeText(this, "Start the trip first", Toast.LENGTH_SHORT).show();
//                    return false;
//                }
//
//                boolean isLoginTrip = "Login".equalsIgnoreCase(tripType);
//                String  tripIdStr   = getTripIdForStop(stopIndex);
//                String  mobile      = getEmpMobileForStop(stopIndex);
//                int     empId       = getEmpIdForStop(stopIndex);
//                String  name        = getEmpNameForStop(stopIndex);
//
//                Log.d(TAG, "Marker tapped: " + label + " stopIndex=" + stopIndex
//                        + " empId=" + empId + " tripId=" + tripIdStr);
//
//                // ── OFFICE MARKER (Logout only) ────────────────────────
//                if ("Office".equals(label)) {
//                    if (isLoginTrip) {
//                        Toast.makeText(this, "Office is the final destination", Toast.LENGTH_SHORT).show();
//                        return false;
//                    }
//                    // Logout: tap office → board all employees one by one
//                    showOfficeboardingOtpSequence(stopIndex, 0, () -> {
//                        // All boarded → Fleet Engine: ENROUTE_TO_DROPOFF
//                        updateFleetEngineStatus(
//                                RidesharingVehicleReporter.VehicleState.ONLINE,
//                                "ENROUTE_TO_DROPOFF");
//                        navigateToStop(stopIndex + 1);
//                    });
//                    return true;
//                }
//
//                // ── EMPLOYEE MARKER ────────────────────────────────────
//                if (isLoginTrip) {
//                    // Login: employee tap → boarding OTP → ENROUTE_TO_DROPOFF
//                    showOtpDialogForStop(name, mobile, tripIdStr, empId,
//                            OtpVerifyDialog.TYPE_PICKUP, () -> {
//                                updateFleetEngineStatus(
//                                        RidesharingVehicleReporter.VehicleState.ONLINE,
//                                        "ENROUTE_TO_DROPOFF");
//                                navigateToStop(stopIndex + 1);
//                            });
//                } else {
//                    // Logout: employee tap → drop-off OTP → COMPLETE
//                    showOtpDialogForStop(name, mobile, tripIdStr, empId,
//                            OtpVerifyDialog.TYPE_DROPOFF, () -> {
//                                updateFleetEngineStatus(
//                                        RidesharingVehicleReporter.VehicleState.ONLINE,
//                                        "COMPLETE");
//                                boolean isLast = (stopIndex == allStops.size() - 1);
//                                if (isLast) {
//                                    Toast.makeText(this, "✅ Trip Complete!", Toast.LENGTH_LONG).show();
//                                } else {
//                                    navigateToStop(stopIndex + 1);
//                                }
//                            });
//                }
//
//                return true;
//            });
//
//        } catch (Exception e) {
//            Log.e(TAG, "drawMarkers: " + e.getMessage());
//        }
//    }
//
//    // ======================================================
//    // FLEET ENGINE STATUS UPDATE
//    // ======================================================
//
//    /**
//     * Updates Fleet Engine vehicle state and logs the trip status transition.
//     *
//     * statusLabel is just for logging — Fleet Engine state is controlled via
//     * vehicleReporter. The actual per-trip status (ENROUTE_TO_DROPOFF / COMPLETE)
//     * is sent to your backend via the OTP API (/updateTrip_status) which then
//     * updates Fleet Engine server-side.
//     *
//     * On the driver SDK side, we toggle the vehicle state to signal activity:
//     *   ENROUTE_TO_DROPOFF → vehicle is ONLINE and actively on a trip
//     *   COMPLETE           → vehicle is ONLINE, trip leg done, ready for next
//     */
//    private void updateFleetEngineStatus(
//            RidesharingVehicleReporter.VehicleState state,
//            String statusLabel) {
//
//        if (vehicleReporter == null) {
//            Log.w(TAG, "updateFleetEngineStatus: vehicleReporter is null, skipping");
//            return;
//        }
//
//        try {
//            vehicleReporter.setVehicleState(state);
//            Log.d(TAG, "✅ Fleet Engine status → " + statusLabel
//                    + " (VehicleState=" + state + ")");
//        } catch (Exception e) {
//            Log.e(TAG, "Fleet Engine status update failed: " + e.getMessage());
//        }
//    }
//
//    // ======================================================
//    // ARRIVAL CHECK — confirm GPS proximity before triggering OTP
//    // ======================================================
//
//    private void startArrivalCheck(LatLng destination, Runnable onReached) {
//        com.google.android.gms.location.FusedLocationProviderClient client =
//                com.google.android.gms.location.LocationServices
//                        .getFusedLocationProviderClient(this);
//
//        Handler handler = new Handler(Looper.getMainLooper());
//
//        Runnable checker = new Runnable() {
//            @Override
//            public void run() {
//                if (ActivityCompat.checkSelfPermission(MapActivity.this,
//                        Manifest.permission.ACCESS_FINE_LOCATION)
//                        != PackageManager.PERMISSION_GRANTED) return;
//
//                client.getLastLocation().addOnSuccessListener(location -> {
//                    if (location == null) { handler.postDelayed(this, 2000); return; }
//
//                    float[] result = new float[1];
//                    android.location.Location.distanceBetween(
//                            location.getLatitude(), location.getLongitude(),
//                            destination.latitude, destination.longitude, result);
//
//                    Log.d(TAG, "Arrival check: " + result[0] + "m from destination");
//
//                    if (result[0] < 50) {
//                        onReached.run();
//                    } else {
//                        handler.postDelayed(this, 2000);
//                    }
//                });
//            }
//        };
//
//        handler.post(checker);
//    }
//
//    // ======================================================
//    // HELPERS
//    // ======================================================
//
//    private boolean isLocationEnabled() {
//        LocationManager lm = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
//        return lm != null && (lm.isProviderEnabled(LocationManager.GPS_PROVIDER)
//                || lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER));
//    }
//
//    private LatLng parseLatLng(String s) {
//        try {
//            String[] p = s.split(",");
//            return new LatLng(Double.parseDouble(p[0].trim()), Double.parseDouble(p[1].trim()));
//        } catch (Exception e) {
//            Log.e(TAG, "parseLatLng failed: " + s);
//            return null;
//        }
//    }
//
//    private ArrayList<LatLng> decodePolyline(String encoded) {
//        ArrayList<LatLng> poly = new ArrayList<>();
//        int index = 0, lat = 0, lng = 0;
//        while (index < encoded.length()) {
//            int b, shift = 0, result = 0;
//            do { b = encoded.charAt(index++) - 63; result |= (b & 0x1f) << shift; shift += 5; } while (b >= 0x20);
//            lat += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//            shift = 0; result = 0;
//            do { b = encoded.charAt(index++) - 63; result |= (b & 0x1f) << shift; shift += 5; } while (b >= 0x20);
//            lng += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//            poly.add(new LatLng(lat / 1E5, lng / 1E5));
//        }
//        return poly;
//    }
//
//    private void startLoggingLocation() {
//        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
//                != PackageManager.PERMISSION_GRANTED) return;
//
//        com.google.android.gms.location.FusedLocationProviderClient client =
//                com.google.android.gms.location.LocationServices.getFusedLocationProviderClient(this);
//
//        com.google.android.gms.location.LocationRequest req =
//                com.google.android.gms.location.LocationRequest.create()
//                        .setInterval(2000).setFastestInterval(1000)
//                        .setPriority(com.google.android.gms.location.LocationRequest.PRIORITY_HIGH_ACCURACY);
//
//        client.requestLocationUpdates(req,
//                new com.google.android.gms.location.LocationCallback() {
//                    @Override
//                    public void onLocationResult(@NonNull com.google.android.gms.location.LocationResult result) {
//                        for (android.location.Location loc : result.getLocations()) {
//                            Log.d("LOCATION_DEBUG", "Lat=" + loc.getLatitude() + " Lng=" + loc.getLongitude());
//                        }
//                    }
//                }, Looper.getMainLooper());
//    }
//}

//package com.example.ayaka;
//
//import android.Manifest;
//import android.content.Context;
//import android.content.Intent;
//import android.content.pm.PackageManager;
//import android.location.LocationManager;
//import android.os.Bundle;
//import android.os.Handler;
//import android.os.Looper;
//import android.provider.Settings;
//import android.util.Log;
//import android.view.View;
//import android.widget.Button;
//import android.widget.TextView;
//import android.widget.Toast;
//
//import androidx.annotation.NonNull;
//import androidx.appcompat.app.AppCompatActivity;
//import androidx.core.app.ActivityCompat;
//
//import com.google.android.gms.maps.CameraUpdateFactory;
//import com.google.android.gms.maps.GoogleMap;
//import com.google.android.gms.maps.OnMapReadyCallback;
//import com.google.android.gms.maps.model.BitmapDescriptorFactory;
//import com.google.android.gms.maps.model.LatLng;
//import com.google.android.gms.maps.model.LatLngBounds;
//import com.google.android.gms.maps.model.MarkerOptions;
//import com.google.android.gms.maps.model.PolylineOptions;
//
//import com.google.android.libraries.navigation.NavigationApi;
//import com.google.android.libraries.navigation.NavigationView;
//import com.google.android.libraries.navigation.Navigator;
//import com.google.android.libraries.navigation.RoadSnappedLocationProvider;
//import com.google.android.libraries.navigation.Waypoint;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.base.data.DriverContext;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.RidesharingDriverApi;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.vehiclereporter.RidesharingVehicleReporter;
//
//import com.google.android.material.bottomsheet.BottomSheetBehavior;
//
//import org.json.JSONArray;
//import org.json.JSONObject;
//
//import java.io.BufferedReader;
//import java.io.InputStreamReader;
//import java.net.HttpURLConnection;
//import java.net.URL;
//import java.util.ArrayList;
//
//public class MapActivity extends AppCompatActivity implements OnMapReadyCallback {
//
//    private static final String TAG                   = "MapActivity";
//    private static final int    LOCATION_PERMISSION   = 100;
//    private static final String PROVIDER_ID           = "ayaka-transassist-mobility";
//    private static final String GOOGLE_API_KEY        = "AIzaSyBNPLbzyyZzA3T1d5hSWkPE3tBW89MhKVw";
//
//    // ── Views ──────────────────────────────────────────────
//    private NavigationView            navigationView;
//    private GoogleMap                 mMap;
//    private BottomSheetBehavior<View> bottomSheetBehavior;
//
//    // ── Trip data ──────────────────────────────────────────
//    private String             startLocation, endLocation;
//    private ArrayList<String>  middleStops;
//    private ArrayList<String>  stopLabels;
//    private String             tripType;          // "Login" or "Logout"
//    private int                userId;
//    private ArrayList<Integer> empTripIds;  // per-employee trip_id from pickupDrop
//    private ArrayList<Integer> empIds;
//    private ArrayList<String>  empNames;
//    private ArrayList<String>  empMobiles; // ✅ mobile_number per employee
//    private String             startAddressText, endAddressText, date, time;
//    private double             distance;
//    private int                persons;
//
//    // ── SDK state ──────────────────────────────────────────
//    private Navigator                  navigator;
//    private RidesharingVehicleReporter vehicleReporter;
//    private boolean isDriverSdkReady      = false;
//    private boolean isNavigatorReady      = false;
//    private boolean shouldStartNavigation = false;
//    private boolean termsAlreadyShown     = false;
//
//    // ── Navigation state ───────────────────────────────────
//    // allStops: full ordered list [startLocation, middleStops..., endLocation]
//    private ArrayList<String> allStops;
//    private int currentStopIndex = 0;
//
//    // ✅ Maps marker title → stop index so tapping a marker shows the right OTP
//    private java.util.HashMap<String, Integer> markerStopIndexMap = new java.util.HashMap<>();
//
//    // ======================================================
//    // LIFECYCLE
//    // ======================================================
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_map);
//
//        startLocation    = getIntent().getStringExtra("start_location");
//        endLocation      = getIntent().getStringExtra("end_location");
//        middleStops      = getIntent().getStringArrayListExtra("middle_stops");
//        startAddressText = getIntent().getStringExtra("start_address");
//        endAddressText   = getIntent().getStringExtra("end_address");
//        date             = getIntent().getStringExtra("date");
//        time             = getIntent().getStringExtra("time");
//        distance         = getIntent().getDoubleExtra("distance", 0);
//        persons          = getIntent().getIntExtra("persons", 0);
//        tripType         = getIntent().getStringExtra("trip_type");
//        stopLabels       = getIntent().getStringArrayListExtra("stop_labels");
//        userId           = getIntent().getIntExtra("user_id", 0);
//        empTripIds       = getIntent().getIntegerArrayListExtra("emp_trip_ids");
//        empIds           = getIntent().getIntegerArrayListExtra("emp_ids");
//        empNames         = getIntent().getStringArrayListExtra("emp_names");
//        empMobiles       = getIntent().getStringArrayListExtra("emp_mobiles");
//
//        if (stopLabels == null) stopLabels  = new ArrayList<>();
//        if (empTripIds == null) empTripIds  = new ArrayList<>();
//        if (empIds     == null) empIds      = new ArrayList<>();
//        if (empNames   == null) empNames    = new ArrayList<>();
//        if (empMobiles == null) empMobiles  = new ArrayList<>();
//
//        navigationView = findViewById(R.id.navigation_view);
//        navigationView.onCreate(savedInstanceState);
//
//        setupBottomSheet();
//
//        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
//                != PackageManager.PERMISSION_GRANTED) {
//            ActivityCompat.requestPermissions(this,
//                    new String[]{Manifest.permission.ACCESS_FINE_LOCATION,
//                            Manifest.permission.ACCESS_COARSE_LOCATION},
//                    LOCATION_PERMISSION);
//        } else {
//            initSdk();
//        }
//    }
//
//    @Override protected void onStart()   { super.onStart();   navigationView.onStart(); }
//    @Override protected void onResume()  { super.onResume();  navigationView.onResume(); }
//    @Override protected void onPause()   { super.onPause();   navigationView.onPause(); }
//    @Override protected void onStop()    { super.onStop();    navigationView.onStop(); }
//    @Override protected void onDestroy() { super.onDestroy(); navigationView.onDestroy(); }
//
//    @Override
//    public void onSaveInstanceState(@NonNull Bundle out) {
//        super.onSaveInstanceState(out);
//        navigationView.onSaveInstanceState(out);
//    }
//
//    @Override
//    public void onRequestPermissionsResult(int code, @NonNull String[] perms, @NonNull int[] results) {
//        super.onRequestPermissionsResult(code, perms, results);
//        if (code == LOCATION_PERMISSION) {
//            if (results.length > 0 && results[0] == PackageManager.PERMISSION_GRANTED) {
//                initSdk();
//            } else {
//                Toast.makeText(this, "Location permission required", Toast.LENGTH_LONG).show();
//                navigationView.getMapAsync(this);
//            }
//        }
//    }
//
//    // ======================================================
//    // SDK INIT
//    // ======================================================
//
//    private void initSdk() {
//        if (!isLocationEnabled()) {
//            Toast.makeText(this, "Please enable GPS", Toast.LENGTH_LONG).show();
//            startActivity(new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS));
//        }
//
//        NavigationApi.getNavigator(this, new NavigationApi.NavigatorListener() {
//
//            @Override
//            public void onNavigatorReady(@NonNull Navigator nav) {
//                Log.d(TAG, "✅ onNavigatorReady");
//                navigator        = nav;
//                isNavigatorReady = true;
//                termsAlreadyShown = false;
//
//                navigationView.getMapAsync(MapActivity.this);
//                new Handler(Looper.getMainLooper()).postDelayed(() -> setupDriverApi(nav), 800);
//
//                if (shouldStartNavigation) {
//                    // allStops was already built in onStartTripClicked before
//                    // shouldStartNavigation was set — safe to call directly
//                    if (allStops == null || allStops.isEmpty()) {
//                        allStops = buildAllStops();  // safety fallback
//                    }
//                    startNavigation();
//                }
//            }
//
//            @Override
//            public void onError(@NavigationApi.ErrorCode int errorCode) {
//                boolean isTerms = (errorCode == NavigationApi.ErrorCode.TERMS_NOT_ACCEPTED)
//                        || (errorCode == 4);
//                if (isTerms && !termsAlreadyShown) {
//                    termsAlreadyShown = true;
//                    NavigationApi.showTermsAndConditionsDialog(MapActivity.this,
//                            "Ayaka Transassist", "Accept navigation terms",
//                            accepted -> {
//                                if (accepted) NavigationApi.getNavigator(MapActivity.this, this);
//                                else navigationView.getMapAsync(MapActivity.this);
//                            });
//                } else {
//                    navigationView.getMapAsync(MapActivity.this);
//                }
//            }
//        });
//    }
//
//    @Override
//    public void onMapReady(@NonNull GoogleMap googleMap) {
//        Log.d(TAG, "✅ onMapReady");
//        mMap = googleMap;
//        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
//                == PackageManager.PERMISSION_GRANTED) {
//            mMap.setMyLocationEnabled(true);
//            mMap.getUiSettings().setMyLocationButtonEnabled(true);
//        }
//        drawRoutePreview();
//    }
//
//    // ======================================================
//    // DRIVER SDK
//    // ======================================================
//
//    private void setupDriverApi(Navigator nav) {
//        if (App.getDriverApi() != null) {
//            Log.d(TAG, "✅ Reusing existing DriverApi");
//            isDriverSdkReady = true;
//            return;
//        }
//        try {
//            RoadSnappedLocationProvider provider =
//                    NavigationApi.getRoadSnappedLocationProvider(getApplication());
//            if (provider == null) return;
//
//            SessionManager session = new SessionManager(getApplicationContext());
//            String token     = session.getAccessToken();
//            String vehicleId = session.getVehicleId();
//            if (vehicleId == null || vehicleId.isEmpty() || token == null || token.isEmpty()) return;
//
//            DriverContext ctx = DriverContext.builder(getApplication())
//                    .setProviderId(PROVIDER_ID)
//                    .setVehicleId(vehicleId)
//                    .setNavigator(nav)
//                    .setRoadSnappedLocationProvider(provider)
//                    .setAuthTokenFactory(new StaticAuthTokenFactory(token))
//                    .build();
//
//            App.setDriverApi(RidesharingDriverApi.createInstance(ctx));
//            isDriverSdkReady = true;
//            Log.d(TAG, "✅ Driver SDK initialized");
//        } catch (Exception e) {
//            Log.e(TAG, "Driver SDK error: " + e.getMessage(), e);
//        }
//    }
//
//    // ======================================================
//    // BOTTOM SHEET
//    // ======================================================
//
//    private void setupBottomSheet() {
//        View bottomSheet = findViewById(R.id.bottomSheet);
//        bottomSheetBehavior = BottomSheetBehavior.from(bottomSheet);
//        bottomSheetBehavior.setState(BottomSheetBehavior.STATE_EXPANDED);
//
//        ((TextView) findViewById(R.id.startAddress)).setText("Start: " + startAddressText);
//        ((TextView) findViewById(R.id.endAddress)).setText("End: " + endAddressText);
//        ((TextView) findViewById(R.id.tripDistance)).setText(
//                String.format(java.util.Locale.getDefault(), "%.2f km", distance));
//        ((TextView) findViewById(R.id.personCount)).setText(String.valueOf(persons));
//        ((TextView) findViewById(R.id.tripDate)).setText(date);
//        ((TextView) findViewById(R.id.tripTime)).setText(time);
//
//        Button startTrip = findViewById(R.id.startTrip);
//        startTrip.setOnClickListener(v -> {
//            bottomSheetBehavior.setState(BottomSheetBehavior.STATE_HIDDEN);
//            onStartTripClicked();
//        });
//    }
//
//    // ======================================================
//    // START TRIP
//    // ======================================================
//
//    private void onStartTripClicked() {
//        if (!isLocationEnabled()) {
//            Toast.makeText(this, "Please enable GPS", Toast.LENGTH_LONG).show();
//            return;
//        }
//
//        if (!isDriverSdkReady && App.getDriverApi() != null) isDriverSdkReady = true;
//
//        if (isDriverSdkReady && App.getDriverApi() != null) {
//            try {
//                vehicleReporter = App.getDriverApi().getRidesharingVehicleReporter();
//                vehicleReporter.enableLocationTracking();
//                vehicleReporter.setVehicleState(RidesharingVehicleReporter.VehicleState.ONLINE);
//                Log.d(TAG, "✅ Fleet Engine tracking ON");
//            } catch (Exception e) {
//                Log.e(TAG, "VehicleReporter: " + e.getMessage());
//            }
//        }
//
//        allStops = buildAllStops();   // ✅ REQUIRED
//        currentStopIndex = 0;
//
//        if (isNavigatorReady) {
//            navigateToStop(currentStopIndex);
//        } else {
//            shouldStartNavigation = true;
//        }
//    }
//
//    private void startNavigation() {
//        if (navigator == null || allStops == null || allStops.isEmpty()) return;
//        currentStopIndex = 0;
//        navigateToStop(currentStopIndex);
//    }
//
//    // ======================================================
//    // CORE NAVIGATION + OTP FLOW
//    //
//    // Stop sequence (allStops):
//    //   Login:  [emp0, emp1, ..., empN, office]
//    //   Logout: [office, emp0, emp1, ..., empN]
//    //
//    // OTP rules:
//    //   Login:  arrive at each employee → show OTP (ENROUTE_TO_DROPOFF)
//    //           arrive at office → trip complete (no OTP)
//    //   Logout: arrive at office → show boarding OTP for EACH employee
//    //                              (ENROUTE_TO_DROPOFF per emp_id)
//    //           arrive at each drop → show OTP (COMPLETE per emp_id)
//    // ======================================================
//
//    // Single reusable arrival listener — replaced each stop to prevent stacking
//    private Navigator.ArrivalListener currentArrivalListener = null;
//    private boolean arrivalHandled = false;   // prevent double-firing
//
//    private void navigateToStop(int index) {
//        if (navigator == null) return;
//        if (index >= allStops.size()) {
//            runOnUiThread(() -> Toast.makeText(this, "✅ Trip Complete!", Toast.LENGTH_LONG).show());
//            return;
//        }
//
//        String target = allStops.get(index);
//        LatLng dest   = parseLatLng(target);
//        if (dest == null) { Log.e(TAG, "Bad LatLng at stop " + index); return; }
//
//        String label = (stopLabels != null && index < stopLabels.size())
//                ? stopLabels.get(index) : "Stop " + (index + 1);
//
//        Log.d(TAG, "→ Navigating to stop " + index + ": " + label);
//        Toast.makeText(this, "Navigating to " + label, Toast.LENGTH_SHORT).show();
//
//        // ✅ Set destination
//        Waypoint wp = Waypoint.builder().setLatLng(dest.latitude, dest.longitude).build();
//        navigator.clearDestinations();
//        navigator.setDestination(wp);
//        navigator.startGuidance();
//
//        // ✅ Remove previous arrival listener before adding new one
//        //    This prevents listeners stacking up across multiple stops
//        if (currentArrivalListener != null) {
//            navigator.removeArrivalListener(currentArrivalListener);
//        }
//        arrivalHandled = false;
//
//        currentArrivalListener = event -> {
//            // ✅ Guard: ignore if already handled (listener can fire multiple times)
//            if (arrivalHandled) return;
//            arrivalHandled = true;
//
//            Log.d(TAG, "ArrivalListener fired for stop " + index);
//
//            // ✅ GPS proximity check (50m) before showing OTP
//            //    This confirms the driver is physically there,
//            //    not just that the Navigation SDK thinks they arrived
//            startArrivalCheck(dest, () ->
//                    runOnUiThread(() -> onArrivedAtStop(index)));
//        };
//
//        navigator.addArrivalListener(currentArrivalListener);
//    }
//
//    /**
//     * Called when driver physically arrives at a stop.
//     * Decides what OTP dialog(s) to show, then advances to next stop.
//     */
//    private void onArrivedAtStop(int index) {
//        String label = (stopLabels != null && index < stopLabels.size())
//                ? stopLabels.get(index) : "Stop " + (index + 1);
//        boolean isLastStop = (index == allStops.size() - 1);
//        boolean isLogin    = "Login".equalsIgnoreCase(tripType);
//
//        Log.d(TAG, "Arrived at stop " + index + " (" + label + ") isLast=" + isLastStop);
//
//        if (isLastStop) {
//            // ── Final stop ────────────────────────────────────────────
//            if (isLogin && "Office".equals(label)) {
//                // Login: reached office — mark trip COMPLETE in Fleet Engine
//                updateFleetEngineStatus(RidesharingVehicleReporter.VehicleState.ONLINE, "COMPLETE");
//                Toast.makeText(this, "✅ All employees at office! Trip complete.", Toast.LENGTH_LONG).show();
//            } else {
//                updateFleetEngineStatus(RidesharingVehicleReporter.VehicleState.ONLINE, "COMPLETE");
//                Toast.makeText(this, "✅ Trip Complete!", Toast.LENGTH_LONG).show();
//            }
//
//        } else if (!isLogin && "Office".equals(label)) {
//            // ── LOGOUT: arrived at office — show boarding OTP for each employee ──
//            // Driver must verify each employee's boarding OTP before leaving office
//            Toast.makeText(this, "Arrived at Office — verify employee boarding OTPs", Toast.LENGTH_SHORT).show();
//            showOfficeboardingOtpSequence(index, 0, () -> {
//                // All employees boarded — navigate to first drop
//                navigateToStop(index + 1);
//            });
//
//        } else {
//            // ── Normal stop (employee for login, or non-office) ───────
//            // OTP for employee stops is handled by marker tap
//            // Just show arrival toast and auto-advance
//            Toast.makeText(this, "Arrived at " + label, Toast.LENGTH_SHORT).show();
//            navigateToStop(index + 1);
//        }
//    }
//
//    /**
//     * For LOGOUT trips at office: show boarding OTP for each employee sequentially.
//     * empOffset tracks which employee in the allStops list we are verifying.
//     * Employees in allStops start at index officeIndex+1.
//     */
//    private void showOfficeboardingOtpSequence(int officeStopIndex, int empOffset, Runnable onAllBoarded) {
//        // Employees start after office (officeStopIndex + 1)
//        int empStopIndex = officeStopIndex + 1 + empOffset;
//
//        if (empStopIndex >= allStops.size()) {
//            Toast.makeText(this, "✅ All employees boarded!", Toast.LENGTH_SHORT).show();
//            onAllBoarded.run();  // caller handles Fleet Engine update
//            return;
//        }
//
//        String empLabel = (stopLabels != null && empStopIndex < stopLabels.size())
//                ? stopLabels.get(empStopIndex) : "Employee " + (empOffset + 1);
//
//        // Skip if this is not an employee stop
//        if ("Office".equals(empLabel)) {
//            onAllBoarded.run();
//            return;
//        }
//
//        int    empId     = getEmpIdForStop(empStopIndex);
//        String empName   = getEmpNameForStop(empStopIndex);
//        String empTripId = getTripIdForStop(empStopIndex);
//        String empMobile = getEmpMobileForStop(empStopIndex);
//
//        // ✅ Full debug — check all values before showing dialog
//        Log.d(TAG, "=== OFFICE BOARDING OTP ===");
//        Log.d(TAG, "officeStopIndex = " + officeStopIndex);
//        Log.d(TAG, "empOffset       = " + empOffset);
//        Log.d(TAG, "empStopIndex    = " + empStopIndex);
//        Log.d(TAG, "empName         = " + empName);
//        Log.d(TAG, "empId           = " + empId);
//        Log.d(TAG, "empTripId       = [" + empTripId + "]");
//        Log.d(TAG, "empMobile       = " + empMobile);
//        Log.d(TAG, "type            = " + OtpVerifyDialog.TYPE_PICKUP);
//        Log.d(TAG, "userId          = " + userId);
//        Log.d(TAG, "===========================");
//
//        if (empTripId.isEmpty()) {
//            Log.e(TAG, "❌ empTripId is EMPTY for empStopIndex=" + empStopIndex
//                    + " — check empTripIds list");
//            Log.e(TAG, "empTripIds = " + empTripIds);
//            Toast.makeText(this, "Trip ID missing for " + empName, Toast.LENGTH_LONG).show();
//            return;
//        }
//
//        // Show boarding OTP dialog — after verified, show next employee's dialog
//        showOtpDialogForStop(
//                empName,
//                empMobile,
//                empTripId,
//                empId,
//                OtpVerifyDialog.TYPE_PICKUP,
//                () -> showOfficeboardingOtpSequence(officeStopIndex, empOffset + 1, onAllBoarded)
//        );
//    }
//
//    /**
//     * Shows OtpVerifyDialog for one employee.
//     * empTripId = the trip_id from pickupDrop for this specific employee.
//     */
//    private void showOtpDialog(String empName, int empTripId, int empId,
//                               String type, Runnable onVerified) {
//        // Not used directly — use showOtpDialogForStop instead
//        showOtpDialogForStop(empName, "", String.valueOf(empTripId), empId, type, onVerified);
//    }
//
//    // ✅ Full method with mobile support
//    private void showOtpDialogForStop(String empName, String mobile, String tripIdStr,
//                                      int empId, String type, Runnable onVerified) {
//        Log.d(TAG, "OTP dialog: emp=" + empName + " mobile=" + mobile
//                + " tripId=" + tripIdStr + " empId=" + empId + " type=" + type);
//        OtpVerifyDialog.show(
//                getSupportFragmentManager(),
//                empName,
//                mobile,
//                userId,
//                tripIdStr,
//                empId,
//                type,
//                onVerified::run
//        );
//    }
//
//    // ── Stop data helpers ──────────────────────────────────
//
//    private int getEmpTripIdForStop(int stopIndex) {
//        if (empTripIds != null && stopIndex < empTripIds.size()) return empTripIds.get(stopIndex);
//        return -1;
//    }
//
//    // ✅ Returns trip_id as String for OTP API (uses empTripIds list)
//    private String getTripIdForStop(int stopIndex) {
//        if (empTripIds != null && stopIndex < empTripIds.size()) {
//            int id = empTripIds.get(stopIndex);
//            return id == -1 ? "" : String.valueOf(id);
//        }
//        return "";
//    }
//
//    // ✅ Returns mobile number for stop
//    private String getEmpMobileForStop(int stopIndex) {
//        if (empMobiles != null && stopIndex < empMobiles.size()) {
//            String m = empMobiles.get(stopIndex);
//            return m != null ? m : "";
//        }
//        return "";
//    }
//
//    private int getEmpIdForStop(int stopIndex) {
//        if (empIds != null && stopIndex < empIds.size()) return empIds.get(stopIndex);
//        return -1;
//    }
//
//    private String getEmpNameForStop(int stopIndex) {
//        if (empNames != null && stopIndex < empNames.size()) return empNames.get(stopIndex);
//        return "Employee";
//    }
//
//    private ArrayList<String> buildAllStops() {
//        ArrayList<String> stops = new ArrayList<>();
//        if (startLocation != null && !startLocation.isEmpty()) stops.add(startLocation);
//        if (middleStops   != null) stops.addAll(middleStops);
//        if (endLocation   != null && !endLocation.isEmpty())   stops.add(endLocation);
//        Log.d(TAG, "allStops (" + stops.size() + "): " + stops);
//        return stops;
//    }
//
//    // ======================================================
//    // ROUTE PREVIEW (shown before trip starts)
//    // ======================================================
//
//    private void drawRoutePreview() {
//        LatLng origin = parseLatLng(startLocation);
//        LatLng dest   = parseLatLng(endLocation);
//        if (origin == null || dest == null) return;
//        fetchRoute(origin, dest);
//    }
//
//    private void fetchRoute(LatLng origin, LatLng destination) {
//        new Thread(() -> {
//            try {
//                StringBuilder url = new StringBuilder(
//                        "https://maps.googleapis.com/maps/api/directions/json?");
//                url.append("origin=").append(origin.latitude).append(",").append(origin.longitude);
//                url.append("&destination=").append(destination.latitude).append(",").append(destination.longitude);
//                if (middleStops != null && !middleStops.isEmpty()) {
//                    url.append("&waypoints=");
//                    for (int i = 0; i < middleStops.size(); i++) {
//                        url.append(middleStops.get(i));
//                        if (i < middleStops.size() - 1) url.append("|");
//                    }
//                }
//                url.append("&mode=driving&key=").append(GOOGLE_API_KEY);
//
//                HttpURLConnection conn = (HttpURLConnection) new URL(url.toString()).openConnection();
//                conn.connect();
//
//                BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
//                StringBuilder json = new StringBuilder();
//                String line;
//                while ((line = reader.readLine()) != null) json.append(line);
//
//                JSONObject obj = new JSONObject(json.toString());
//                JSONArray routes = obj.getJSONArray("routes");
//                if (routes.length() == 0) return;
//
//                JSONObject route  = routes.getJSONObject(0);
//                String polyline   = route.getJSONObject("overview_polyline").getString("points");
//                ArrayList<LatLng> path = decodePolyline(polyline);
//                JSONArray legs    = route.getJSONArray("legs");
//
//                runOnUiThread(() -> {
//                    if (mMap != null) {
//                        drawPolyline(path);
//                        drawMarkers(legs);
//                    }
//                });
//            } catch (Exception e) {
//                Log.e(TAG, "fetchRoute: " + e.getMessage(), e);
//            }
//        }).start();
//    }
//
//    private void drawPolyline(ArrayList<LatLng> path) {
//        mMap.addPolyline(new PolylineOptions()
//                .addAll(path).width(10f).color(0xFF1976D2).geodesic(true));
//        LatLngBounds.Builder b = new LatLngBounds.Builder();
//        for (LatLng p : path) b.include(p);
//        mMap.animateCamera(CameraUpdateFactory.newLatLngBounds(b.build(), 150));
//    }
//
//    private void drawMarkers(JSONArray legs) {
//        try {
//            ArrayList<LatLng> points = new ArrayList<>();
//            for (int i = 0; i < legs.length(); i++) {
//                JSONObject leg = legs.getJSONObject(i);
//                if (i == 0) {
//                    JSONObject s = leg.getJSONObject("start_location");
//                    points.add(new LatLng(s.getDouble("lat"), s.getDouble("lng")));
//                }
//                JSONObject e = leg.getJSONObject("end_location");
//                points.add(new LatLng(e.getDouble("lat"), e.getDouble("lng")));
//            }
//
//            markerStopIndexMap.clear();
//
//            for (int i = 0; i < points.size(); i++) {
//                String label = (stopLabels != null && i < stopLabels.size())
//                        ? stopLabels.get(i)
//                        : (i == 0 ? "Start" : i == points.size()-1 ? "End" : "Stop " + i);
//
//                float color = (i == 0) ? BitmapDescriptorFactory.HUE_GREEN
//                        : (i == points.size()-1) ? BitmapDescriptorFactory.HUE_RED
//                        : BitmapDescriptorFactory.HUE_ORANGE;
//
//                // ✅ snippet = "Tap to verify OTP" for employee stops
//                boolean isOffice = "Office".equals(label);
//                String snippet = isOffice
//                        ? (i == 0 ? "First stop — Office" : "Final destination — Office")
//                        : "Tap to verify OTP";
//
//                com.google.android.gms.maps.model.Marker marker = mMap.addMarker(
//                        new MarkerOptions()
//                                .position(points.get(i))
//                                .title(label)
//                                .snippet(snippet)
//                                .icon(BitmapDescriptorFactory.defaultMarker(color)));
//
//                // ✅ Store stop index keyed by marker title (unique per stop)
//                if (marker != null) {
//                    markerStopIndexMap.put(marker.getId(), i);
//                }
//            }
//
//            // ✅ Set marker click listener — show OTP dialog on tap
//            mMap.setOnMarkerClickListener(marker -> {
//                marker.showInfoWindow();
//
//                Integer stopIndex = markerStopIndexMap.get(marker.getId());
//                if (stopIndex == null) return false;
//
//                String label = marker.getTitle();
//                if (label == null) return false;
//
//                // Trip must be started before OTP dialogs are shown
//                if (allStops == null) {
//                    Toast.makeText(this, "Start the trip first", Toast.LENGTH_SHORT).show();
//                    return false;
//                }
//
//                boolean isLoginTrip = "Login".equalsIgnoreCase(tripType);
//                String  tripIdStr   = getTripIdForStop(stopIndex);
//                String  mobile      = getEmpMobileForStop(stopIndex);
//                int     empId       = getEmpIdForStop(stopIndex);
//                String  name        = getEmpNameForStop(stopIndex);
//
//                Log.d(TAG, "Marker tapped: " + label + " stopIndex=" + stopIndex
//                        + " empId=" + empId + " tripId=" + tripIdStr);
//
//                // ── OFFICE MARKER (Logout only) ────────────────────────
//                if ("Office".equals(label)) {
//                    if (isLoginTrip) {
//                        Toast.makeText(this, "Office is the final destination", Toast.LENGTH_SHORT).show();
//                        return false;
//                    }
//                    // Logout: tap office → board all employees one by one
//                    showOfficeboardingOtpSequence(stopIndex, 0, () -> {
//                        // All boarded → Fleet Engine: ENROUTE_TO_DROPOFF
//                        updateFleetEngineStatus(
//                                RidesharingVehicleReporter.VehicleState.ONLINE,
//                                "ENROUTE_TO_DROPOFF");
//                        navigateToStop(stopIndex + 1);
//                    });
//                    return true;
//                }
//
//                // ── EMPLOYEE MARKER ────────────────────────────────────
//                if (isLoginTrip) {
//                    // Login: employee tap → boarding OTP → ENROUTE_TO_DROPOFF
//                    showOtpDialogForStop(name, mobile, tripIdStr, empId,
//                            OtpVerifyDialog.TYPE_PICKUP, () -> {
//                                updateFleetEngineStatus(
//                                        RidesharingVehicleReporter.VehicleState.ONLINE,
//                                        "ENROUTE_TO_DROPOFF");
//                                navigateToStop(stopIndex + 1);
//                            });
//                } else {
//                    // Logout: employee tap → drop-off OTP → COMPLETE
//                    showOtpDialogForStop(name, mobile, tripIdStr, empId,
//                            OtpVerifyDialog.TYPE_DROPOFF, () -> {
//                                updateFleetEngineStatus(
//                                        RidesharingVehicleReporter.VehicleState.ONLINE,
//                                        "COMPLETE");
//                                boolean isLast = (stopIndex == allStops.size() - 1);
//                                if (isLast) {
//                                    Toast.makeText(this, "✅ Trip Complete!", Toast.LENGTH_LONG).show();
//                                } else {
//                                    navigateToStop(stopIndex + 1);
//                                }
//                            });
//                }
//
//                return true;
//            });
//
//        } catch (Exception e) {
//            Log.e(TAG, "drawMarkers: " + e.getMessage());
//        }
//    }
//
//    // ======================================================
//    // FLEET ENGINE STATUS UPDATE
//    // ======================================================
//
//    /**
//     * Updates Fleet Engine vehicle state and logs the trip status transition.
//     *
//     * statusLabel is just for logging — Fleet Engine state is controlled via
//     * vehicleReporter. The actual per-trip status (ENROUTE_TO_DROPOFF / COMPLETE)
//     * is sent to your backend via the OTP API (/updateTrip_status) which then
//     * updates Fleet Engine server-side.
//     *
//     * On the driver SDK side, we toggle the vehicle state to signal activity:
//     *   ENROUTE_TO_DROPOFF → vehicle is ONLINE and actively on a trip
//     *   COMPLETE           → vehicle is ONLINE, trip leg done, ready for next
//     */
//    private void updateFleetEngineStatus(
//            RidesharingVehicleReporter.VehicleState state,
//            String statusLabel) {
//
//        if (vehicleReporter == null) {
//            Log.w(TAG, "updateFleetEngineStatus: vehicleReporter is null, skipping");
//            return;
//        }
//
//        try {
//            vehicleReporter.setVehicleState(state);
//            Log.d(TAG, "✅ Fleet Engine status → " + statusLabel
//                    + " (VehicleState=" + state + ")");
//        } catch (Exception e) {
//            Log.e(TAG, "Fleet Engine status update failed: " + e.getMessage());
//        }
//    }
//
//    // ======================================================
//    // ARRIVAL CHECK — confirm GPS proximity before triggering OTP
//    // ======================================================
//
//    private void startArrivalCheck(LatLng destination, Runnable onReached) {
//        com.google.android.gms.location.FusedLocationProviderClient client =
//                com.google.android.gms.location.LocationServices
//                        .getFusedLocationProviderClient(this);
//
//        Handler handler = new Handler(Looper.getMainLooper());
//
//        Runnable checker = new Runnable() {
//            @Override
//            public void run() {
//                if (ActivityCompat.checkSelfPermission(MapActivity.this,
//                        Manifest.permission.ACCESS_FINE_LOCATION)
//                        != PackageManager.PERMISSION_GRANTED) return;
//
//                client.getLastLocation().addOnSuccessListener(location -> {
//                    if (location == null) { handler.postDelayed(this, 2000); return; }
//
//                    float[] result = new float[1];
//                    android.location.Location.distanceBetween(
//                            location.getLatitude(), location.getLongitude(),
//                            destination.latitude, destination.longitude, result);
//
//                    Log.d(TAG, "Arrival check: " + result[0] + "m from destination");
//
//                    if (result[0] < 50) {
//                        onReached.run();
//                    } else {
//                        handler.postDelayed(this, 2000);
//                    }
//                });
//            }
//        };
//
//        handler.post(checker);
//    }
//
//    // ======================================================
//    // HELPERS
//    // ======================================================
//
//    private boolean isLocationEnabled() {
//        LocationManager lm = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
//        return lm != null && (lm.isProviderEnabled(LocationManager.GPS_PROVIDER)
//                || lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER));
//    }
//
//    private LatLng parseLatLng(String s) {
//        try {
//            String[] p = s.split(",");
//            return new LatLng(Double.parseDouble(p[0].trim()), Double.parseDouble(p[1].trim()));
//        } catch (Exception e) {
//            Log.e(TAG, "parseLatLng failed: " + s);
//            return null;
//        }
//    }
//
//    private ArrayList<LatLng> decodePolyline(String encoded) {
//        ArrayList<LatLng> poly = new ArrayList<>();
//        int index = 0, lat = 0, lng = 0;
//        while (index < encoded.length()) {
//            int b, shift = 0, result = 0;
//            do { b = encoded.charAt(index++) - 63; result |= (b & 0x1f) << shift; shift += 5; } while (b >= 0x20);
//            lat += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//            shift = 0; result = 0;
//            do { b = encoded.charAt(index++) - 63; result |= (b & 0x1f) << shift; shift += 5; } while (b >= 0x20);
//            lng += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//            poly.add(new LatLng(lat / 1E5, lng / 1E5));
//        }
//        return poly;
//    }
//
//    private void startLoggingLocation() {
//        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
//                != PackageManager.PERMISSION_GRANTED) return;
//
//        com.google.android.gms.location.FusedLocationProviderClient client =
//                com.google.android.gms.location.LocationServices.getFusedLocationProviderClient(this);
//
//        com.google.android.gms.location.LocationRequest req =
//                com.google.android.gms.location.LocationRequest.create()
//                        .setInterval(2000).setFastestInterval(1000)
//                        .setPriority(com.google.android.gms.location.LocationRequest.PRIORITY_HIGH_ACCURACY);
//
//        client.requestLocationUpdates(req,
//                new com.google.android.gms.location.LocationCallback() {
//                    @Override
//                    public void onLocationResult(@NonNull com.google.android.gms.location.LocationResult result) {
//                        for (android.location.Location loc : result.getLocations()) {
//                            Log.d("LOCATION_DEBUG", "Lat=" + loc.getLatitude() + " Lng=" + loc.getLongitude());
//                        }
//                    }
//                }, Looper.getMainLooper());
//    }
//
//
//}


// location is uploading to fleet but waypoints and navigations are in manual here
package com.example.ayaka;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.provider.Settings;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.PolylineOptions;

import com.google.android.libraries.navigation.NavigationApi;
import com.google.android.libraries.navigation.NavigationView;
import com.google.android.libraries.navigation.Navigator;
import com.google.android.libraries.navigation.RoadSnappedLocationProvider;
import com.google.android.libraries.navigation.Waypoint;
import com.google.android.libraries.mapsplatform.transportation.driver.api.base.data.DriverContext;
import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.RidesharingDriverApi;
import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.vehiclereporter.RidesharingVehicleReporter;

import com.google.android.material.bottomsheet.BottomSheetBehavior;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class MapActivity extends AppCompatActivity implements OnMapReadyCallback {

    private static final String TAG                   = "MapActivity";
    private static final int    LOCATION_PERMISSION   = 100;
    private static final String PROVIDER_ID           = "ayaka-transassist-mobility";
    private static final String GOOGLE_API_KEY        = "AIzaSyBNPLbzyyZzA3T1d5hSWkPE3tBW89MhKVw";

    // ── Views ──────────────────────────────────────────────
    private NavigationView            navigationView;
    private GoogleMap                 mMap;
    private BottomSheetBehavior<View> bottomSheetBehavior;

    // ── Trip data ──────────────────────────────────────────
    private String             startLocation, endLocation;
    private ArrayList<String>  middleStops;
    private ArrayList<String>  stopLabels;
    private String             tripType;          // "Login" or "Logout"
    private int                userId;
    private ArrayList<Integer> empTripIds;  // per-employee trip_id from pickupDrop
    private ArrayList<Integer> empIds;
    private ArrayList<String>  empNames;
    private ArrayList<String>  empMobiles; // ✅ mobile_number per employee
    private String             startAddressText, endAddressText, date, time;
    private double             distance;
    private int                persons;

    // ── SDK state ──────────────────────────────────────────
    private Navigator                  navigator;
    private RidesharingVehicleReporter vehicleReporter;
    private boolean isDriverSdkReady      = false;
    private boolean isNavigatorReady      = false;
    private boolean shouldStartNavigation = false;
    private boolean termsAlreadyShown     = false;

    // ── Navigation state ───────────────────────────────────
    // allStops: full ordered list [startLocation, middleStops..., endLocation]
    private ArrayList<String> allStops;
    private int currentStopIndex = 0;

    // ✅ Maps marker title → stop index so tapping a marker shows the right OTP
    private java.util.HashMap<String, Integer> markerStopIndexMap = new java.util.HashMap<>();

    // ======================================================
    // LIFECYCLE
    // ======================================================

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_map);

        startLocation    = getIntent().getStringExtra("start_location");
        endLocation      = getIntent().getStringExtra("end_location");
        middleStops      = getIntent().getStringArrayListExtra("middle_stops");
        startAddressText = getIntent().getStringExtra("start_address");
        endAddressText   = getIntent().getStringExtra("end_address");
        date             = getIntent().getStringExtra("date");
        time             = getIntent().getStringExtra("time");
        distance         = getIntent().getDoubleExtra("distance", 0);
        persons          = getIntent().getIntExtra("persons", 0);
        tripType         = getIntent().getStringExtra("trip_type");
        stopLabels       = getIntent().getStringArrayListExtra("stop_labels");
        userId           = getIntent().getIntExtra("user_id", 0);
        empTripIds       = getIntent().getIntegerArrayListExtra("emp_trip_ids");
        empIds           = getIntent().getIntegerArrayListExtra("emp_ids");
        empNames         = getIntent().getStringArrayListExtra("emp_names");
        empMobiles       = getIntent().getStringArrayListExtra("emp_mobiles");

        if (stopLabels == null) stopLabels  = new ArrayList<>();
        if (empTripIds == null) empTripIds  = new ArrayList<>();
        if (empIds     == null) empIds      = new ArrayList<>();
        if (empNames   == null) empNames    = new ArrayList<>();
        if (empMobiles == null) empMobiles  = new ArrayList<>();

        navigationView = findViewById(R.id.navigation_view);
        navigationView.onCreate(savedInstanceState);

        setupBottomSheet();

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.ACCESS_FINE_LOCATION,
                            Manifest.permission.ACCESS_COARSE_LOCATION},
                    LOCATION_PERMISSION);
        } else {
            initSdk();
        }
    }

    @Override protected void onStart()   { super.onStart();   navigationView.onStart(); }
    @Override protected void onResume()  { super.onResume();  navigationView.onResume(); }
    @Override protected void onPause()   { super.onPause();   navigationView.onPause(); }
    @Override protected void onStop()    { super.onStop();    navigationView.onStop(); }
    @Override
    protected void onDestroy() {
        super.onDestroy();
        navigationView.onDestroy();
        // ✅ Stop location tracking when activity closes
        // to avoid sending stale location to Fleet Engine
        if (vehicleReporter != null) {
            try {
                vehicleReporter.disableLocationTracking();
                Log.d(TAG, "Location tracking stopped on destroy");
            } catch (Exception e) {
                Log.w(TAG, "Error stopping location tracking: " + e.getMessage());
            }
        }
    }

    @Override
    public void onSaveInstanceState(@NonNull Bundle out) {
        super.onSaveInstanceState(out);
        navigationView.onSaveInstanceState(out);
    }

    @Override
    public void onRequestPermissionsResult(int code, @NonNull String[] perms, @NonNull int[] results) {
        super.onRequestPermissionsResult(code, perms, results);
        if (code == LOCATION_PERMISSION) {
            if (results.length > 0 && results[0] == PackageManager.PERMISSION_GRANTED) {
                initSdk();
            } else {
                Toast.makeText(this, "Location permission required", Toast.LENGTH_LONG).show();
                navigationView.getMapAsync(this);
            }
        }
    }

    // ======================================================
    // SDK INIT
    // ======================================================

    private void initSdk() {
        if (!isLocationEnabled()) {
            Toast.makeText(this, "Please enable GPS", Toast.LENGTH_LONG).show();
            startActivity(new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS));
        }

        NavigationApi.getNavigator(this, new NavigationApi.NavigatorListener() {

            @Override
            public void onNavigatorReady(@NonNull Navigator nav) {
                Log.d(TAG, "✅ onNavigatorReady");
                navigator        = nav;
                isNavigatorReady = true;
                termsAlreadyShown = false;

                navigationView.getMapAsync(MapActivity.this);
                new Handler(Looper.getMainLooper()).postDelayed(() -> setupDriverApi(nav), 800);

                if (shouldStartNavigation) {
                    // allStops was already built in onStartTripClicked before
                    // shouldStartNavigation was set — safe to call directly
                    if (allStops == null || allStops.isEmpty()) {
                        allStops = buildAllStops();  // safety fallback
                    }
                    startNavigation();
                }
            }

            @Override
            public void onError(@NavigationApi.ErrorCode int errorCode) {
                boolean isTerms = (errorCode == NavigationApi.ErrorCode.TERMS_NOT_ACCEPTED)
                        || (errorCode == 4);
                if (isTerms && !termsAlreadyShown) {
                    termsAlreadyShown = true;
                    NavigationApi.showTermsAndConditionsDialog(MapActivity.this,
                            "Ayaka Transassist", "Accept navigation terms",
                            accepted -> {
                                if (accepted) NavigationApi.getNavigator(MapActivity.this, this);
                                else navigationView.getMapAsync(MapActivity.this);
                            });
                } else {
                    navigationView.getMapAsync(MapActivity.this);
                }
            }
        });
    }

    @Override
    public void onMapReady(@NonNull GoogleMap googleMap) {
        Log.d(TAG, "✅ onMapReady");
        mMap = googleMap;
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                == PackageManager.PERMISSION_GRANTED) {
            mMap.setMyLocationEnabled(true);
            mMap.getUiSettings().setMyLocationButtonEnabled(true);
        }
        drawRoutePreview();
    }

    // ======================================================
    // DRIVER SDK
    // ======================================================

    private void setupDriverApi(Navigator nav) {
        if (App.getDriverApi() != null) {
            Log.d(TAG, "✅ Reusing existing DriverApi");
            isDriverSdkReady = true;
            return;
        }
        try {
            RoadSnappedLocationProvider provider =
                    NavigationApi.getRoadSnappedLocationProvider(getApplication());
            if (provider == null) return;

            SessionManager session = new SessionManager(getApplicationContext());
            String token     = session.getAccessToken();
            String vehicleId = session.getVehicleId();
            if (vehicleId == null || vehicleId.isEmpty() || token == null || token.isEmpty()) return;

            DriverContext ctx = DriverContext.builder(getApplication())
                    .setProviderId(PROVIDER_ID)
                    .setVehicleId(vehicleId)
                    .setNavigator(nav)
                    .setRoadSnappedLocationProvider(provider)
                    .setAuthTokenFactory(new StaticAuthTokenFactory(token))
                    .build();

            App.setDriverApi(RidesharingDriverApi.createInstance(ctx));
            isDriverSdkReady = true;
            Log.d(TAG, "✅ Driver SDK initialized");
        } catch (Exception e) {
            Log.e(TAG, "Driver SDK error: " + e.getMessage(), e);
        }
    }

    // ======================================================
    // BOTTOM SHEET
    // ======================================================

    private void setupBottomSheet() {
        View bottomSheet = findViewById(R.id.bottomSheet);
        bottomSheetBehavior = BottomSheetBehavior.from(bottomSheet);
        bottomSheetBehavior.setState(BottomSheetBehavior.STATE_EXPANDED);

        ((TextView) findViewById(R.id.startAddress)).setText("Start: " + startAddressText);
        ((TextView) findViewById(R.id.endAddress)).setText("End: " + endAddressText);
        ((TextView) findViewById(R.id.tripDistance)).setText(
                String.format(java.util.Locale.getDefault(), "%.2f km", distance));
        ((TextView) findViewById(R.id.personCount)).setText(String.valueOf(persons));
        ((TextView) findViewById(R.id.tripDate)).setText(date);
        ((TextView) findViewById(R.id.tripTime)).setText(time);

        Button startTrip = findViewById(R.id.startTrip);
        startTrip.setOnClickListener(v -> {
            bottomSheetBehavior.setState(BottomSheetBehavior.STATE_HIDDEN);
            onStartTripClicked();
        });
    }

    // ======================================================
    // START TRIP
    // ======================================================

    private void onStartTripClicked() {
        if (!isLocationEnabled()) {
            Toast.makeText(this, "Please enable GPS", Toast.LENGTH_LONG).show();
            return;
        }

        if (!isDriverSdkReady && App.getDriverApi() != null) isDriverSdkReady = true;

        if (isDriverSdkReady && App.getDriverApi() != null) {
            try {
                vehicleReporter = App.getDriverApi().getRidesharingVehicleReporter();

                // ✅ Set location reporting interval (milliseconds)
                // This controls how often the driver's location is sent to Fleet Engine
                vehicleReporter.setLocationReportingInterval(
                        5, java.util.concurrent.TimeUnit.SECONDS);

                // ✅ enableLocationTracking() starts the RoadSnappedLocationProvider
                // This is what sends GPS updates to Fleet Engine automatically
                vehicleReporter.enableLocationTracking();

                // ✅ Mark vehicle ONLINE — Fleet Engine now accepts location updates
                vehicleReporter.setVehicleState(RidesharingVehicleReporter.VehicleState.ONLINE);


                Log.d(TAG, "✅ Fleet Engine location tracking ON — reporting every 5s");
            } catch (Exception e) {
                Log.e(TAG, "VehicleReporter error: " + e.getMessage(), e);
            }
        } else {
            Log.w(TAG, "Driver SDK not ready — location NOT reporting to Fleet Engine");
        }

        startLoggingLocation();   // ✅ start FusedLocation logging
        allStops = buildAllStops();
        currentStopIndex = 0;

        if (isNavigatorReady) {
            startNavigation();
        } else {
            shouldStartNavigation = true;
            Toast.makeText(this, "Initializing navigation...", Toast.LENGTH_SHORT).show();
        }


    }

    private void startNavigation() {
        if (navigator == null) return;

        // ✅ Get remaining waypoints directly from Fleet Engine vehicle object
        // These are set by the backend when the trip is created in Fleet Engine.
        // The Driver SDK keeps them in sync — no manual setDestination() needed.
//        navigateToNextFleetEngineWaypoint();

        fetchLatestTripAndNavigate();

        // Set up arrival listener — fires when Navigator reaches each waypoint
        setupFleetEngineArrivalListener();
    }

    /**
     * Navigates to the next stop using the Navigator's own waypoint queue.
     *
     * How Fleet Engine waypoints work with the Driver SDK:
     * - Backend sets trip waypoints in Fleet Engine
     * - The Driver SDK (via RidesharingVehicleReporter) syncs these to the Navigator
     * - Navigator.getRouteSegments() gives current route to next waypoint
     * - We do NOT need to manually call setDestination() after SDK sync
     *
     * However, since getRemainingWaypoints() API varies by SDK version,
     * we use a reliable hybrid approach:
     * 1. Try Navigator's current route (Fleet Engine driven)
     * 2. Fall back to local stop list if Navigator has no route
     *
     * Location updates to Fleet Engine happen automatically via
     * RoadSnappedLocationProvider set in DriverContext — no manual calls needed.
     */
    private void navigateToNextFleetEngineWaypoint() {
        if (navigator == null) {
            Log.w(TAG, "Navigator null");
            return;
        }

        // Check if Navigator already has an active route from Fleet Engine
        java.util.List<com.google.android.libraries.navigation.RouteSegment> segments =
                navigator.getRouteSegments();

        if (segments != null && !segments.isEmpty()) {
            // ✅ Navigator has a Fleet Engine route — just start guidance
            // The SDK automatically set the destination from Fleet Engine waypoints
            Log.d(TAG, "✅ Navigator has " + segments.size()
                    + " route segments from Fleet Engine — starting guidance");

            navigator.startGuidance();

            // Match current destination to local stop for OTP data
            com.google.android.libraries.navigation.RouteSegment first = segments.get(0);
            if (first.getDestinationWaypoint() != null) {
                com.google.android.gms.maps.model.LatLng dest =
                        first.getDestinationWaypoint().getPosition();
                currentStopIndex = findMatchingLocalStop(
                        dest.latitude, dest.longitude);
                Log.d(TAG, "Fleet Engine next waypoint matched to local stop "
                        + currentStopIndex + " ("
                        + (stopLabels != null && currentStopIndex < stopLabels.size()
                        ? stopLabels.get(currentStopIndex) : "?") + ")");

                String label = (stopLabels != null
                        && currentStopIndex >= 0
                        && currentStopIndex < stopLabels.size())
                        ? stopLabels.get(currentStopIndex) : "Next stop";
                Toast.makeText(this, "Navigating to " + label, Toast.LENGTH_SHORT).show();
            }

        } else {
            // Navigator has no route yet (Fleet Engine hasn't synced waypoints)
            // Fall back to local stop list
            Log.w(TAG, "Navigator has no route — using local stop list as fallback");
            navigateToStop(currentStopIndex < allStops.size()
                    ? currentStopIndex : 0);
        }

        // Reset arrival listener for next stop
        setupFleetEngineArrivalListener();
    }

    /**
     * Finds which index in our local allStops list is closest to the given lat/lng.
     * Used to link Fleet Engine waypoints to our OTP/employee data.
     */
    private int findMatchingLocalStop(double lat, double lng) {
        if (allStops == null || allStops.isEmpty()) return 0;

        int   bestIndex = 0;
        float bestDist  = Float.MAX_VALUE;

        for (int i = 0; i < allStops.size(); i++) {
            LatLng local = parseLatLng(allStops.get(i));
            if (local == null) continue;

            float[] result = new float[1];
            android.location.Location.distanceBetween(
                    lat, lng, local.latitude, local.longitude, result);

            if (result[0] < bestDist) {
                bestDist  = result[0];
                bestIndex = i;
            }
        }

        Log.d(TAG, "findMatchingLocalStop: index=" + bestIndex
                + " dist=" + bestDist + "m");
        return bestIndex;
    }

    // ======================================================
    // CORE NAVIGATION + OTP FLOW
    //
    // Stop sequence (allStops):
    //   Login:  [emp0, emp1, ..., empN, office]
    //   Logout: [office, emp0, emp1, ..., empN]
    //
    // OTP rules:
    //   Login:  arrive at each employee → show OTP (ENROUTE_TO_DROPOFF)
    //           arrive at office → trip complete (no OTP)
    //   Logout: arrive at office → show boarding OTP for EACH employee
    //                              (ENROUTE_TO_DROPOFF per emp_id)
    //           arrive at each drop → show OTP (COMPLETE per emp_id)
    // ======================================================

    // ── Fleet Engine driven navigation ────────────────────
    // Instead of manually setting destinations, we let Fleet Engine
    // control waypoints via RidesharingVehicleReporter.
    // The Navigator receives waypoints automatically from Fleet Engine.
    // We only listen for arrivals to trigger OTP dialogs.

    private Navigator.ArrivalListener currentArrivalListener = null;
    private boolean arrivalHandled = false;

    /**
     * Sets up a single arrival listener.
     * When the Navigator (guided by Fleet Engine waypoints) fires arrival,
     * we detect which stop was reached and show the OTP dialog.
     * After OTP is verified, we call navigateToNextFleetEngineWaypoint()
     * which reads the UPDATED remaining waypoints from Fleet Engine
     * (the completed waypoint has been removed by the OTP API call).
     */
    private void setupFleetEngineArrivalListener() {
        if (navigator == null) return;

        if (currentArrivalListener != null) {
            navigator.removeArrivalListener(currentArrivalListener);
        }
        arrivalHandled = false;

        currentArrivalListener = event -> {
            if (arrivalHandled) return;
            arrivalHandled = true;
            Log.d(TAG, "✅ Arrival event — detecting stop from GPS");
            detectCurrentStopAndHandle();
        };

        navigator.addArrivalListener(currentArrivalListener);
        Log.d(TAG, "✅ Fleet Engine arrival listener registered");
    }

    /**
     * Called on arrival — detects which stop the driver reached by
     * comparing current GPS to all stops, finds the closest one,
     * then triggers the appropriate OTP dialog.
     */
    private void detectCurrentStopAndHandle() {
        if (ActivityCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) return;

        com.google.android.gms.location.LocationServices
                .getFusedLocationProviderClient(this)
                .getLastLocation()
                .addOnSuccessListener(location -> {
                    if (location == null) {
                        Log.w(TAG, "Location null during arrival detection");
                        return;
                    }

                    // Find which stop in allStops is closest to current position
                    int closestIndex = -1;
                    float closestDist = Float.MAX_VALUE;

                    for (int i = 0; i < allStops.size(); i++) {
                        LatLng stopLatLng = parseLatLng(allStops.get(i));
                        if (stopLatLng == null) continue;

                        float[] result = new float[1];
                        android.location.Location.distanceBetween(
                                location.getLatitude(), location.getLongitude(),
                                stopLatLng.latitude, stopLatLng.longitude,
                                result);

                        Log.d(TAG, "Stop " + i + " (" + stopLabels.get(i) + "): "
                                + result[0] + "m away");

                        if (result[0] < closestDist) {
                            closestDist = result[0];
                            closestIndex = i;
                        }
                    }

                    if (closestIndex == -1) {
                        Log.e(TAG, "Could not match arrival to any stop");
                        return;
                    }

                    final int arrivedAt = closestIndex;
                    Log.d(TAG, "✅ Matched arrival to stop " + arrivedAt
                            + " (" + stopLabels.get(arrivedAt) + ")"
                            + " distance=" + closestDist + "m");

                    // Update currentStopIndex
                    currentStopIndex = arrivedAt;

                    runOnUiThread(() -> {
                        // onArrivedAtStop handles OTP dialog.
                        // After OTP verified, onArrivedAtStop calls
                        // navigateToNextFleetEngineWaypoint() which reads
                        // the updated remaining waypoints from Fleet Engine.
                        onArrivedAtStop(arrivedAt);

                        // Reset arrival guard for next stop
                        arrivalHandled = false;
                        setupFleetEngineArrivalListener();
                    });
                });
    }

    /**
     * Manually navigate to a specific stop index.
     * Used after OTP verification to explicitly set next waypoint
     * in case Fleet Engine hasn't advanced yet.
     */
    private void navigateToStop(int index) {
        if (navigator == null) return;
        if (index >= allStops.size()) {
            runOnUiThread(() ->
                    Toast.makeText(this, "✅ Trip Complete!", Toast.LENGTH_LONG).show());
            return;
        }

        String target = allStops.get(index);
        LatLng dest   = parseLatLng(target);
        if (dest == null) { Log.e(TAG, "Bad LatLng at stop " + index); return; }

        String label = (stopLabels != null && index < stopLabels.size())
                ? stopLabels.get(index) : "Stop " + (index + 1);

        Log.d(TAG, "→ Navigating to stop " + index + ": " + label);
        Toast.makeText(this, "Navigating to " + label, Toast.LENGTH_SHORT).show();

        // Set waypoint explicitly — Fleet Engine will also update this
        // server-side, but we set it locally for immediate guidance
        Waypoint wp = Waypoint.builder()
                .setLatLng(dest.latitude, dest.longitude)
                .build();
        navigator.clearDestinations();
        navigator.setDestination(wp);
        navigator.startGuidance();

        currentStopIndex = index;
        arrivalHandled   = false;
    }

    /**
     * Called when driver physically arrives at a stop.
     * Decides what OTP dialog(s) to show, then advances to next stop.
     */
    private void onArrivedAtStop(int index) {
        String label = (stopLabels != null && index < stopLabels.size())
                ? stopLabels.get(index) : "Stop " + (index + 1);
        boolean isLastStop = (index == allStops.size() - 1);
        boolean isLogin    = "Login".equalsIgnoreCase(tripType);

        Log.d(TAG, "Arrived at stop " + index + " (" + label + ") isLast=" + isLastStop);

//        if (isLastStop) {
//            // ── Final stop ────────────────────────────────────────────
//            if (isLogin && "Office".equals(label)) {
//                // Login: reached office — all employees delivered
//                // Mark vehicle OFFLINE — trip fully done
//                updateFleetEngineStatus(RidesharingVehicleReporter.VehicleState.OFFLINE, "COMPLETE");
//                Toast.makeText(this, "✅ All employees at office! Trip complete.",
//                        Toast.LENGTH_LONG).show();
//            } else {
//                updateFleetEngineStatus(RidesharingVehicleReporter.VehicleState.OFFLINE, "COMPLETE");
//                Toast.makeText(this, "✅ Trip Complete!", Toast.LENGTH_LONG).show();
//            }
//
//        }
        if (isLastStop) {
            Toast.makeText(this, "Reached last stop — verify OTP", Toast.LENGTH_SHORT).show();

            showOtpDialogForStop(
                    getEmpNameForStop(index),
                    getEmpMobileForStop(index),
                    getTripIdForStop(index),
                    getEmpIdForStop(index),
                    OtpVerifyDialog.TYPE_DROPOFF,
                    () -> {
                        updateFleetEngineStatus(
                                RidesharingVehicleReporter.VehicleState.OFFLINE,
                                "COMPLETE"
                        );

                        if (navigator != null) {
                            navigator.stopGuidance();
                            navigator.clearDestinations();
                        }

                        Toast.makeText(this, "✅ Trip Complete!", Toast.LENGTH_LONG).show();

                        new Handler(Looper.getMainLooper()).postDelayed(() -> {
                            Intent intent = new Intent(MapActivity.this, Home.class);
                            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
                            startActivity(intent);
                            finish();
                        }, 1500);
                    }
            );

            return;
        }
        else if (!isLogin && "Office".equals(label)) {
            // ── LOGOUT: arrived at office — show boarding OTP for each employee ──
            Toast.makeText(this, "Arrived at Office — verify employee boarding OTPs",
                    Toast.LENGTH_SHORT).show();
            showOfficeboardingOtpSequence(index, 0, () -> {
                // All employees boarded — Fleet Engine advances to first drop
                updateFleetEngineStatus(
                        RidesharingVehicleReporter.VehicleState.ONLINE,
                        "ENROUTE_TO_DROPOFF");
                new android.os.Handler(android.os.Looper.getMainLooper())
                        .postDelayed(
                                MapActivity.this::fetchLatestTripAndNavigate,
                                1500);
            });

        }
//        else {
//            // ── Normal stop (employee for login, or non-office) ───────
//            // OTP for employee stops is handled by marker tap
//            // Just show arrival toast and auto-advance
//            Toast.makeText(this, "Arrived at " + label, Toast.LENGTH_SHORT).show();
////            navigateToStop(index + 1);
//
//            new Handler(Looper.getMainLooper()).postDelayed(
//                    this::fetchLatestTripAndNavigate,
//                    1500
//            );
//        }

        else {

            Toast.makeText(this,
                    "Arrived at " + label + ". Verify OTP to continue.",
                    Toast.LENGTH_LONG).show();

            // ✅ STOP navigation here
            if (navigator != null) {
                navigator.stopGuidance();
            }

            // ❌ DO NOT auto fetch next waypoint
        }
    }

    /**
     * For LOGOUT trips at office: show boarding OTP for each employee sequentially.
     * empOffset tracks which employee in the allStops list we are verifying.
     * Employees in allStops start at index officeIndex+1.
     */
    private void showOfficeboardingOtpSequence(int officeStopIndex, int empOffset, Runnable onAllBoarded) {
        // Employees start after office (officeStopIndex + 1)
        int empStopIndex = officeStopIndex + 1 + empOffset;

        if (empStopIndex >= allStops.size()) {
            Toast.makeText(this, "✅ All employees boarded!", Toast.LENGTH_SHORT).show();
            onAllBoarded.run();  // caller handles Fleet Engine update
            return;
        }

        String empLabel = (stopLabels != null && empStopIndex < stopLabels.size())
                ? stopLabels.get(empStopIndex) : "Employee " + (empOffset + 1);

        // Skip if this is not an employee stop
        if ("Office".equals(empLabel)) {
            onAllBoarded.run();
            return;
        }

        int    empId     = getEmpIdForStop(empStopIndex);
        String empName   = getEmpNameForStop(empStopIndex);
        String empTripId = getTripIdForStop(empStopIndex);
        String empMobile = getEmpMobileForStop(empStopIndex);

        // ✅ Full debug — check all values before showing dialog
        Log.d(TAG, "=== OFFICE BOARDING OTP ===");
        Log.d(TAG, "officeStopIndex = " + officeStopIndex);
        Log.d(TAG, "empOffset       = " + empOffset);
        Log.d(TAG, "empStopIndex    = " + empStopIndex);
        Log.d(TAG, "empName         = " + empName);
        Log.d(TAG, "empId           = " + empId);
        Log.d(TAG, "empTripId       = [" + empTripId + "]");
        Log.d(TAG, "empMobile       = " + empMobile);
        Log.d(TAG, "type            = " + OtpVerifyDialog.TYPE_PICKUP);
        Log.d(TAG, "userId          = " + userId);
        Log.d(TAG, "===========================");

        if (empTripId.isEmpty()) {
            Log.e(TAG, "❌ empTripId is EMPTY for empStopIndex=" + empStopIndex
                    + " — check empTripIds list");
            Log.e(TAG, "empTripIds = " + empTripIds);
            Toast.makeText(this, "Trip ID missing for " + empName, Toast.LENGTH_LONG).show();
            return;
        }

        // Show boarding OTP dialog — after verified, show next employee's dialog
        showOtpDialogForStop(
                empName,
                empMobile,
                empTripId,
                empId,
                OtpVerifyDialog.TYPE_PICKUP,
                () -> showOfficeboardingOtpSequence(officeStopIndex, empOffset + 1, onAllBoarded)
        );
    }

    /**
     * Shows OtpVerifyDialog for one employee.
     * empTripId = the trip_id from pickupDrop for this specific employee.
     */
    private void showOtpDialog(String empName, int empTripId, int empId,
                               String type, Runnable onVerified) {
        // Not used directly — use showOtpDialogForStop instead
        showOtpDialogForStop(empName, "", String.valueOf(empTripId), empId, type, onVerified);
    }

    // ✅ Full method with mobile support
    private void showOtpDialogForStop(String empName, String mobile, String tripIdStr,
                                      int empId, String type, Runnable onVerified) {
        Log.d(TAG, "OTP dialog: emp=" + empName + " mobile=" + mobile
                + " tripId=" + tripIdStr + " empId=" + empId + " type=" + type);
        OtpVerifyDialog.show(
                getSupportFragmentManager(),
                empName,
                mobile,
                userId,
                tripIdStr,
                empId,
                type,
                onVerified::run
        );
    }

    // ── Stop data helpers ──────────────────────────────────

    private int getEmpTripIdForStop(int stopIndex) {
        if (empTripIds != null && stopIndex < empTripIds.size()) return empTripIds.get(stopIndex);
        return -1;
    }

    // ✅ Returns trip_id as String for OTP API (uses empTripIds list)
    private String getTripIdForStop(int stopIndex) {
        if (empTripIds != null && stopIndex < empTripIds.size()) {
            int id = empTripIds.get(stopIndex);
            return id == -1 ? "" : String.valueOf(id);
        }
        return "";
    }

    // ✅ Returns mobile number for stop
    private String getEmpMobileForStop(int stopIndex) {
        if (empMobiles != null && stopIndex < empMobiles.size()) {
            String m = empMobiles.get(stopIndex);
            return m != null ? m : "";
        }
        return "";
    }

    private int getEmpIdForStop(int stopIndex) {
        if (empIds != null && stopIndex < empIds.size()) return empIds.get(stopIndex);
        return -1;
    }

    private String getEmpNameForStop(int stopIndex) {
        if (empNames != null && stopIndex < empNames.size()) return empNames.get(stopIndex);
        return "Employee";
    }

    private ArrayList<String> buildAllStops() {
        ArrayList<String> stops = new ArrayList<>();
        if (startLocation != null && !startLocation.isEmpty()) stops.add(startLocation);
        if (middleStops   != null) stops.addAll(middleStops);
        if (endLocation   != null && !endLocation.isEmpty())   stops.add(endLocation);
        Log.d(TAG, "allStops (" + stops.size() + "): " + stops);
        return stops;
    }

    // ======================================================
    // ROUTE PREVIEW (shown before trip starts)
    // ======================================================

    private void drawRoutePreview() {
        LatLng origin = parseLatLng(startLocation);
        LatLng dest   = parseLatLng(endLocation);
        if (origin == null || dest == null) return;
        fetchRoute(origin, dest);
    }

    private void fetchRoute(LatLng origin, LatLng destination) {
        new Thread(() -> {
            try {
                StringBuilder url = new StringBuilder(
                        "https://maps.googleapis.com/maps/api/directions/json?");
                url.append("origin=").append(origin.latitude).append(",").append(origin.longitude);
                url.append("&destination=").append(destination.latitude).append(",").append(destination.longitude);
                if (middleStops != null && !middleStops.isEmpty()) {
                    url.append("&waypoints=");
                    for (int i = 0; i < middleStops.size(); i++) {
                        url.append(middleStops.get(i));
                        if (i < middleStops.size() - 1) url.append("|");
                    }
                }
                url.append("&mode=driving&key=").append(GOOGLE_API_KEY);

                HttpURLConnection conn = (HttpURLConnection) new URL(url.toString()).openConnection();
                conn.connect();

                BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder json = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) json.append(line);

                JSONObject obj = new JSONObject(json.toString());
                JSONArray routes = obj.getJSONArray("routes");
                if (routes.length() == 0) return;

                JSONObject route  = routes.getJSONObject(0);
                String polyline   = route.getJSONObject("overview_polyline").getString("points");
                ArrayList<LatLng> path = decodePolyline(polyline);
                JSONArray legs    = route.getJSONArray("legs");

                runOnUiThread(() -> {
                    if (mMap != null) {
                        drawPolyline(path);
                        drawMarkers(legs);
                    }
                });
            } catch (Exception e) {
                Log.e(TAG, "fetchRoute: " + e.getMessage(), e);
            }
        }).start();
    }

    private void drawPolyline(ArrayList<LatLng> path) {
        mMap.addPolyline(new PolylineOptions()
                .addAll(path).width(10f).color(0xFF1976D2).geodesic(true));
        LatLngBounds.Builder b = new LatLngBounds.Builder();
        for (LatLng p : path) b.include(p);
        mMap.animateCamera(CameraUpdateFactory.newLatLngBounds(b.build(), 150));
    }

    private void drawMarkers(JSONArray legs) {
        try {
            ArrayList<LatLng> points = new ArrayList<>();
            for (int i = 0; i < legs.length(); i++) {
                JSONObject leg = legs.getJSONObject(i);
                if (i == 0) {
                    JSONObject s = leg.getJSONObject("start_location");
                    points.add(new LatLng(s.getDouble("lat"), s.getDouble("lng")));
                }
                JSONObject e = leg.getJSONObject("end_location");
                points.add(new LatLng(e.getDouble("lat"), e.getDouble("lng")));
            }

            markerStopIndexMap.clear();

            for (int i = 0; i < points.size(); i++) {
                String label = (stopLabels != null && i < stopLabels.size())
                        ? stopLabels.get(i)
                        : (i == 0 ? "Start" : i == points.size()-1 ? "End" : "Stop " + i);

                float color = (i == 0) ? BitmapDescriptorFactory.HUE_GREEN
                        : (i == points.size()-1) ? BitmapDescriptorFactory.HUE_RED
                        : BitmapDescriptorFactory.HUE_ORANGE;

                // ✅ snippet = "Tap to verify OTP" for employee stops
                boolean isOffice = "Office".equals(label);
                String snippet = isOffice
                        ? (i == 0 ? "First stop — Office" : "Final destination — Office")
                        : "Tap to verify OTP";

                com.google.android.gms.maps.model.Marker marker = mMap.addMarker(
                        new MarkerOptions()
                                .position(points.get(i))
                                .title(label)
                                .snippet(snippet)
                                .icon(BitmapDescriptorFactory.defaultMarker(color)));

                // ✅ Store stop index keyed by marker title (unique per stop)
                if (marker != null) {
                    markerStopIndexMap.put(marker.getId(), i);
                }
            }

            // ✅ Set marker click listener — show OTP dialog on tap
            mMap.setOnMarkerClickListener(marker -> {
                marker.showInfoWindow();

                Integer stopIndex = markerStopIndexMap.get(marker.getId());
                if (stopIndex == null) return false;

                String label = marker.getTitle();
                if (label == null) return false;

                // Trip must be started before OTP dialogs are shown
                if (allStops == null) {
                    Toast.makeText(this, "Start the trip first", Toast.LENGTH_SHORT).show();
                    return false;
                }

                boolean isLoginTrip = "Login".equalsIgnoreCase(tripType);
                String  tripIdStr   = getTripIdForStop(stopIndex);
                String  mobile      = getEmpMobileForStop(stopIndex);
                int     empId       = getEmpIdForStop(stopIndex);
                String  name        = getEmpNameForStop(stopIndex);

                Log.d(TAG, "Marker tapped: " + label + " stopIndex=" + stopIndex
                        + " empId=" + empId + " tripId=" + tripIdStr);

                // ── OFFICE MARKER (Logout only) ────────────────────────
                if ("Office".equals(label)) {
                    if (isLoginTrip) {
                        Toast.makeText(this, "Office is the final destination", Toast.LENGTH_SHORT).show();
                        return false;
                    }
                    // Logout: tap office → board all employees one by one
                    showOfficeboardingOtpSequence(stopIndex, 0, () -> {
                        // All employees boarded
                        // Fleet Engine now has all boarding waypoints completed
                        // Fetch next remaining waypoint (first drop location)
                        updateFleetEngineStatus(
                                RidesharingVehicleReporter.VehicleState.ONLINE,
                                "ENROUTE_TO_DROPOFF");
                        new android.os.Handler(android.os.Looper.getMainLooper())
                                .postDelayed(
                                        MapActivity.this::fetchLatestTripAndNavigate,
                                        1500);
                    });
                    return true;
                }

                // ── EMPLOYEE MARKER ────────────────────────────────────
                if (isLoginTrip) {
                    // Login: employee tap → boarding OTP → ENROUTE_TO_DROPOFF
                    // After OTP verified, Fleet Engine removes this waypoint.
                    // We then fetch next remaining waypoint from Fleet Engine.
                    showOtpDialogForStop(name, mobile, tripIdStr, empId,
                            OtpVerifyDialog.TYPE_PICKUP, () -> {
                                updateFleetEngineStatus(
                                        RidesharingVehicleReporter.VehicleState.ONLINE,
                                        "ENROUTE_TO_DROPOFF");
                                new android.os.Handler(android.os.Looper.getMainLooper())
                                        .postDelayed(
                                                MapActivity.this::fetchLatestTripAndNavigate,
                                                1500);
                            });
                } else {
                    // Logout: employee tap → drop-off OTP → COMPLETE
                    // After OTP verified, Fleet Engine removes this waypoint.
                    showOtpDialogForStop(name, mobile, tripIdStr, empId,
                            OtpVerifyDialog.TYPE_DROPOFF, () -> {
                                updateFleetEngineStatus(
                                        RidesharingVehicleReporter.VehicleState.ONLINE,
                                        "COMPLETE");
                                boolean isLast = (stopIndex == allStops.size() - 1);
                                if (isLast) {
                                    updateFleetEngineStatus(
                                            RidesharingVehicleReporter.VehicleState.OFFLINE,
                                            "COMPLETE");
                                    Toast.makeText(this, "✅ Trip Complete!", Toast.LENGTH_LONG).show();
                                } else {
                                    new android.os.Handler(android.os.Looper.getMainLooper())
                                            .postDelayed(
                                                    MapActivity.this::fetchLatestTripAndNavigate,
                                                    1500);
                                }
                            });
                }

                return true;
            });

        } catch (Exception e) {
            Log.e(TAG, "drawMarkers: " + e.getMessage());
        }
    }

    // ======================================================
    // FLEET ENGINE STATUS UPDATE
    // ======================================================

    /**
     * Updates Fleet Engine vehicle state and logs the trip status transition.
     *
     * statusLabel is just for logging — Fleet Engine state is controlled via
     * vehicleReporter. The actual per-trip status (ENROUTE_TO_DROPOFF / COMPLETE)
     * is sent to your backend via the OTP API (/updateTrip_status) which then
     * updates Fleet Engine server-side.
     *
     * On the driver SDK side, we toggle the vehicle state to signal activity:
     *   ENROUTE_TO_DROPOFF → vehicle is ONLINE and actively on a trip
     *   COMPLETE           → vehicle is ONLINE, trip leg done, ready for next
     */
    private void updateFleetEngineStatus(
            RidesharingVehicleReporter.VehicleState state,
            String statusLabel) {

        if (vehicleReporter == null) {
            // Try to get reporter from App if not set yet
            if (App.getDriverApi() != null) {
                vehicleReporter = App.getDriverApi().getRidesharingVehicleReporter();
            }
            if (vehicleReporter == null) {
                Log.w(TAG, "updateFleetEngineStatus: vehicleReporter null, skipping");
                return;
            }
        }

        try {
            vehicleReporter.setVehicleState(state);
            Log.d(TAG, "✅ Fleet Engine → " + statusLabel
                    + " (VehicleState=" + state + ")");
        } catch (Exception e) {
            Log.e(TAG, "Fleet Engine status update failed: " + e.getMessage(), e);
        }
    }

    // ======================================================
    // ARRIVAL CHECK — confirm GPS proximity before triggering OTP
    // ======================================================

    private void startArrivalCheck(LatLng destination, Runnable onReached) {
        com.google.android.gms.location.FusedLocationProviderClient client =
                com.google.android.gms.location.LocationServices
                        .getFusedLocationProviderClient(this);

        Handler handler = new Handler(Looper.getMainLooper());

        Runnable checker = new Runnable() {
            @Override
            public void run() {
                if (ActivityCompat.checkSelfPermission(MapActivity.this,
                        Manifest.permission.ACCESS_FINE_LOCATION)
                        != PackageManager.PERMISSION_GRANTED) return;

                client.getLastLocation().addOnSuccessListener(location -> {
                    if (location == null) { handler.postDelayed(this, 2000); return; }

                    float[] result = new float[1];
                    android.location.Location.distanceBetween(
                            location.getLatitude(), location.getLongitude(),
                            destination.latitude, destination.longitude, result);

                    Log.d(TAG, "Arrival check: " + result[0] + "m from destination");

                    if (result[0] < 50) {
                        onReached.run();
                    } else {
                        handler.postDelayed(this, 2000);
                    }
                });
            }
        };

        handler.post(checker);
    }

    // ======================================================
    // HELPERS
    // ======================================================

    private boolean isLocationEnabled() {
        LocationManager lm = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        return lm != null && (lm.isProviderEnabled(LocationManager.GPS_PROVIDER)
                || lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER));
    }

    private LatLng parseLatLng(String s) {
        try {
            String[] p = s.split(",");
            return new LatLng(Double.parseDouble(p[0].trim()), Double.parseDouble(p[1].trim()));
        } catch (Exception e) {
            Log.e(TAG, "parseLatLng failed: " + s);
            return null;
        }
    }

    private ArrayList<LatLng> decodePolyline(String encoded) {
        ArrayList<LatLng> poly = new ArrayList<>();
        int index = 0, lat = 0, lng = 0;
        while (index < encoded.length()) {
            int b, shift = 0, result = 0;
            do { b = encoded.charAt(index++) - 63; result |= (b & 0x1f) << shift; shift += 5; } while (b >= 0x20);
            lat += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
            shift = 0; result = 0;
            do { b = encoded.charAt(index++) - 63; result |= (b & 0x1f) << shift; shift += 5; } while (b >= 0x20);
            lng += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
            poly.add(new LatLng(lat / 1E5, lng / 1E5));
        }
        return poly;
    }

    private void startLoggingLocation() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) return;

        com.google.android.gms.location.FusedLocationProviderClient client =
                com.google.android.gms.location.LocationServices.getFusedLocationProviderClient(this);

        com.google.android.gms.location.LocationRequest req =
                com.google.android.gms.location.LocationRequest.create()
                        .setInterval(2000).setFastestInterval(1000)
                        .setPriority(com.google.android.gms.location.LocationRequest.PRIORITY_HIGH_ACCURACY);

        client.requestLocationUpdates(req,
                new com.google.android.gms.location.LocationCallback() {
                    @Override
                    public void onLocationResult(@NonNull com.google.android.gms.location.LocationResult result) {
                        for (android.location.Location loc : result.getLocations()) {
                            Log.d("LOCATION_DEBUG", "Lat=" + loc.getLatitude() + " Lng=" + loc.getLongitude());
                        }
                    }
                }, Looper.getMainLooper());
    }

    private void fetchLatestTripAndNavigate() {

        ApiService api = ApiClient.getClient().create(ApiService.class);

        // ✅ GET IDs FROM SESSION
        SessionManager session = new SessionManager(MapActivity.this);

        int companyId = session.getCompanyId();
        int driverId  = session.getDriverId();

        Log.d("NAV_UPDATE", "Fetching latest trip...");

        api.getTrips(companyId, driverId, false).enqueue(new Callback<TripListResponse>() {

            @Override
            public void onResponse(Call<TripListResponse> call,
                                   Response<TripListResponse> response) {

                if (response.isSuccessful()
                        && response.body() != null
                        && response.body().data != null
                        && response.body().data.upcoming != null
                        && !response.body().data.upcoming.isEmpty()) {

                    TripListResponse.TripItem trip =
                            response.body().data.upcoming.get(0);

                    if (trip.waypoints != null && !trip.waypoints.isEmpty()) {

                        TripListResponse.Waypoint wp = trip.waypoints.get(0);

                        Log.d("NAV_UPDATE", "Waypoints count: " + trip.waypoints.size());
                        Log.d("NAV_UPDATE", "Next waypoint: " + wp.lat + "," + wp.lng);
                        Log.d("NAV_UPDATE", "Type: " + wp.type);

                        // 🔥 VERY IMPORTANT FIX → RESET NAVIGATOR FIRST
                        if (navigator != null) {
                            navigator.stopGuidance();
                            navigator.clearDestinations();
                        }

                        // 🔥 ADD SMALL DELAY TO AVOID CACHE ISSUE
                        new Handler(Looper.getMainLooper()).postDelayed(() -> {

                            if (navigator == null) return;

                            Log.d("NAV_UPDATE", "Applying NEW destination");

                            navigator.setDestination(
                                    Waypoint.builder()
                                            .setLatLng(wp.lat, wp.lng)
                                            .build()
                            );

                            navigator.startGuidance();

                        }, 500);   // 🔥 delay is CRITICAL

                    } else {
                        Log.d("NAV_UPDATE", "No waypoints left → Trip complete");
                        finishTripAndGoHome();
                    }

                } else {
                    Log.d("NAV_UPDATE", "No upcoming trips → Trip complete");
                    finishTripAndGoHome();
                }
            }

            @Override
            public void onFailure(Call<TripListResponse> call, Throwable t) {
                Log.e("NAV_UPDATE", "API failed: " + t.getMessage());
            }
        });
    }

    private void finishTripAndGoHome() {

        Log.d("TRIP", "Trip completed → going to Home");

        // ✅ Stop navigation
        if (navigator != null) {
            navigator.stopGuidance();
            navigator.clearDestinations();
        }

        Toast.makeText(this, "Trip Completed", Toast.LENGTH_LONG).show();

        // ✅ Go to Home screen
        Intent intent = new Intent(MapActivity.this, Home.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
        finish();
    }
}


//changing according to gemini
//package com.example.ayaka;
//
//import android.Manifest;
//import android.content.Context;
//import android.content.Intent;
//import android.content.pm.PackageManager;
//import android.location.LocationManager;
//import android.os.Bundle;
//import android.os.Handler;
//import android.os.Looper;
//import android.provider.Settings;
//import android.util.Log;
//import android.view.View;
//import android.widget.Button;
//import android.widget.TextView;
//import android.widget.Toast;
//
//import androidx.annotation.NonNull;
//import androidx.annotation.Nullable;
//import androidx.appcompat.app.AppCompatActivity;
//import androidx.core.app.ActivityCompat;
//
//import com.google.android.gms.maps.CameraUpdateFactory;
//import com.google.android.gms.maps.GoogleMap;
//import com.google.android.gms.maps.OnMapReadyCallback;
//import com.google.android.gms.maps.model.BitmapDescriptorFactory;
//import com.google.android.gms.maps.model.LatLng;
//import com.google.android.gms.maps.model.LatLngBounds;
//import com.google.android.gms.maps.model.MarkerOptions;
//import com.google.android.gms.maps.model.PolylineOptions;
//
//import com.google.android.libraries.navigation.NavigationApi;
//import com.google.android.libraries.navigation.NavigationView;
//import com.google.android.libraries.navigation.Navigator;
//import com.google.android.libraries.navigation.RoadSnappedLocationProvider;
//import com.google.android.libraries.navigation.Waypoint;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.base.data.DriverContext;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.RidesharingDriverApi;
//import com.google.android.libraries.mapsplatform.transportation.driver.api.ridesharing.vehiclereporter.RidesharingVehicleReporter;
//
//import com.google.android.material.bottomsheet.BottomSheetBehavior;
//
//import org.json.JSONArray;
//import org.json.JSONObject;
//
//import java.io.BufferedReader;
//import java.io.InputStreamReader;
//import java.net.HttpURLConnection;
//import java.net.URL;
//import java.util.ArrayList;
//
//public class MapActivity extends AppCompatActivity implements OnMapReadyCallback {
//
//    private static final String TAG                   = "MapActivity";
//    private static final int    LOCATION_PERMISSION   = 100;
//    private static final String PROVIDER_ID           = "ayaka-transassist-mobility";
//    private static final String GOOGLE_API_KEY        = "AIzaSyBNPLbzyyZzA3T1d5hSWkPE3tBW89MhKVw";
//
//    // ── Views ──────────────────────────────────────────────
//    private NavigationView            navigationView;
//    private GoogleMap                 mMap;
//    private BottomSheetBehavior<View> bottomSheetBehavior;
//
//    // ── Trip data ──────────────────────────────────────────
//    private String             startLocation, endLocation;
//    private ArrayList<String>  middleStops;
//    private ArrayList<String>  stopLabels;
//    private String             tripType;          // "Login" or "Logout"
//    private int                userId;
//    private ArrayList<Integer> empTripIds;  // per-employee trip_id from pickupDrop
//    private ArrayList<Integer> empIds;
//    private ArrayList<String>  empNames;
//    private ArrayList<String>  empMobiles; // ✅ mobile_number per employee
//    private String             startAddressText, endAddressText, date, time;
//    private double             distance;
//    private int                persons;
//
//    // ── SDK state ──────────────────────────────────────────
//    private Navigator                  navigator;
//    private RidesharingVehicleReporter vehicleReporter;
//    private boolean isDriverSdkReady      = false;
//    private boolean isNavigatorReady      = false;
//    private boolean shouldStartNavigation = false;
//    private boolean termsAlreadyShown     = false;
//
//    // ── Navigation state ───────────────────────────────────
//    // allStops: full ordered list [startLocation, middleStops..., endLocation]
//    private ArrayList<String> allStops;
//    private int currentStopIndex = 0;
//
//    // ✅ Maps marker title → stop index so tapping a marker shows the right OTP
//    private java.util.HashMap<String, Integer> markerStopIndexMap = new java.util.HashMap<>();
//
//    // ======================================================
//    // LIFECYCLE
//    // ======================================================
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_map);
//
//        startLocation    = getIntent().getStringExtra("start_location");
//        endLocation      = getIntent().getStringExtra("end_location");
//        middleStops      = getIntent().getStringArrayListExtra("middle_stops");
//        startAddressText = getIntent().getStringExtra("start_address");
//        endAddressText   = getIntent().getStringExtra("end_address");
//        date             = getIntent().getStringExtra("date");
//        time             = getIntent().getStringExtra("time");
//        distance         = getIntent().getDoubleExtra("distance", 0);
//        persons          = getIntent().getIntExtra("persons", 0);
//        tripType         = getIntent().getStringExtra("trip_type");
//        stopLabels       = getIntent().getStringArrayListExtra("stop_labels");
//        userId           = getIntent().getIntExtra("user_id", 0);
//        empTripIds       = getIntent().getIntegerArrayListExtra("emp_trip_ids");
//        empIds           = getIntent().getIntegerArrayListExtra("emp_ids");
//        empNames         = getIntent().getStringArrayListExtra("emp_names");
//        empMobiles       = getIntent().getStringArrayListExtra("emp_mobiles");
//
//        if (stopLabels == null) stopLabels  = new ArrayList<>();
//        if (empTripIds == null) empTripIds  = new ArrayList<>();
//        if (empIds     == null) empIds      = new ArrayList<>();
//        if (empNames   == null) empNames    = new ArrayList<>();
//        if (empMobiles == null) empMobiles  = new ArrayList<>();
//
//        navigationView = findViewById(R.id.navigation_view);
//        navigationView.onCreate(savedInstanceState);
//
//        setupBottomSheet();
//
//        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
//                != PackageManager.PERMISSION_GRANTED) {
//            ActivityCompat.requestPermissions(this,
//                    new String[]{Manifest.permission.ACCESS_FINE_LOCATION,
//                            Manifest.permission.ACCESS_COARSE_LOCATION},
//                    LOCATION_PERMISSION);
//        } else {
//            initSdk();
//        }
//    }
//
//    @Override protected void onStart()   { super.onStart();   navigationView.onStart(); }
//    @Override protected void onResume()  { super.onResume();  navigationView.onResume(); }
//    @Override protected void onPause()   { super.onPause();   navigationView.onPause(); }
//    @Override protected void onStop()    { super.onStop();    navigationView.onStop(); }
//    @Override
//    protected void onDestroy() {
//        super.onDestroy();
//        navigationView.onDestroy();
//        // ✅ Stop location tracking when activity closes
//        // to avoid sending stale location to Fleet Engine
//        if (vehicleReporter != null) {
//            try {
//                vehicleReporter.disableLocationTracking();
//                Log.d(TAG, "Location tracking stopped on destroy");
//            } catch (Exception e) {
//                Log.w(TAG, "Error stopping location tracking: " + e.getMessage());
//            }
//        }
//    }
//
//    @Override
//    public void onSaveInstanceState(@NonNull Bundle out) {
//        super.onSaveInstanceState(out);
//        navigationView.onSaveInstanceState(out);
//    }
//
//    @Override
//    public void onRequestPermissionsResult(int code, @NonNull String[] perms, @NonNull int[] results) {
//        super.onRequestPermissionsResult(code, perms, results);
//        if (code == LOCATION_PERMISSION) {
//            if (results.length > 0 && results[0] == PackageManager.PERMISSION_GRANTED) {
//                initSdk();
//            } else {
//                Toast.makeText(this, "Location permission required", Toast.LENGTH_LONG).show();
//                navigationView.getMapAsync(this);
//            }
//        }
//    }
//
//    // ======================================================
//    // SDK INIT
//    // ======================================================
//
//    private void initSdk() {
//        if (!isLocationEnabled()) {
//            Toast.makeText(this, "Please enable GPS", Toast.LENGTH_LONG).show();
//            startActivity(new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS));
//        }
//
//        NavigationApi.getNavigator(this, new NavigationApi.NavigatorListener() {
//
//            @Override
//            public void onNavigatorReady(@NonNull Navigator nav) {
//                Log.d(TAG, "✅ onNavigatorReady");
//                navigator        = nav;
//                isNavigatorReady = true;
//                termsAlreadyShown = false;
//
//                navigationView.getMapAsync(MapActivity.this);
//                new Handler(Looper.getMainLooper()).postDelayed(() -> setupDriverApi(nav), 800);
//
//                if (shouldStartNavigation) {
//                    // allStops was already built in onStartTripClicked before
//                    // shouldStartNavigation was set — safe to call directly
//                    if (allStops == null || allStops.isEmpty()) {
//                        allStops = buildAllStops();  // safety fallback
//                    }
//                    startNavigation();
//                }
//            }
//
//            @Override
//            public void onError(@NavigationApi.ErrorCode int errorCode) {
//                boolean isTerms = (errorCode == NavigationApi.ErrorCode.TERMS_NOT_ACCEPTED)
//                        || (errorCode == 4);
//                if (isTerms && !termsAlreadyShown) {
//                    termsAlreadyShown = true;
//                    NavigationApi.showTermsAndConditionsDialog(MapActivity.this,
//                            "Ayaka Transassist", "Accept navigation terms",
//                            accepted -> {
//                                if (accepted) NavigationApi.getNavigator(MapActivity.this, this);
//                                else navigationView.getMapAsync(MapActivity.this);
//                            });
//                } else {
//                    navigationView.getMapAsync(MapActivity.this);
//                }
//            }
//        });
//    }
//
//    @Override
//    public void onMapReady(@NonNull GoogleMap googleMap) {
//        Log.d(TAG, "✅ onMapReady");
//        mMap = googleMap;
//        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
//                == PackageManager.PERMISSION_GRANTED) {
//            mMap.setMyLocationEnabled(true);
//            mMap.getUiSettings().setMyLocationButtonEnabled(true);
//        }
//        drawRoutePreview();
//    }
//
//    // ======================================================
//    // DRIVER SDK
//    // ======================================================
//
////    private void setupDriverApi(Navigator nav) {
////        if (App.getDriverApi() != null) {
////            Log.d(TAG, "✅ Reusing existing DriverApi");
////            isDriverSdkReady = true;
////            return;
////        }
////        try {
////            RoadSnappedLocationProvider provider =
////                    NavigationApi.getRoadSnappedLocationProvider(getApplication());
////            if (provider == null) return;
////
////            SessionManager session = new SessionManager(getApplicationContext());
////            String token     = session.getAccessToken();
////            String vehicleId = session.getVehicleId();
////            if (vehicleId == null || vehicleId.isEmpty() || token == null || token.isEmpty()) return;
////
////            DriverContext ctx = DriverContext.builder(getApplication())
////                    .setProviderId(PROVIDER_ID)
////                    .setVehicleId(vehicleId)
////                    .setNavigator(nav)
////                    .setRoadSnappedLocationProvider(provider)
////                    .setAuthTokenFactory(new StaticAuthTokenFactory(token))
////                    .build();
////
////            App.setDriverApi(RidesharingDriverApi.createInstance(ctx));
////            isDriverSdkReady = true;
////            Log.d(TAG, "✅ Driver SDK initialized");
////        } catch (Exception e) {
////            Log.e(TAG, "Driver SDK error: " + e.getMessage(), e);
////        }
////    }
//
//    private void setupDriverApi(Navigator nav) {
//        if (App.getDriverApi() != null) {
//            Log.d(TAG, "✅ Reusing existing DriverApi");
//            isDriverSdkReady = true;
//            return;
//        }
//        try {
//            RoadSnappedLocationProvider provider =
//                    NavigationApi.getRoadSnappedLocationProvider(getApplication());
//            if (provider == null) return;
//
//            SessionManager session = new SessionManager(getApplicationContext());
//            String token     = session.getAccessToken();
//            String vehicleId = session.getVehicleId();
//            if (vehicleId == null || vehicleId.isEmpty() || token == null || token.isEmpty()) return;
//
//            DriverContext ctx = DriverContext.builder(getApplication())
//                    .setProviderId(PROVIDER_ID)
//                    .setVehicleId(vehicleId)
//                    .setNavigator(nav)
//                    .setRoadSnappedLocationProvider(provider)
//                    .setAuthTokenFactory(new StaticAuthTokenFactory(token))
//                    // ✅ Correct method name for the 5.0.0 listener
//                    .setDriverStatusListener(new DriverContext.DriverStatusListener() {
//                        @Override
//                        public void updateStatus(
//                                DriverContext.DriverStatusListener.StatusLevel statusLevel,
//                                DriverContext.DriverStatusListener.StatusCode statusCode,
//                                String statusMessage,
//                                @Nullable Throwable cause) {
//
//                            Log.d(TAG, String.format("Fleet Engine Status: %s | Level: %s | Msg: %s",
//                                    statusCode, statusLevel, statusMessage));
//
//                            if (cause != null) {
//                                Log.e(TAG, "Status error detail: ", cause);
//                            }
//                        }
//                    })
//                    .build();
//
//            App.setDriverApi(RidesharingDriverApi.createInstance(ctx));
//            isDriverSdkReady = true;
//            Log.d(TAG, "✅ Driver SDK 5.0.0 initialized");
//        } catch (Exception e) {
//            Log.e(TAG, "Driver SDK error: " + e.getMessage(), e);
//        }
//    }
//
//
//
//    // ======================================================
//    // BOTTOM SHEET
//    // ======================================================
//
//    private void setupBottomSheet() {
//        View bottomSheet = findViewById(R.id.bottomSheet);
//        bottomSheetBehavior = BottomSheetBehavior.from(bottomSheet);
//        bottomSheetBehavior.setState(BottomSheetBehavior.STATE_EXPANDED);
//
//        ((TextView) findViewById(R.id.startAddress)).setText("Start: " + startAddressText);
//        ((TextView) findViewById(R.id.endAddress)).setText("End: " + endAddressText);
//        ((TextView) findViewById(R.id.tripDistance)).setText(
//                String.format(java.util.Locale.getDefault(), "%.2f km", distance));
//        ((TextView) findViewById(R.id.personCount)).setText(String.valueOf(persons));
//        ((TextView) findViewById(R.id.tripDate)).setText(date);
//        ((TextView) findViewById(R.id.tripTime)).setText(time);
//
//        Button startTrip = findViewById(R.id.startTrip);
//        startTrip.setOnClickListener(v -> {
//            bottomSheetBehavior.setState(BottomSheetBehavior.STATE_HIDDEN);
//            onStartTripClicked();
//        });
//    }
//
//    // ======================================================
//    // START TRIP
//    // ======================================================
//
////    private void onStartTripClicked() {
////        if (!isLocationEnabled()) {
////            Toast.makeText(this, "Please enable GPS", Toast.LENGTH_LONG).show();
////            return;
////        }
////
////        if (!isDriverSdkReady && App.getDriverApi() != null) isDriverSdkReady = true;
////
////        if (isDriverSdkReady && App.getDriverApi() != null) {
////            try {
////                vehicleReporter = App.getDriverApi().getRidesharingVehicleReporter();
////
////                // ✅ Set location reporting interval (milliseconds)
////                // This controls how often the driver's location is sent to Fleet Engine
////                vehicleReporter.setLocationReportingInterval(
////                        5, java.util.concurrent.TimeUnit.SECONDS);
////
////                // ✅ enableLocationTracking() starts the RoadSnappedLocationProvider
////                // This is what sends GPS updates to Fleet Engine automatically
////                vehicleReporter.enableLocationTracking();
////
////                // ✅ Mark vehicle ONLINE — Fleet Engine now accepts location updates
////                vehicleReporter.setVehicleState(RidesharingVehicleReporter.VehicleState.ONLINE);
////
////                Log.d(TAG, "✅ Fleet Engine location tracking ON — reporting every 5s");
////            } catch (Exception e) {
////                Log.e(TAG, "VehicleReporter error: " + e.getMessage(), e);
////            }
////        } else {
////            Log.w(TAG, "Driver SDK not ready — location NOT reporting to Fleet Engine");
////        }
////
////        startLoggingLocation();   // ✅ start FusedLocation logging
////        allStops = buildAllStops();
////        currentStopIndex = 0;
////
////        if (isNavigatorReady) {
////            navigateToStop(currentStopIndex);
////        } else {
////            shouldStartNavigation = true;
////            Toast.makeText(this, "Initializing navigation...", Toast.LENGTH_SHORT).show();
////        }
////    }
//
//    private void onStartTripClicked() {
//        if (!isLocationEnabled()) {
//            Toast.makeText(this, "Please enable GPS", Toast.LENGTH_LONG).show();
//            return;
//        }
//
//        if (isDriverSdkReady && App.getDriverApi() != null) {
//            try {
//                vehicleReporter = App.getDriverApi().getRidesharingVehicleReporter();
//                vehicleReporter.setLocationReportingInterval(5, java.util.concurrent.TimeUnit.SECONDS);
//                vehicleReporter.enableLocationTracking();
//                vehicleReporter.setVehicleState(RidesharingVehicleReporter.VehicleState.ONLINE);
//                Log.d(TAG, "✅ Fleet Engine location tracking ON");
//            } catch (Exception e) {
//                Log.e(TAG, "VehicleReporter error: " + e.getMessage());
//            }
//        }
//
//        startLoggingLocation();
//        allStops = buildAllStops(); // This builds your list of [start, middle..., end]
//        currentStopIndex = 0;
//
//        if (isNavigatorReady && allStops != null && !allStops.isEmpty()) {
//            // ✅ Get the first destination from your list
//            String firstStop = allStops.get(currentStopIndex);
//            String[] parts = firstStop.split(",");
//            double lat = Double.parseDouble(parts[0]);
//            double lng = Double.parseDouble(parts[1]);
//
//            // ✅ Create the Waypoint for the Navigator
//            com.google.android.libraries.navigation.Waypoint destination =
//                    com.google.android.libraries.navigation.Waypoint.builder()
//                            .setLatLng(lat, lng)
//                            .setTitle("Next Stop")
//                            .build();
//
//            navigator.setDestination(destination);
//            navigator.startGuidance();
//        } else {
//            shouldStartNavigation = true;
//            Toast.makeText(this, "Initializing navigation...", Toast.LENGTH_SHORT).show();
//        }
//    }
//
//
//
////    private void startNavigation() {
////        if (navigator == null) return;
////
////        // ✅ TRUE FLEET ENGINE SYNCED NAVIGATION
////        //
////        // How it works:
////        // 1. Backend creates trip in Fleet Engine with all waypoints
////        // 2. vehicleReporter.enableLocationTracking() subscribes the vehicle
////        //    to Fleet Engine trip updates
////        // 3. Fleet Engine pushes waypoints to the Driver SDK automatically
////        // 4. The Driver SDK calls navigator.setDestination() internally
////        //    whenever Fleet Engine updates the current waypoint
////        // 5. We just call navigator.startGuidance() — no manual setDestination()
////        //
////        // The RidesharingVehicleReporter.StatusListener receives callbacks
////        // whenever Fleet Engine updates the vehicle's trip/waypoint status.
////        // We listen to this to know when to show OTP dialogs.
////
////        setupFleetEngineArrivalListener();
////
////        // Start guidance — Navigator already has the waypoint from Fleet Engine
////        // (pushed by the SDK when vehicleReporter.enableLocationTracking() was called)
////        navigator.startGuidance();
////        Log.d(TAG, "✅ Fleet Engine synced navigation started");
////    }
//
//    private void startNavigation() {
//        if (navigator == null || allStops == null || allStops.isEmpty()) return;
//
//        // 1. Convert your coordinates into Navigator Waypoints
//        ArrayList<com.google.android.libraries.navigation.Waypoint> navWaypoints = new ArrayList<>();
//        for (String stop : allStops) {
//            String[] parts = stop.split(",");
//            double lat = Double.parseDouble(parts[0]);
//            double lng = Double.parseDouble(parts[1]);
//            navWaypoints.add(com.google.android.libraries.navigation.Waypoint.builder()
//                    .setLatLng(lat, lng)
//                    .setTitle("Trip Stop")
//                    .build());
//        }
//
//        // 2. Set all destinations (Fleet Engine will sync the whole list)
//        navigator.setDestinations(navWaypoints);
//
//        // 3. Add the Arrival Listener
//        navigator.addArrivalListener(new Navigator.ArrivalListener() {
//            @Override
//            public void onArrival(@NonNull com.google.android.libraries.navigation.Waypoint waypoint) {
//                Log.d(TAG, "📍 Driver arrived at waypoint: " + waypoint.getLatLng());
//
//                // This is where you trigger the UI for OTP or "Start Trip"
//                runOnUiThread(() -> {
//                    Toast.makeText(MapActivity.this, "Arrived at destination!", Toast.LENGTH_LONG).show();
//                    handleArrivalAtWaypoint(waypoint);
//                });
//            }
//        });
//
//        navigator.startGuidance();
//    }
//
//
//    /**
//     * Listens to Fleet Engine vehicle status updates via RidesharingVehicleReporter.
//     *
//     * The StatusListener fires when:
//     * - Fleet Engine updates the vehicle's current trip
//     * - A waypoint is reached and Fleet Engine advances to next
//     * - Trip state changes (ENROUTE_TO_PICKUP, ENROUTE_TO_DROPOFF, etc.)
//     *
//     * This is the proper way to know which waypoint Fleet Engine is
//     * currently targeting — we match it to our local stop list for OTP.
//     */
//
//    /**
//     * Called after each OTP verification to advance to the next
//     * Fleet Engine waypoint.
//     *
//     * After /updateTrip_status is called:
//     * 1. Backend marks waypoint complete in Fleet Engine
//     * 2. Fleet Engine pushes next waypoint to Driver SDK
//     * 3. Driver SDK calls navigator.setDestination(nextWaypoint) internally
//     * 4. We call navigator.startGuidance() to show turn-by-turn
//     *
//     * We add a delay to let Fleet Engine process the update before
//     * the SDK receives the new waypoint.
//     */
//    private void navigateToNextFleetEngineWaypoint() {
//        if (navigator == null) return;
//
//        // Give Fleet Engine 2 seconds to push next waypoint to SDK after
//        // the OTP API call (/updateTrip_status) completes
//        new android.os.Handler(android.os.Looper.getMainLooper()).postDelayed(() -> {
//
//            // The Driver SDK has now received the next waypoint from Fleet Engine
//            // and set it on the Navigator internally. We just start guidance.
//            try {
//                navigator.startGuidance();
//                Log.d(TAG, "✅ Guidance started for next Fleet Engine waypoint");
//
//                // Detect which local stop matches the Navigator's current destination
//                // by checking route segments (available after startGuidance())
//                new android.os.Handler(android.os.Looper.getMainLooper())
//                        .postDelayed(this::syncCurrentStopFromNavigator, 1000);
//
//            } catch (Exception e) {
//                Log.e(TAG, "Error starting guidance: " + e.getMessage(), e);
//            }
//
//            // Reattach arrival listener for next waypoint
//            setupFleetEngineArrivalListener();
//
//        }, 2000);
//    }
//
//    /**
//     * After startGuidance(), read the Navigator's current route segment
//     * to find which stop Fleet Engine is targeting.
//     * This syncs currentStopIndex with Fleet Engine's current waypoint.
//     */
//    private void syncCurrentStopFromNavigator() {
//        if (navigator == null) return;
//
//        try {
//            java.util.List<com.google.android.libraries.navigation.RouteSegment> segments =
//                    navigator.getRouteSegments();
//
//            if (segments == null || segments.isEmpty()) {
//                Log.w(TAG, "syncCurrentStop: no route segments yet");
//                return;
//            }
//
//            com.google.android.libraries.navigation.RouteSegment first = segments.get(0);
//            if (first.getDestinationWaypoint() == null) return;
//
//            com.google.android.gms.maps.model.LatLng dest =
//                    first.getDestinationWaypoint().getPosition();
//
//            int matchedIndex = findMatchingLocalStop(dest.latitude, dest.longitude);
//            currentStopIndex = matchedIndex;
//
//            String label = (stopLabels != null
//                    && matchedIndex >= 0
//                    && matchedIndex < stopLabels.size())
//                    ? stopLabels.get(matchedIndex) : "Stop " + matchedIndex;
//
//            Log.d(TAG, "✅ Fleet Engine waypoint synced → local stop "
//                    + matchedIndex + " (" + label + ")"
//                    + " dest=" + dest.latitude + "," + dest.longitude);
//
//            runOnUiThread(() ->
//                    Toast.makeText(this, "Navigating to " + label,
//                            Toast.LENGTH_SHORT).show());
//
//        } catch (Exception e) {
//            Log.e(TAG, "syncCurrentStop error: " + e.getMessage());
//        }
//    }
//
//    /**
//     * Finds which index in our local allStops list is closest to lat/lng.
//     * Used to link Fleet Engine waypoints to our OTP/employee data.
//     */
//    private int findMatchingLocalStop(double lat, double lng) {
//        if (allStops == null || allStops.isEmpty()) return 0;
//
//        int   bestIndex = 0;
//        float bestDist  = Float.MAX_VALUE;
//
//        for (int i = 0; i < allStops.size(); i++) {
//            LatLng local = parseLatLng(allStops.get(i));
//            if (local == null) continue;
//
//            float[] result = new float[1];
//            android.location.Location.distanceBetween(
//                    lat, lng, local.latitude, local.longitude, result);
//
//            if (result[0] < bestDist) {
//                bestDist  = result[0];
//                bestIndex = i;
//            }
//        }
//
//        Log.d(TAG, "findMatchingLocalStop → index=" + bestIndex
//                + " dist=" + bestDist + "m"
//                + " label=" + (stopLabels != null && bestIndex < stopLabels.size()
//                ? stopLabels.get(bestIndex) : "?"));
//        return bestIndex;
//    }
//
//    // ======================================================
//    // CORE NAVIGATION + OTP FLOW
//    //
//    // Stop sequence (allStops):
//    //   Login:  [emp0, emp1, ..., empN, office]
//    //   Logout: [office, emp0, emp1, ..., empN]
//    //
//    // OTP rules:
//    //   Login:  arrive at each employee → show OTP (ENROUTE_TO_DROPOFF)
//    //           arrive at office → trip complete (no OTP)
//    //   Logout: arrive at office → show boarding OTP for EACH employee
//    //                              (ENROUTE_TO_DROPOFF per emp_id)
//    //           arrive at each drop → show OTP (COMPLETE per emp_id)
//    // ======================================================
//
//    // ── Fleet Engine driven navigation ────────────────────
//    // Instead of manually setting destinations, we let Fleet Engine
//    // control waypoints via RidesharingVehicleReporter.
//    // The Navigator receives waypoints automatically from Fleet Engine.
//    // We only listen for arrivals to trigger OTP dialogs.
//
//    private Navigator.ArrivalListener currentArrivalListener = null;
//    private boolean arrivalHandled = false;
//
//    /**
//     * Sets up a single arrival listener.
//     * When the Navigator (guided by Fleet Engine waypoints) fires arrival,
//     * we detect which stop was reached and show the OTP dialog.
//     * After OTP is verified, we call navigateToNextFleetEngineWaypoint()
//     * which reads the UPDATED remaining waypoints from Fleet Engine
//     * (the completed waypoint has been removed by the OTP API call).
//     */
//    private void setupFleetEngineArrivalListener() {
//        if (navigator == null) return;
//
//        if (currentArrivalListener != null) {
//            navigator.removeArrivalListener(currentArrivalListener);
//        }
//        arrivalHandled = false;
//
//        currentArrivalListener = event -> {
//            if (arrivalHandled) return;
//            arrivalHandled = true;
//            Log.d(TAG, "✅ Arrival event — detecting stop from GPS");
//            detectCurrentStopAndHandle();
//        };
//
//        navigator.addArrivalListener(currentArrivalListener);
//        Log.d(TAG, "✅ Fleet Engine arrival listener registered");
//    }
//
//    /**
//     * Called on arrival — detects which stop the driver reached by
//     * comparing current GPS to all stops, finds the closest one,
//     * then triggers the appropriate OTP dialog.
//     */
//    private void detectCurrentStopAndHandle() {
//        if (ActivityCompat.checkSelfPermission(this,
//                Manifest.permission.ACCESS_FINE_LOCATION)
//                != PackageManager.PERMISSION_GRANTED) return;
//
//        com.google.android.gms.location.LocationServices
//                .getFusedLocationProviderClient(this)
//                .getLastLocation()
//                .addOnSuccessListener(location -> {
//                    if (location == null) {
//                        Log.w(TAG, "Location null during arrival detection");
//                        return;
//                    }
//
//                    // Find which stop in allStops is closest to current position
//                    int closestIndex = -1;
//                    float closestDist = Float.MAX_VALUE;
//
//                    for (int i = 0; i < allStops.size(); i++) {
//                        LatLng stopLatLng = parseLatLng(allStops.get(i));
//                        if (stopLatLng == null) continue;
//
//                        float[] result = new float[1];
//                        android.location.Location.distanceBetween(
//                                location.getLatitude(), location.getLongitude(),
//                                stopLatLng.latitude, stopLatLng.longitude,
//                                result);
//
//                        Log.d(TAG, "Stop " + i + " (" + stopLabels.get(i) + "): "
//                                + result[0] + "m away");
//
//                        if (result[0] < closestDist) {
//                            closestDist = result[0];
//                            closestIndex = i;
//                        }
//                    }
//
//                    if (closestIndex == -1) {
//                        Log.e(TAG, "Could not match arrival to any stop");
//                        return;
//                    }
//
//                    final int arrivedAt = closestIndex;
//                    Log.d(TAG, "✅ Matched arrival to stop " + arrivedAt
//                            + " (" + stopLabels.get(arrivedAt) + ")"
//                            + " distance=" + closestDist + "m");
//
//                    // Update currentStopIndex
//                    currentStopIndex = arrivedAt;
//
//                    runOnUiThread(() -> {
//                        // onArrivedAtStop handles OTP dialog.
//                        // After OTP verified, onArrivedAtStop calls
//                        // navigateToNextFleetEngineWaypoint() which reads
//                        // the updated remaining waypoints from Fleet Engine.
//                        onArrivedAtStop(arrivedAt);
//
//                        // Reset arrival guard for next stop
//                        arrivalHandled = false;
//                        setupFleetEngineArrivalListener();
//                    });
//                });
//    }
//
//    /**
//     * Manually navigate to a specific stop index.
//     * Used after OTP verification to explicitly set next waypoint
//     * in case Fleet Engine hasn't advanced yet.
//     */
//    private void navigateToStop(int index) {
//        if (navigator == null) return;
//        if (index >= allStops.size()) {
//            runOnUiThread(() ->
//                    Toast.makeText(this, "✅ Trip Complete!", Toast.LENGTH_LONG).show());
//            return;
//        }
//
//        String target = allStops.get(index);
//        LatLng dest   = parseLatLng(target);
//        if (dest == null) { Log.e(TAG, "Bad LatLng at stop " + index); return; }
//
//        String label = (stopLabels != null && index < stopLabels.size())
//                ? stopLabels.get(index) : "Stop " + (index + 1);
//
//        Log.d(TAG, "→ Navigating to stop " + index + ": " + label);
//        Toast.makeText(this, "Navigating to " + label, Toast.LENGTH_SHORT).show();
//
//        // Set waypoint explicitly — Fleet Engine will also update this
//        // server-side, but we set it locally for immediate guidance
//        Waypoint wp = Waypoint.builder()
//                .setLatLng(dest.latitude, dest.longitude)
//                .build();
//        navigator.clearDestinations();
//        navigator.setDestination(wp);
//        navigator.startGuidance();
//
//        currentStopIndex = index;
//        arrivalHandled   = false;
//    }
//
//    /**
//     * Called when driver physically arrives at a stop.
//     * Decides what OTP dialog(s) to show, then advances to next stop.
//     */
//    private void onArrivedAtStop(int index) {
//        String label = (stopLabels != null && index < stopLabels.size())
//                ? stopLabels.get(index) : "Stop " + (index + 1);
//        boolean isLastStop = (index == allStops.size() - 1);
//        boolean isLogin    = "Login".equalsIgnoreCase(tripType);
//
//        Log.d(TAG, "Arrived at stop " + index + " (" + label + ") isLast=" + isLastStop);
//
//        if (isLastStop) {
//            // ── Final stop ────────────────────────────────────────────
//            if (isLogin && "Office".equals(label)) {
//                // Login: reached office — all employees delivered
//                // Mark vehicle OFFLINE — trip fully done
//                updateFleetEngineStatus(RidesharingVehicleReporter.VehicleState.OFFLINE, "COMPLETE");
//                Toast.makeText(this, "✅ All employees at office! Trip complete.",
//                        Toast.LENGTH_LONG).show();
//            } else {
//                updateFleetEngineStatus(RidesharingVehicleReporter.VehicleState.OFFLINE, "COMPLETE");
//                Toast.makeText(this, "✅ Trip Complete!", Toast.LENGTH_LONG).show();
//            }
//
//        } else if (!isLogin && "Office".equals(label)) {
//            // ── LOGOUT: arrived at office — show boarding OTP for each employee ──
//            Toast.makeText(this, "Arrived at Office — verify employee boarding OTPs",
//                    Toast.LENGTH_SHORT).show();
//            showOfficeboardingOtpSequence(index, 0, () -> {
//                // All employees boarded — Fleet Engine advances to first drop
//                updateFleetEngineStatus(
//                        RidesharingVehicleReporter.VehicleState.ONLINE,
//                        "ENROUTE_TO_DROPOFF");
//                new android.os.Handler(android.os.Looper.getMainLooper())
//                        .postDelayed(
//                                MapActivity.this::navigateToNextFleetEngineWaypoint,
//                                1500);
//            });
//
//        } else {
//            // ── Normal stop ─────────────────────────────────────────
//            // OTP handled by marker tap.
//            // Fleet Engine will push next waypoint automatically after
//            // driver verifies OTP via /updateTrip_status.
//            // Just show toast — do NOT manually advance navigation here.
//            Toast.makeText(this, "Arrived at " + label
//                    + " — tap marker to verify OTP", Toast.LENGTH_SHORT).show();
//        }
//    }
//
//    /**
//     * For LOGOUT trips at office: show boarding OTP for each employee sequentially.
//     * empOffset tracks which employee in the allStops list we are verifying.
//     * Employees in allStops start at index officeIndex+1.
//     */
//    private void showOfficeboardingOtpSequence(int officeStopIndex, int empOffset, Runnable onAllBoarded) {
//        // Employees start after office (officeStopIndex + 1)
//        int empStopIndex = officeStopIndex + 1 + empOffset;
//
//        if (empStopIndex >= allStops.size()) {
//            Toast.makeText(this, "✅ All employees boarded!", Toast.LENGTH_SHORT).show();
//            onAllBoarded.run();  // caller handles Fleet Engine update
//            return;
//        }
//
//        String empLabel = (stopLabels != null && empStopIndex < stopLabels.size())
//                ? stopLabels.get(empStopIndex) : "Employee " + (empOffset + 1);
//
//        // Skip if this is not an employee stop
//        if ("Office".equals(empLabel)) {
//            onAllBoarded.run();
//            return;
//        }
//
//        int    empId     = getEmpIdForStop(empStopIndex);
//        String empName   = getEmpNameForStop(empStopIndex);
//        String empTripId = getTripIdForStop(empStopIndex);
//        String empMobile = getEmpMobileForStop(empStopIndex);
//
//        // ✅ Full debug — check all values before showing dialog
//        Log.d(TAG, "=== OFFICE BOARDING OTP ===");
//        Log.d(TAG, "officeStopIndex = " + officeStopIndex);
//        Log.d(TAG, "empOffset       = " + empOffset);
//        Log.d(TAG, "empStopIndex    = " + empStopIndex);
//        Log.d(TAG, "empName         = " + empName);
//        Log.d(TAG, "empId           = " + empId);
//        Log.d(TAG, "empTripId       = [" + empTripId + "]");
//        Log.d(TAG, "empMobile       = " + empMobile);
//        Log.d(TAG, "type            = " + OtpVerifyDialog.TYPE_PICKUP);
//        Log.d(TAG, "userId          = " + userId);
//        Log.d(TAG, "===========================");
//
//        if (empTripId.isEmpty()) {
//            Log.e(TAG, "❌ empTripId is EMPTY for empStopIndex=" + empStopIndex
//                    + " — check empTripIds list");
//            Log.e(TAG, "empTripIds = " + empTripIds);
//            Toast.makeText(this, "Trip ID missing for " + empName, Toast.LENGTH_LONG).show();
//            return;
//        }
//
//        // Show boarding OTP dialog — after verified, show next employee's dialog
//        showOtpDialogForStop(
//                empName,
//                empMobile,
//                empTripId,
//                empId,
//                OtpVerifyDialog.TYPE_PICKUP,
//                () -> showOfficeboardingOtpSequence(officeStopIndex, empOffset + 1, onAllBoarded)
//        );
//    }
//
//    /**
//     * Shows OtpVerifyDialog for one employee.
//     * empTripId = the trip_id from pickupDrop for this specific employee.
//     */
//    private void showOtpDialog(String empName, int empTripId, int empId,
//                               String type, Runnable onVerified) {
//        // Not used directly — use showOtpDialogForStop instead
//        showOtpDialogForStop(empName, "", String.valueOf(empTripId), empId, type, onVerified);
//    }
//
//    // ✅ Full method with mobile support
//    private void showOtpDialogForStop(String empName, String mobile, String tripIdStr,
//                                      int empId, String type, Runnable onVerified) {
//        Log.d(TAG, "OTP dialog: emp=" + empName + " mobile=" + mobile
//                + " tripId=" + tripIdStr + " empId=" + empId + " type=" + type);
//        OtpVerifyDialog.show(
//                getSupportFragmentManager(),
//                empName,
//                mobile,
//                userId,
//                tripIdStr,
//                empId,
//                type,
//                onVerified::run
//        );
//    }
//
//    // ── Stop data helpers ──────────────────────────────────
//
//    private int getEmpTripIdForStop(int stopIndex) {
//        if (empTripIds != null && stopIndex < empTripIds.size()) return empTripIds.get(stopIndex);
//        return -1;
//    }
//
//    // ✅ Returns trip_id as String for OTP API (uses empTripIds list)
//    private String getTripIdForStop(int stopIndex) {
//        if (empTripIds != null && stopIndex < empTripIds.size()) {
//            int id = empTripIds.get(stopIndex);
//            return id == -1 ? "" : String.valueOf(id);
//        }
//        return "";
//    }
//
//    // ✅ Returns mobile number for stop
//    private String getEmpMobileForStop(int stopIndex) {
//        if (empMobiles != null && stopIndex < empMobiles.size()) {
//            String m = empMobiles.get(stopIndex);
//            return m != null ? m : "";
//        }
//        return "";
//    }
//
//    private int getEmpIdForStop(int stopIndex) {
//        if (empIds != null && stopIndex < empIds.size()) return empIds.get(stopIndex);
//        return -1;
//    }
//
//    private String getEmpNameForStop(int stopIndex) {
//        if (empNames != null && stopIndex < empNames.size()) return empNames.get(stopIndex);
//        return "Employee";
//    }
//
//    private ArrayList<String> buildAllStops() {
//        ArrayList<String> stops = new ArrayList<>();
//        if (startLocation != null && !startLocation.isEmpty()) stops.add(startLocation);
//        if (middleStops   != null) stops.addAll(middleStops);
//        if (endLocation   != null && !endLocation.isEmpty())   stops.add(endLocation);
//        Log.d(TAG, "allStops (" + stops.size() + "): " + stops);
//        return stops;
//    }
//
//    // ======================================================
//    // ROUTE PREVIEW (shown before trip starts)
//    // ======================================================
//
//    private void drawRoutePreview() {
//        LatLng origin = parseLatLng(startLocation);
//        LatLng dest   = parseLatLng(endLocation);
//        if (origin == null || dest == null) return;
//        fetchRoute(origin, dest);
//    }
//
//    private void fetchRoute(LatLng origin, LatLng destination) {
//        new Thread(() -> {
//            try {
//                StringBuilder url = new StringBuilder(
//                        "https://maps.googleapis.com/maps/api/directions/json?");
//                url.append("origin=").append(origin.latitude).append(",").append(origin.longitude);
//                url.append("&destination=").append(destination.latitude).append(",").append(destination.longitude);
//                if (middleStops != null && !middleStops.isEmpty()) {
//                    url.append("&waypoints=");
//                    for (int i = 0; i < middleStops.size(); i++) {
//                        url.append(middleStops.get(i));
//                        if (i < middleStops.size() - 1) url.append("|");
//                    }
//                }
//                url.append("&mode=driving&key=").append(GOOGLE_API_KEY);
//
//                HttpURLConnection conn = (HttpURLConnection) new URL(url.toString()).openConnection();
//                conn.connect();
//
//                BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
//                StringBuilder json = new StringBuilder();
//                String line;
//                while ((line = reader.readLine()) != null) json.append(line);
//
//                JSONObject obj = new JSONObject(json.toString());
//                JSONArray routes = obj.getJSONArray("routes");
//                if (routes.length() == 0) return;
//
//                JSONObject route  = routes.getJSONObject(0);
//                String polyline   = route.getJSONObject("overview_polyline").getString("points");
//                ArrayList<LatLng> path = decodePolyline(polyline);
//                JSONArray legs    = route.getJSONArray("legs");
//
//                runOnUiThread(() -> {
//                    if (mMap != null) {
//                        drawPolyline(path);
//                        drawMarkers(legs);
//                    }
//                });
//            } catch (Exception e) {
//                Log.e(TAG, "fetchRoute: " + e.getMessage(), e);
//            }
//        }).start();
//    }
//
//    private void drawPolyline(ArrayList<LatLng> path) {
//        mMap.addPolyline(new PolylineOptions()
//                .addAll(path).width(10f).color(0xFF1976D2).geodesic(true));
//        LatLngBounds.Builder b = new LatLngBounds.Builder();
//        for (LatLng p : path) b.include(p);
//        mMap.animateCamera(CameraUpdateFactory.newLatLngBounds(b.build(), 150));
//    }
//
//    private void drawMarkers(JSONArray legs) {
//        try {
//            ArrayList<LatLng> points = new ArrayList<>();
//            for (int i = 0; i < legs.length(); i++) {
//                JSONObject leg = legs.getJSONObject(i);
//                if (i == 0) {
//                    JSONObject s = leg.getJSONObject("start_location");
//                    points.add(new LatLng(s.getDouble("lat"), s.getDouble("lng")));
//                }
//                JSONObject e = leg.getJSONObject("end_location");
//                points.add(new LatLng(e.getDouble("lat"), e.getDouble("lng")));
//            }
//
//            markerStopIndexMap.clear();
//
//            for (int i = 0; i < points.size(); i++) {
//                String label = (stopLabels != null && i < stopLabels.size())
//                        ? stopLabels.get(i)
//                        : (i == 0 ? "Start" : i == points.size()-1 ? "End" : "Stop " + i);
//
//                float color = (i == 0) ? BitmapDescriptorFactory.HUE_GREEN
//                        : (i == points.size()-1) ? BitmapDescriptorFactory.HUE_RED
//                        : BitmapDescriptorFactory.HUE_ORANGE;
//
//                // ✅ snippet = "Tap to verify OTP" for employee stops
//                boolean isOffice = "Office".equals(label);
//                String snippet = isOffice
//                        ? (i == 0 ? "First stop — Office" : "Final destination — Office")
//                        : "Tap to verify OTP";
//
//                com.google.android.gms.maps.model.Marker marker = mMap.addMarker(
//                        new MarkerOptions()
//                                .position(points.get(i))
//                                .title(label)
//                                .snippet(snippet)
//                                .icon(BitmapDescriptorFactory.defaultMarker(color)));
//
//                // ✅ Store stop index keyed by marker title (unique per stop)
//                if (marker != null) {
//                    markerStopIndexMap.put(marker.getId(), i);
//                }
//            }
//
//            // ✅ Set marker click listener — show OTP dialog on tap
//            mMap.setOnMarkerClickListener(marker -> {
//                marker.showInfoWindow();
//
//                Integer stopIndex = markerStopIndexMap.get(marker.getId());
//                if (stopIndex == null) return false;
//
//                String label = marker.getTitle();
//                if (label == null) return false;
//
//                // Trip must be started before OTP dialogs are shown
//                if (allStops == null) {
//                    Toast.makeText(this, "Start the trip first", Toast.LENGTH_SHORT).show();
//                    return false;
//                }
//
//                boolean isLoginTrip = "Login".equalsIgnoreCase(tripType);
//                String  tripIdStr   = getTripIdForStop(stopIndex);
//                String  mobile      = getEmpMobileForStop(stopIndex);
//                int     empId       = getEmpIdForStop(stopIndex);
//                String  name        = getEmpNameForStop(stopIndex);
//
//                Log.d(TAG, "Marker tapped: " + label + " stopIndex=" + stopIndex
//                        + " empId=" + empId + " tripId=" + tripIdStr);
//
//                // ── OFFICE MARKER (Logout only) ────────────────────────
//                if ("Office".equals(label)) {
//                    if (isLoginTrip) {
//                        Toast.makeText(this, "Office is the final destination", Toast.LENGTH_SHORT).show();
//                        return false;
//                    }
//                    // Logout: tap office → board all employees one by one
//                    showOfficeboardingOtpSequence(stopIndex, 0, () -> {
//                        // All employees boarded
//                        // Fleet Engine now has all boarding waypoints completed
//                        // Fetch next remaining waypoint (first drop location)
//                        updateFleetEngineStatus(
//                                RidesharingVehicleReporter.VehicleState.ONLINE,
//                                "ENROUTE_TO_DROPOFF");
//                        new android.os.Handler(android.os.Looper.getMainLooper())
//                                .postDelayed(
//                                        MapActivity.this::navigateToNextFleetEngineWaypoint,
//                                        1500);
//                    });
//                    return true;
//                }
//
//                // ── EMPLOYEE MARKER ────────────────────────────────────
//                if (isLoginTrip) {
//                    // Login: employee tap → boarding OTP → ENROUTE_TO_DROPOFF
//                    // After OTP verified, Fleet Engine removes this waypoint.
//                    // We then fetch next remaining waypoint from Fleet Engine.
//                    showOtpDialogForStop(name, mobile, tripIdStr, empId,
//                            OtpVerifyDialog.TYPE_PICKUP, () -> {
//                                updateFleetEngineStatus(
//                                        RidesharingVehicleReporter.VehicleState.ONLINE,
//                                        "ENROUTE_TO_DROPOFF");
//                                new android.os.Handler(android.os.Looper.getMainLooper())
//                                        .postDelayed(
//                                                MapActivity.this::navigateToNextFleetEngineWaypoint,
//                                                1500);
//                            });
//                } else {
//                    // Logout: employee tap → drop-off OTP → COMPLETE
//                    // After OTP verified, Fleet Engine removes this waypoint.
//                    showOtpDialogForStop(name, mobile, tripIdStr, empId,
//                            OtpVerifyDialog.TYPE_DROPOFF, () -> {
//                                updateFleetEngineStatus(
//                                        RidesharingVehicleReporter.VehicleState.ONLINE,
//                                        "COMPLETE");
//                                boolean isLast = (stopIndex == allStops.size() - 1);
//                                if (isLast) {
//                                    updateFleetEngineStatus(
//                                            RidesharingVehicleReporter.VehicleState.OFFLINE,
//                                            "COMPLETE");
//                                    Toast.makeText(this, "✅ Trip Complete!", Toast.LENGTH_LONG).show();
//                                } else {
//                                    new android.os.Handler(android.os.Looper.getMainLooper())
//                                            .postDelayed(
//                                                    MapActivity.this::navigateToNextFleetEngineWaypoint,
//                                                    1500);
//                                }
//                            });
//                }
//
//                return true;
//            });
//
//        } catch (Exception e) {
//            Log.e(TAG, "drawMarkers: " + e.getMessage());
//        }
//    }
//
//    // ======================================================
//    // FLEET ENGINE STATUS UPDATE
//    // ======================================================
//
//    /**
//     * Updates Fleet Engine vehicle state and logs the trip status transition.
//     *
//     * statusLabel is just for logging — Fleet Engine state is controlled via
//     * vehicleReporter. The actual per-trip status (ENROUTE_TO_DROPOFF / COMPLETE)
//     * is sent to your backend via the OTP API (/updateTrip_status) which then
//     * updates Fleet Engine server-side.
//     *
//     * On the driver SDK side, we toggle the vehicle state to signal activity:
//     *   ENROUTE_TO_DROPOFF → vehicle is ONLINE and actively on a trip
//     *   COMPLETE           → vehicle is ONLINE, trip leg done, ready for next
//     */
//    private void updateFleetEngineStatus(
//            RidesharingVehicleReporter.VehicleState state,
//            String statusLabel) {
//
//        if (vehicleReporter == null) {
//            // Try to get reporter from App if not set yet
//            if (App.getDriverApi() != null) {
//                vehicleReporter = App.getDriverApi().getRidesharingVehicleReporter();
//            }
//            if (vehicleReporter == null) {
//                Log.w(TAG, "updateFleetEngineStatus: vehicleReporter null, skipping");
//                return;
//            }
//        }
//
//        try {
//            vehicleReporter.setVehicleState(state);
//            Log.d(TAG, "✅ Fleet Engine → " + statusLabel
//                    + " (VehicleState=" + state + ")");
//        } catch (Exception e) {
//            Log.e(TAG, "Fleet Engine status update failed: " + e.getMessage(), e);
//        }
//    }
//
//    // ======================================================
//    // ARRIVAL CHECK — confirm GPS proximity before triggering OTP
//    // ======================================================
//
//    private void startArrivalCheck(LatLng destination, Runnable onReached) {
//        com.google.android.gms.location.FusedLocationProviderClient client =
//                com.google.android.gms.location.LocationServices
//                        .getFusedLocationProviderClient(this);
//
//        Handler handler = new Handler(Looper.getMainLooper());
//
//        Runnable checker = new Runnable() {
//            @Override
//            public void run() {
//                if (ActivityCompat.checkSelfPermission(MapActivity.this,
//                        Manifest.permission.ACCESS_FINE_LOCATION)
//                        != PackageManager.PERMISSION_GRANTED) return;
//
//                client.getLastLocation().addOnSuccessListener(location -> {
//                    if (location == null) { handler.postDelayed(this, 2000); return; }
//
//                    float[] result = new float[1];
//                    android.location.Location.distanceBetween(
//                            location.getLatitude(), location.getLongitude(),
//                            destination.latitude, destination.longitude, result);
//
//                    Log.d(TAG, "Arrival check: " + result[0] + "m from destination");
//
//                    if (result[0] < 50) {
//                        onReached.run();
//                    } else {
//                        handler.postDelayed(this, 2000);
//                    }
//                });
//            }
//        };
//
//        handler.post(checker);
//    }
//
//    // ======================================================
//    // HELPERS
//    // ======================================================
//
//    private boolean isLocationEnabled() {
//        LocationManager lm = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
//        return lm != null && (lm.isProviderEnabled(LocationManager.GPS_PROVIDER)
//                || lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER));
//    }
//
//    private LatLng parseLatLng(String s) {
//        try {
//            String[] p = s.split(",");
//            return new LatLng(Double.parseDouble(p[0].trim()), Double.parseDouble(p[1].trim()));
//        } catch (Exception e) {
//            Log.e(TAG, "parseLatLng failed: " + s);
//            return null;
//        }
//    }
//
//    private ArrayList<LatLng> decodePolyline(String encoded) {
//        ArrayList<LatLng> poly = new ArrayList<>();
//        int index = 0, lat = 0, lng = 0;
//        while (index < encoded.length()) {
//            int b, shift = 0, result = 0;
//            do { b = encoded.charAt(index++) - 63; result |= (b & 0x1f) << shift; shift += 5; } while (b >= 0x20);
//            lat += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//            shift = 0; result = 0;
//            do { b = encoded.charAt(index++) - 63; result |= (b & 0x1f) << shift; shift += 5; } while (b >= 0x20);
//            lng += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//            poly.add(new LatLng(lat / 1E5, lng / 1E5));
//        }
//        return poly;
//    }
//
//    private void startLoggingLocation() {
//        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
//                != PackageManager.PERMISSION_GRANTED) return;
//
//        com.google.android.gms.location.FusedLocationProviderClient client =
//                com.google.android.gms.location.LocationServices.getFusedLocationProviderClient(this);
//
//        com.google.android.gms.location.LocationRequest req =
//                com.google.android.gms.location.LocationRequest.create()
//                        .setInterval(2000).setFastestInterval(1000)
//                        .setPriority(com.google.android.gms.location.LocationRequest.PRIORITY_HIGH_ACCURACY);
//
//        client.requestLocationUpdates(req,
//                new com.google.android.gms.location.LocationCallback() {
//                    @Override
//                    public void onLocationResult(@NonNull com.google.android.gms.location.LocationResult result) {
//                        for (android.location.Location loc : result.getLocations()) {
//                            Log.d("LOCATION_DEBUG", "Lat=" + loc.getLatitude() + " Lng=" + loc.getLongitude());
//                        }
//                    }
//                }, Looper.getMainLooper());
//    }
//}
//
