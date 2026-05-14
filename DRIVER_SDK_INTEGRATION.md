# AYAKAA Driver SDK Integration Guide — Trip Tracking & Updates

This document summarizes the implementation requirements for the **Google Maps Platform Driver SDK** based on the provided documentation. It focuses on the trip lifecycle, arrival tracking, and status updates (including OTP flows).

---

## 1. Prerequisites & Dependencies
The app must be configured to support the Google Navigation and Driver SDKs.

### Gradle Configuration
Add the following to your `app/build.gradle`:
```gradle
dependencies {
    implementation 'com.google.android.libraries.mapsplatform.transportation:transportation-driver:5.0.0'
    implementation 'com.google.android.libraries.navigation:navigation:5.0.0'
}
```

### Manifest Configuration
Requires an API Key and specific permissions:
*   `ACCESS_FINE_LOCATION`
*   `ACCESS_COARSE_LOCATION`
*   `com.google.android.geo.API_KEY` (Stored in `local.properties`)

---

## 2. Authorization (JWT Tokens)
The most critical part of the integration. Fleet Engine requires **JSON Web Tokens (JWTs)** for every update.

### The AuthTokenFactory
The app must implement a factory that fetches tokens from the AYAKAA backend.
*   **Purpose**: Communicates permissions to Fleet Engine.
*   **Logic**: The factory should fetch a new token if the current one is expired or if the `vehicle_id` changes.
*   **Backend Requirement**: Your server must be able to issue JWTs signed with a Google Service Account.

---

## 3. Initialization Flow
The SDK must be initialized in a specific sequence:

1.  **Obtain Navigator**: Initialize `NavigationApi` and get a `Navigator` object.
2.  **Create DriverContext**: 
    *   Supply `providerId` (Google Cloud Project ID).
    *   Supply `vehicleId` (The ID we just integrated).
    *   Supply the `AuthTokenFactory`.
3.  **Initialize DriverApi**: Use the context to create `RidesharingDriverApi`.
4.  **Get VehicleReporter**: This is the object used to send updates.

---

## 4. Trip Lifecycle & Tracking

### Making the Driver Visible
To receive trips, the driver must be online and tracking location:
1.  `reporter.enableLocationTracking()`: Starts background GPS reporting.
2.  `reporter.setVehicleState(VehicleState.ONLINE)`: Makes the vehicle eligible for matching.

### Destination & Arrival Updates
Once a trip is assigned to the driver:
1.  **Set Destination**: Call `mNavigator.setDestination(waypoint)`. This starts the Google Navigation UI.
2.  **Automatic Updates**: While navigating, the SDK automatically sends ETA and "Remaining Distance" to Fleet Engine. The customer app uses this to show the "Driver is X mins away" status.
3.  **Arrival Detection**: The `Navigator` object can detect when the vehicle enters the arrival radius.

---

## 5. Status Transitions & OTP Verification

### Updating Trip Status
Updates to the trip status (e.g., from "Enroute" to "Arrived") are typically coordinated between the app and the backend:

| Action | SDK/Backend Event |
| :--- | :--- |
| **Arrival at Pickup** | App detects arrival -> Sends "Arrived" status update to Backend/Fleet Engine. |
| **OTP Verification** | App collects OTP -> Backend validates -> Backend/App updates Trip Status to `ENROUTE_TO_DESTINATION`. |
| **Completion** | Driver completes trip -> App updates status to `COMPLETED`. |

### OTP Flow Strategy
1.  **Collect OTP**: Use a custom UI in the Flutter app to collect the passenger's OTP.
2.  **Verify**: Send the OTP to the AYAKAA backend.
3.  **Sync**: Upon successful verification, the backend must update the **Fleet Engine Trip State**. The Driver SDK will then automatically receive the new state and can be configured to show the next navigation waypoint (Drop-off point).

---

## 6. Implementation Notes
*   **Location Interval**: Default is 10 seconds. Can be lowered to 5 seconds for higher precision.
*   **Error Handling**: Use `DriverStatusListener` to catch `VEHICLE_NOT_FOUND` or `BACKEND_CONNECTIVITY_ERROR`.
*   **SSL/TLS**: Ensure the device has updated Google Play Services to handle secure gRPC communication with Fleet Engine.
