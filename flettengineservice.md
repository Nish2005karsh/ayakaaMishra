<?php

namespace App\Services;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

use GuzzleHttp\Exception\RequestException;
use App\Models\User;
use Illuminate\Support\Facades\Log;
use Firebase\JWT\JWT;
use Carbon\Carbon;
use Google\Auth\OAuth2;
use Google\Auth\Credentials\ServiceAccountCredentials;
use GuzzleHttp\Client;
use Illuminate\Support\Facades\Http;

class FleetEngineService
{
    protected $credentials;
    protected $client;
    protected $providerId = 'ayaka-transassist-mobility';
    public function __construct()
    {

        $this->credentials = new ServiceAccountCredentials(
            ['https://www.googleapis.com/auth/fleetengine'],
            storage_path('app/google-service-account.json')
        );

        $this->client = new Client([
            'base_uri' => 'https://fleetengine.googleapis.com/',
            'headers' => [
                'Content-Type' => 'application/json',
                'Authorization' => 'Bearer ' . $this->getAccessToken(),
            ]
        ]);
    }
    public function getAccessToken()
    {
        $token = $this->credentials->fetchAuthToken();
        //dd($token['access_token']);
        return $token['access_token'];
    }



    public function updateVehicle_Status($vehicleId, $status)
    {
        $accessToken = $this->getAccessToken();

        $client = new \GuzzleHttp\Client([
            'base_uri' => 'https://fleetengine.googleapis.com/',
        ]);

        $endpoint = "v1/providers/{$this->providerId}/vehicles/{$vehicleId}?updateMask=vehicleState";

        $payload = [
            "vehicleState" => $status
        ];

        try {
            $response = $client->put($endpoint, [
                'headers' => [
                    'Authorization' => 'Bearer ' . $accessToken,
                    'Content-Type' => 'application/json',
                ],
                'json' => $payload
            ]);

            $responseData = json_decode($response->getBody(), true);
            return $responseData;
        } catch (\Exception $e) {
            dd( $e->getMessage());
            \Log::error('Error updating vehicle state: ' . $e->getMessage());
            return 0;
        }
    }



    public function createVehicle($data)
    {

        $vehicleId = $data['vehicle_id'];

        $maximumCapacity = $data['total_capacity'];

        $endpoint = "v1/providers/{$this->providerId}/vehicles?vehicleId={$vehicleId}";

        $payload = [
            "name" => $vehicleId,
            "vehicleState" => "OFFLINE",
            "supportedTripTypes" => ["SHARED"],
            "maximumCapacity" => $maximumCapacity,
            "vehicleType" => [
                "category" => "AUTO"
            ],
            "attributes" => [
                [
                    "key" => "company_name",
                    "value" => $data['company_name']
                ],
                [
                    "key" => "company_id",
                    "value" => (string) $data['company_id']
                ]
            ]
        ];

        try {
            $response = $this->client->post($endpoint, [
                'json' => $payload
            ]);

            $responseData = json_decode($response->getBody(), true);
            return $responseData;
        } catch (\Exception $e) {
            //dd($e->getMessage());
            \Log::error('Error creating vehicle: ' . $e->getMessage());

            return false;
        }
    }


    public function updateVehicleStatus($providerId, $vehicleId, $status)
    {
        $accessToken = $this->getAccessToken();

        $client = new \GuzzleHttp\Client([
            'base_uri' => 'https://fleetengine.googleapis.com/',
            'headers' => [
                'Content-Type' => 'application/json',
                'Authorization' => 'Bearer ' . $accessToken,
            ]
        ]);

        $endpoint = "v1/providers/{$providerId}/vehicles/{$vehicleId}";

        $payload = [
            'vehicleState' => $status
        ];

        try {
            $response = $client->patch($endpoint, [
                'json' => $payload,
                'query' => [
                    'updateMask' => 'vehicleState'
                ]
            ]);

            return json_decode($response->getBody(), true);
        } catch (\Exception $e) {
            \Log::error('Error updating vehicle status: ' . $e->getMessage());
            return ['error' => $e->getMessage()];
        }
    }






    public function getVehicle($vehicleId)
    {
        $endpoint = "v1/providers/{$this->providerId}/vehicles/{$vehicleId}";
         try {
            $response = $this->client->get($endpoint);

             $fleetVehicle =json_decode($response->getBody(), true);

             return collect($fleetVehicle['waypoints'] ?? [])->map(function ($wp) {
    return [
        'tripId' => $wp['tripId'],
        'type' => $wp['waypointType'],
        'lat' => $wp['location']['point']['latitude'],
        'lng' => $wp['location']['point']['longitude'],
    ];
});


           
            
        } catch (\Exception $e) {
            \Log::error('Error updating vehicle status: ' . $e->getMessage());
            return ['error' => $e->getMessage()];
        }

       

        
    }

    public function getAllVehicles()
    {
        $endpoint = "v1/providers/{$this->providerId}/vehicles";

        $response = $this->client->get($endpoint);

        return json_decode($response->getBody(), true);
    }

    public function deleteVehicle($vehicleId)
    {
        $endpoint = "v1/providers/{$this->providerId}/vehicles/{$vehicleId}";

        $response = $this->client->delete($endpoint);

        return json_decode($response->getBody(), true);
    }


    public function createTrip($tripId)
    {
        if (!Auth::check()) {
            return redirect('/login');
        }

        $company_id = Auth::user()->company_id;

        $company = DB::table('client_companies')
            ->where('company_id', $company_id)
            ->where('company_status', 0)
            ->first();

        if (!$company) {
            return response()->json([
                'success' => false,
                'message' => "Company Not Found"
            ]);
        }

        $company_name = $company->company_name;

        $trips_table = strtolower(str_replace(' ', '_', $company_name)) . '_trips';
        $employees_table = strtolower(str_replace(' ', '_', $company_name)) . '_employees';

        $trip = DB::table($trips_table)
            ->join($employees_table, $employees_table . '.emp_id', '=', $trips_table . '.emp_id')
            ->where($trips_table . '.trip_id', $tripId)
            ->where($trips_table . '.trip_status', 0)
            ->select($trips_table . '.*')
            ->first();

        if (!$trip) {
            return response()->json([
                'success' => false,
                'message' => "Trip not found"
            ]);
        }
$tripID = $trip->tripID;
        // Convert to array if needed
        $trip = (array) $trip;

        // Extract coordinates
        [$pickupLat, $pickupLng] = array_map('trim', explode(',', $trip['actual_pickup_coordinates']));
        [$dropoffLat, $dropoffLng] = array_map('trim', explode(',', $trip['actual_drop_coordinates']));

        // Convert times to RFC3339 (Fleet Engine required format)
        $pickup_time_rfc3339 = !empty($trip['boarding_time'])
            ? date(DATE_RFC3339, strtotime($trip['boarding_time']))
            : null;

        $dropoff_time_rfc3339 = !empty($trip['drop_time'])
            ? date(DATE_RFC3339, strtotime($trip['drop_time']))
            : null;

        // Fleet Engine endpoint
        $endpoint = "v1/providers/{$this->providerId}/trips?tripId={$tripID}";

        $tripData = [
            "tripType" => "SHARED",
            "tripStatus" => "NEW",

            "pickupPoint" => [
                "point" => [
                    "latitude" => (float)$pickupLat,
                    "longitude" => (float)$pickupLng,
                ]
            ],

            "dropoffPoint" => [
                "point" => [
                    "latitude" => (float)$dropoffLat,
                    "longitude" => (float)$dropoffLng,
                ]
            ],
        ];

        // Add pickup time
        if ($pickup_time_rfc3339) {
            $tripData["pickupTime"] = $pickup_time_rfc3339;
        }

        // Add dropoff time
        if ($dropoff_time_rfc3339) {
            $tripData["dropoffTime"] = $dropoff_time_rfc3339;
        }

        // // Optional vehicle assignment
        // if (!empty($trip['vehicle_id'])) {
        //     $tripData["vehicleId"] = $trip['vehicle_id'];
        // }

        try {

            $response = $this->client->post($endpoint, [
                'json' => $tripData
            ]);

            return [
                'success' => true,
                'data' => json_decode($response->getBody(), true)
            ];
        } catch (\Exception $e) {
dd($e->getMessage());
            \Log::error('Trip creation failed', [
                'tripId' => $tripId,
                'error' => $e->getMessage()
            ]);
            return 0;
            // return [
            //     'success' => false,
            //     'message' => $e->getMessage()
            // ];
        }
    }


    public function updateFleetTripLocations($new_routeId)
    {
        if (!Auth::check()) {
            return redirect('/login');
        }

        $data['company_id'] = Auth::user()->company_id;
        $company = DB::table('client_companies')
            ->where('company_id', $data['company_id'])
            ->where('company_status', 0)
            ->first();

        if (!$company) {
            return response()->json(['success' => false, 'message' => "Company Not Found"]);
        }

        $company_name = $company->company_name;
        $data['user_id'] = Auth::user()->user_id;

        $data['trips_table'] = strtolower(str_replace(' ', '_', $company_name)) . '_trips';
        $data['employees_table'] = strtolower(str_replace(' ', '_', $company_name)) . '_employees';

        // Fetch trip + employee details
        $trips = DB::table($data['trips_table'])
            ->join($data['employees_table'], $data['employees_table'] . '.emp_id', '=', $data['trips_table'] . '.emp_id')
            ->where($data['trips_table'] . '.route_id', $new_routeId)
            ->where($data['trips_table'] . '.trip_status', 0)
            ->select($data['trips_table'] . '.*')
            ->get();

        if ($trips->isEmpty()) {
            return response()->json(['success' => false, 'message' => 'No trips found']);
        }

        $tripType = strtolower($trips->first()->trip_direction); // login/logout
        $escort = $trips->firstWhere('employee_type', 'escort');

        // Sort by route_order
        $sorted = $trips->sortBy('route_order')->values();

        // Reorder based on escort presence
        if ($escort) {
            $sorted = $sorted->reject(fn($e) => $e->employee_type == 'escort')->values();

            if ($tripType == 'login') {
                $sorted->prepend($escort); // Escort first for login
            } elseif ($tripType == 'logout') {
                $sorted->push($escort); // Escort last for logout
            }
        }

        // --- Helper function to split lat,lng ---
        $splitGeo = function ($geoString) {
            if (!$geoString) return [0, 0];
            $parts = explode(',', $geoString);
            return [
                isset($parts[0]) ? (float) trim($parts[0]) : 0,
                isset($parts[1]) ? (float) trim($parts[1]) : 0,
            ];
        };

        // --- Determine pickup/drop points ---
        if ($escort) {
            [$pickupLat, $pickupLng] = $splitGeo($escort->employee_geolocation);
            [$dropoffLat, $dropoffLng] = $splitGeo($escort->destination_geolocation);
        } else {
            if ($tripType == 'login') {
                [$pickupLat, $pickupLng] = $splitGeo($sorted->first()->employee_geolocation);
                [$dropoffLat, $dropoffLng] = $splitGeo($sorted->first()->destination_geolocation);
            } elseif ($tripType == 'logout') {
                [$pickupLat, $pickupLng] = $splitGeo($sorted->last()->employee_geolocation);
                [$dropoffLat, $dropoffLng] = $splitGeo($sorted->last()->destination_geolocation);
            }
        }

        // --- Prepare intermediate points ---
        $intermediatePoints = [];
        foreach ($sorted as $index => $emp) {

            if ($escort) {
                if ($tripType === 'login' && $index === 0) continue;
                if ($tripType === 'logout' && $index === $sorted->count() - 1) continue;
            } else {
                if ($tripType == 'login' && $index === 0) continue;
                if ($tripType == 'logout' && $index === $sorted->count() - 1) continue;
            }

            [$lat, $lng] = $splitGeo($emp->employee_geolocation);

            $intermediatePoints[] = [

                "point" => [
                    "latitude" => $lat,
                    "longitude" => $lng,
                ]
            ];
        }



        $tripID = $sorted->first()->tripID;

        $tripData = [
            "tripType" => "EXCLUSIVE",
            "vehicleId" => "",
            "tripStatus" => "NEW",
            "pickupPoint" => [
                "point" => ["latitude" => $pickupLat, "longitude" => $pickupLng]
            ],
            "dropoffPoint" => [
                "point" => ["latitude" => $dropoffLat, "longitude" => $dropoffLng]
            ],
            "intermediateDestinations" => $intermediatePoints
        ];

        // --- Update Fleet Trip ---
        $endpoint = "v1/providers/{$this->providerId}/trips/{$tripID}?updateMask=pickupPoint,dropoffPoint,intermediateDestinations";

        try {
            $response = $this->client->put($endpoint, ['json' => $tripData]);
            $result = json_decode($response->getBody(), true);
            // dd($result);
            return 1;
        } catch (\Exception $e) {
            dd($e->getMessage());
            \Log::error('Failed to update fleet trip: ' . $e->getMessage());
            return 0;
        }
    }

 public function assignVehicleAndWaypoints($routeId, $vehicleId)
{
      $data['company_id'] = Auth::user()->company_id;
        $company = DB::table('client_companies')
            ->where('company_id', $data['company_id'])
            ->where('company_status', 0)
            ->first();

        if (!$company) {
            return response()->json(['success' => false, 'message' => "Company Not Found"]);
        }

        $company_name = $company->company_name;
        $data['user_id'] = Auth::user()->user_id;

       $trips_table = strtolower(str_replace(' ', '_', $company_name)) . '_trips';
        $employees_table = strtolower(str_replace(' ', '_', $company_name)) . '_employees';
    try {

        // 1. Get all trips
        $trips = DB::table($trips_table)
            ->where('route_id', $routeId)
            ->where('trip_status', 0)
            ->orderBy('route_order', 'asc')
            ->get();

        if ($trips->isEmpty()) {
            return ['success' => false, 'message' => 'No trips found'];
        }

        $updatedTrips = [];

        // 2. Assign vehicle to all trips
        foreach ($trips as $trip) {

            $res = $this->updateTripVehicle($trip->tripID, $vehicleId);

            if (!$res) {

                //  If any fails → revert already updated trips
                $this->revertTrips($updatedTrips);

                return ['success' => false, 'message' => 'Trip assignment failed'];
            }

            $updatedTrips[] = $trip->tripID;
        }

        // 3. Prepare waypoints
       $waypoints = [];

$pickupWaypoints = [];
$dropoffWaypoints = [];

foreach ($trips as $trip) {

    // Split pickup coordinates
    list($pickupLat, $pickupLng) = explode(',', $trip->actual_pickup_coordinates);

    // Split drop coordinates
    list($dropLat, $dropLng) = explode(',', $trip->actual_drop_coordinates);

    // Store PICKUP
    $pickupWaypoints[] = [
        'tripId' => $trip->tripID,
        'type' => 'PICKUP_WAYPOINT_TYPE',
        'location' => [
            'latitude' => (float) $pickupLat,
            'longitude' => (float) $pickupLng
        ]
    ];

    // Store DROPOFF
    $dropoffWaypoints[] = [
        'tripId' => $trip->tripID,
        'type' => 'DROP_OFF_WAYPOINT_TYPE',
        'location' => [
            'latitude' => (float) $dropLat,
            'longitude' => (float) $dropLng
        ]
    ];
}

// Final order: all pickups first, then all drop-offs
$waypoints = array_merge($pickupWaypoints, $dropoffWaypoints);
        // 4. Push waypoints
        $waypointRes = $this->assignVehicleWaypoints($vehicleId, $waypoints);

        if (!$waypointRes) {

            // ❗ CRITICAL: undo vehicle assignment
            $this->revertTrips($updatedTrips);

            return ['success' => false, 'message' => 'Waypoint push failed'];
        }

        return ['success' => true];

    } catch (\Exception $e) {

        \Log::error($e->getMessage());

        return ['success' => false, 'message' => $e->getMessage()];
    }
}

public function assignVehicleWaypoints($vehicleId, $waypoints)
{
  
    try {

        $formattedWaypoints = [];

        foreach ($waypoints as $wp) {

            $formattedWaypoints[] = [
                'tripId' => $wp['tripId'],
                'waypointType' => $wp['type'], // MUST be PICKUP or DROPOFF
                'location' => [
                    'point' => [
                        'latitude' => (float) $wp['location']['latitude'],
                        'longitude' => (float) $wp['location']['longitude']
                    ]
                ]
            ];
        }

        $endpoint = "v1/providers/{$this->providerId}/vehicles/{$vehicleId}?updateMask=waypoints";

        $payload = [
            'waypoints' => $formattedWaypoints
        ];

        // 🔍 Debug (optional)
        \Log::info('WAYPOINT PAYLOAD', $payload);

        $response = $this->client->put($endpoint, [
            'json' => $payload
        ]);

        return json_decode($response->getBody(), true);

    } catch (\Exception $e) {
dd($e->getMessage());
        \Log::error("Waypoint update failed: " . $e->getMessage());

        return false;
    }
}
private function revertTrips($tripIds)
{
    foreach ($tripIds as $tripId) {
        try {
            $this->updateTripVehicle($tripId, null); 
        } catch (\Exception $e) {
            \Log::error("Revert failed for trip {$tripId}");
        }
    }
}

    public function updateTrip_status($tripData)
    {
        $endpoint = "v1/providers/{$this->providerId}/trips/{$tripData['trip_id']}?updateMask=trip_status";

        try {
            $payload = [
                'trip_status' => $tripData['status']
            ];

            $response = $this->client->put($endpoint, [
                'json' => $payload
            ]);

              json_decode($response->getBody(), true);
            return true;
        } catch (\Exception $e) {
dd($e->getMessage());
            return 0;
            // dd($e->getMessage());
            \Log::error("Failed to update trip vehicle ID for Trip {$tripID}: " . $e->getMessage());
        }
    }

    public function updateTripStatus($tripID)
    {
        $endpoint = "v1/providers/{$this->providerId}/trips/{$tripID}?updateMask=trip_status";

        try {
            $payload = [
                'trip_status' => "CANCELED"
            ];

            $response = $this->client->put($endpoint, [
                'json' => $payload
            ]);

            return  json_decode($response->getBody(), true);
        } catch (\Exception $e) {

            return 0;
            // dd($e->getMessage());
            \Log::error("Failed to update trip vehicle ID for Trip {$tripID}: " . $e->getMessage());
        }
    }
    
    
    
    
     public function updateTripVehicle($tripID, $vehicleID)
    {
        $endpoint = "v1/providers/{$this->providerId}/trips/{$tripID}?updateMask=vehicleId";

        try {
            $payload = [
                'vehicleId' => $vehicleID
            ];

            $response = $this->client->put($endpoint, [
                'json' => $payload
            ]);

            return  json_decode($response->getBody(), true);
        } catch (\Exception $e) {
 dd($e->getMessage());
            return 0;
            // dd($e->getMessage());
            \Log::error("Failed to update trip vehicle ID for Trip {$tripID}: " . $e->getMessage());
        }
    }


    public function getTrip($tripID)
    {
        $endpoint = "v1/providers/{$this->providerId}/trips/{$tripID}";

        try {
            $response = $this->client->get($endpoint);
            dd(json_decode($response->getBody(), true));
            return json_decode($response->getBody(), true);
        } catch (\Exception $e) {
            \Log::error('Failed to fetch trip details: ' . $e->getMessage());
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }
    public function listTrips()
    {
        $endpoint = "v1/providers/{$this->providerId}/trips:search";

        $body = [
            "activeTripsOnly" => true, // Set to true if you only want active trips
            "pageSize" => 100,

        ];

        try {
            $response = $this->client->post($endpoint, [
                'json' => $body
            ]);
            dd(json_decode($response->getBody(), true));
            $trips = json_decode($response->getBody(), true);

            return [
                'success' => true,
                'trips' => $trips
            ];
        } catch (\Exception $e) {
            \Log::error('Failed to list trips: ' . $e->getMessage());
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }
    public function deleteTrip($tripID)
    {
        $endpoint = "v1/providers/{$this->providerId}/trips/{$tripID}";

        try {
            $response = $this->client->delete($endpoint);
            dd(json_decode($response->getBody(), true));
            return [
                'success' => true,
                'message' => "Trip ID {$tripID} deleted successfully."
            ];
        } catch (\Exception $e) {
            dd($e->getMessage());
            \Log::error("Failed to delete trip {$tripID}: " . $e->getMessage());
            return [
                'success' => false,
                'message' => "Failed to delete trip {$tripID}.",
                'error' => $e->getMessage()
            ];
        }
    }

    public function cancelTrip($tripId)
    {
        $endpoint = "v1/providers/{$this->providerId}/trips/{$tripId}?updateMask=tripStatus";

        $payload = [
            "tripStatus" => "CANCELED"
        ];
        try {
            $response = $this->client->put($endpoint, [
                'json' => $payload
            ]);

            return json_decode($response->getBody(), true);
        } catch (\Exception $e) {
            return $e;

            return $e->getMessage();
        }
    }


    public function getVehicleLocation($vehicleId)
    {
        $accessToken = $this->getAccessToken();
        $url = "https://fleetengine.googleapis.com/v1/providers/{$this->providerId}/vehicles/{$vehicleId}";
        //dd($accessToken);
        $response = Http::withToken($accessToken)->get($url);

        if ($response->successful()) {
            return $response->json();
        }

        \Log::error('Vehicle fetch failed: ' . $response->body());
        return ['error' => $response->body(), 'status_code' => $response->status()];
    }

    public function updateCustomVehicle()
    {
        $vehicleId = 'vehicle5-test_company';
        $accessToken = $this->getAccessToken();

        $updateMask = 'vehicle_state,attributes,back_to_back_enabled';
        $url = "https://fleetengine.googleapis.com/v1/providers/{$this->providerId}/vehicles/{$vehicleId}?updateMask={$updateMask}";

        $response = Http::withToken($accessToken)
            ->withHeaders([
                'Content-Type' => 'application/json',
            ])
            ->put($url, [
                'vehicleState' => 'ONLINE',
                'attributes' => [
                    ['key' => 'class', 'value' => 'LUXURY'],
                    ['key' => 'cash_only', 'value' => 'false'],
                    ['key' => 'company_id', 'value' => '29'],
                    ['key' => 'status', 'value' => 'ONLINE'],
                ],
                'backToBackEnabled' => true
            ]);

        return response()->json($response->json(), $response->status());
    }

    public function listFilteredVehicles()
    {
        $filter = "attributes.company_id = \"29\"";
        $accessToken = $this->getAccessToken();

        $response = Http::withToken($accessToken)
            ->get("https://fleetengine.googleapis.com/v1/providers/{$this->providerId}/vehicles", [
                'filter' => $filter
            ]);

        return response()->json([
            'raw_response' => $response->json(),
            'http_status' => $response->status()
        ]);
    }

    public function getRouteOptimizationToken()
    {

        $scopes = ['https://www.googleapis.com/auth/cloud-platform'];

        $credentials = new ServiceAccountCredentials(
            $scopes,
            storage_path('app/google-service-account.json')
        );

        $token = $credentials->fetchAuthToken();

        return $token['access_token'];
    }



    // public function OptimizeRoutes($trips)
    // {
    //     if (!$trips || count($trips) < 2) {
    //         return [
    //             "success" => false,
    //             "message" => "Not enough trips to optimize"
    //         ];
    //     }

    //     $direction = $trips[0]->trip_direction; // login/logout

    //     //  Start location = first trip employee_geolocation
    //     [$startLat, $startLng] = array_map('trim', explode(',', $trips[0]->employee_geolocation));

    //     //  End location for login = office (destination same)
    //     $endLat = null;
    //     $endLng = null;

    //     if ($direction === "login") {
    //         [$endLat, $endLng] = array_map('trim', explode(',', $trips[0]->destination_geolocation));
    //     }

    //     //  Build shipments
    //     $shipments = [];
    //     foreach ($trips as $trip) {

    //         if ($direction === "login") {
    //             [$pickupLat, $pickupLng] = array_map('trim', explode(',', $trip->employee_geolocation));

    //             $shipments[] = [
    //                 "pickups" => [[
    //                     "arrivalLocation" => [
    //                         "latitude" => (float) $pickupLat,
    //                         "longitude" => (float) $pickupLng
    //                     ],
    //                     "duration" => "0s"
    //                 ]],
    //                 "label" => $trip->tripID
    //             ];
    //         }

    //         if ($direction === "logout") {
    //             [$dropLat, $dropLng] = array_map('trim', explode(',', $trip->destination_geolocation));

    //             $shipments[] = [
    //                 "deliveries" => [[
    //                     "arrivalLocation" => [
    //                         "latitude" => (float) $dropLat,
    //                         "longitude" => (float) $dropLng
    //                     ],
    //                     "duration" => "0s"
    //                 ]],
    //                 "label" => $trip->tripID
    //             ];
    //         }
    //     }

    //     $maxDurationSeconds = 90 * 60; //  90 min limit

    //     $vehicle = [
    //         "label" => "vehicle_1",
    //         "startLocation" => [
    //             "latitude" => (float) $startLat,
    //             "longitude" => (float) $startLng
    //         ],
    // "routeDurationLimit" => [
    //         "maxDuration" => $maxDurationSeconds . "s"
    //     ],
    //     ];

    //     //  Login: must end at office
    //     if ($direction === "login" && $endLat && $endLng) {
    //         $vehicle["endLocation"] = [
    //             "latitude" => (float) $endLat,
    //             "longitude" => (float) $endLng
    //         ];
    //     }

    //     $payload = [
    //         "model" => [
    //             "shipments" => $shipments,
    //             "vehicles" => [$vehicle]
    //         ]
    //     ];


    //     $token = $this->getRouteOptimizationToken();

    //     $endpoint = "https://routeoptimization.googleapis.com/v1/projects/{$this->providerId}:optimizeTours";

    //     try {
    //         $response = $this->client->post($endpoint, [
    //             'headers' => [
    //                 'Authorization' => "Bearer {$token}",
    //                 'Content-Type' => 'application/json',
    //             ],
    //             'json' => $payload
    //         ]);

    //         $res = json_decode($response->getBody(), true);
    // return $res;




    //     } catch (\Exception $e) {
    // dd($e->getMessage());
    //         \Log::error("OptimizeTours failed: " . $e->getMessage());

    //         return [
    //             "success" => false,
    //             "message" => "Route Optimization API Failed",
    //             "error" => $e->getMessage()
    //         ];
    //     }
    // }

    private function haversineDistance($lat1, $lon1, $lat2, $lon2)
    {
        $earthRadius = 6371; // KM

        $lat1 = deg2rad((float)$lat1);
        $lon1 = deg2rad((float)$lon1);
        $lat2 = deg2rad((float)$lat2);
        $lon2 = deg2rad((float)$lon2);

        $dLat = $lat2 - $lat1;
        $dLon = $lon2 - $lon1;

        $a = sin($dLat / 2) * sin($dLat / 2) +
            cos($lat1) * cos($lat2) *
            sin($dLon / 2) * sin($dLon / 2);

        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        return $earthRadius * $c; // KM
    }

    private function haversineDistancePoints($pointA, $pointB)
    {
        [$lat1, $lon1] = explode(',', $pointA);
        [$lat2, $lon2] = explode(',', $pointB);

        return $this->haversineDistance(
            (float)$lat1,
            (float)$lon1,
            (float)$lat2,
            (float)$lon2
        );
    }

// public function optimizeRoutes($trips)
// {
//     // ... [Previous Auth & Company checks] ...

//     $shipments = [];
//     $tripType = strtoupper($trips[0]->trip_direction);
    
//     // 1. Identify Office Location
//     // For LOGIN: Office is Destination. For LOGOUT: Office is Pickup.
//     if ($tripType === "LOGIN") {
//         [$officeLat, $officeLng] = explode(',', $trips[0]->destination_geolocation);
//     } else {
//         [$officeLat, $officeLng] = explode(',', $trips[0]->employee_geolocation);
//     }

//     foreach ($trips as $trip) {
//         [$empLat, $empLng] = explode(',', $trip->employee_geolocation);

//         $shipment = [
//             "label" => (string)$trip->tripID,
//             "loadDemands" => [
//                 "seats" => ["amount" => 1] // Each employee takes 1 seat
//             ],
//             "pickupToDeliveryTimeLimit" => "3600s" // Max 60 mins in cab
//         ];

//         if ($tripType === "LOGIN") {
//             // Employee Home -> Office
//             $shipment["pickups"] = [[
//                 "arrivalWaypoint" => ["location" => ["latLng" => ["latitude" => (float)$empLat, "longitude" => (float)$empLng]]],
//                 "duration" => "120s"
//             ]];
//             $shipment["deliveries"] = [[
//                 "arrivalWaypoint" => ["location" => ["latLng" => ["latitude" => (float)$officeLat, "longitude" => (float)$officeLng]]],
//                 "duration" => "60s"
//             ]];
//         } else {
//             // Office -> Employee Home
//             $shipment["pickups"] = [[
//                 "arrivalWaypoint" => ["location" => ["latLng" => ["latitude" => (float)$officeLat, "longitude" => (float)$officeLng]]],
//                 "duration" => "120s"
//             ]];
//             $shipment["deliveries"] = [[
//                 "arrivalWaypoint" => ["location" => ["latLng" => ["latitude" => (float)$empLat, "longitude" => (float)$empLng]]],
//                 "duration" => "60s"
//             ]];
//         }
//         $shipments[] = $shipment;
//     }

//     // 2. Define Vehicle Pool (The "Clubbing" Brain)
//     $vehicles = [];
//     $maxVehicles = ceil(count($trips) / 2); 

//     for ($i = 0; $i < $maxVehicles; $i++) {
//         $vehicles[] = [
//             "label" => "CAB_" . ($i + 1),
//             "startWaypoint" => [
//                 "location" => ["latLng" => ["latitude" => (float)$officeLat, "longitude" => (float)$officeLng]]
//             ],
//             // FIXED: It is "amount", not "maxAmount"
//             "loadLimits" => [
//                 "seats" => ["amount" => 4] 
//             ],
//             "fixedCost" => 1000, // Forces the AI to group people to save "1000" units
//             "costPerKilometer" => 10
//         ];
//     }

//     $payload = [
//         "model" => [
//             "shipments" => $shipments,
//             "vehicles" => $vehicles,
//             "globalStartTime" => \Carbon\Carbon::now('UTC')->format('Y-m-d\TH:i:s\Z'),
//             "globalEndTime"   => \Carbon\Carbon::now('UTC')->addDay()->format('Y-m-d\TH:i:s\Z'),
//         ]
//     ];

//     try {
//         $response = $this->client->post(
//             "https://routeoptimization.googleapis.com/v1/projects/ayaka-transassist-mobility:optimizeTours",
//             [
//                 "headers" => [
//                     "Authorization" => "Bearer " . $this->getRouteOptimizationToken(),
//                     "Content-Type"  => "application/json"
//                 ],
//                 "json" => $payload
//             ]
//         );

//         return response()->json([
//             "success" => true,
//             "data" => json_decode($response->getBody(), true)
//         ]);

//     } catch (\Exception $e) {
//         return response()->json(["success" => false, "error" => $e->getMessage()]);
//     }
// }

public function optimizeRoutes($trips)
{
    if (!Auth::check()) {
        return redirect('/login');
    }

    $company_id = Auth::user()->company_id;

    $company = DB::table('client_companies')
        ->where('company_id', $company_id)
        ->where('company_status', 0)
        ->first();

    if (!$company) {
        return response()->json([
            'success' => false,
            'message' => "Company Not Found"
        ]);
    }

    $company_name = $company->company_name;
    $trips_table = strtolower(str_replace(' ', '_', $company_name)) . '_trips';

    if ($trips instanceof \Illuminate\Support\Collection) {
        $trips = $trips->values()->all();
    }

    if (empty($trips)) {
        return ["success" => false, "message" => "Trips empty"];
    }

    if (!$this->client) {
        $this->client = new \GuzzleHttp\Client([
            'timeout' => 60,
            'http_errors' => true
        ]);
    }

    try {

        $shipments = [];
        $tripDates = [];

       

        foreach ($trips as $trip) {

            $tripDates[] = \Carbon\Carbon::parse($trip->trip_date, 'Asia/Kolkata');

            [$empLat, $empLng]   = explode(',', $trip->employee_geolocation);
            [$destLat, $destLng] = explode(',', $trip->destination_geolocation);

            $pickupStart = \Carbon\Carbon::parse(
                $trip->trip_date . ' ' . $trip->boarding_time,
                'Asia/Kolkata'
            )->subMinutes(3)->utc()->format('Y-m-d\TH:i:s\Z');

            $pickupEnd = \Carbon\Carbon::parse(
                $trip->trip_date . ' ' . $trip->boarding_time,
                'Asia/Kolkata'
            )->addMinutes(3)->utc()->format('Y-m-d\TH:i:s\Z');

            $deliveryStart = \Carbon\Carbon::parse(
                $trip->trip_date . ' ' . $trip->drop_time,
                'Asia/Kolkata'
            )->subMinutes(5)->utc()->format('Y-m-d\TH:i:s\Z');

            $deliveryEnd = \Carbon\Carbon::parse(
                $trip->trip_date . ' ' . $trip->drop_time,
                'Asia/Kolkata'
            )->addMinutes(5)->utc()->format('Y-m-d\TH:i:s\Z');

            $shipments[] = [
                "label" => (string)$trip->trip_id,

                "pickups" => [[
                    "arrivalWaypoint" => [
                        "location" => [
                            "latLng" => [
                                "latitude"  => (float)$empLat,
                                "longitude" => (float)$empLng
                            ]
                        ]
                    ],
                    "duration" => "60s",
                    "timeWindows" => [[
                        "startTime" => $pickupStart,
                        "endTime"   => $pickupEnd
                    ]]
                ]],

                "deliveries" => [[
                    "arrivalWaypoint" => [
                        "location" => [
                            "latLng" => [
                                "latitude"  => (float)$destLat,
                                "longitude" => (float)$destLng
                            ]
                        ]
                    ],
                    "duration" => "60s",
                    "timeWindows" => [[
                        "startTime" => $deliveryStart,
                        "endTime"   => $deliveryEnd
                    ]]
                ]],

                //  Employee ride-time cap (30 min)
               "pickupToDeliveryAbsoluteDetourLimit" => "600s",

                "loadDemands" => [
                    "seats" => ["amount" => 1]
                ]
            ];
        }

        /*
        ===============================
        VEHICLES
        ===============================
        */

        $vehicleCount = count($trips);

        // Get max existing route_id
        $maxRouteId = DB::table($trips_table)
    ->selectRaw('MAX(CAST(route_id AS UNSIGNED)) as max_route_id')
    ->value('max_route_id');
        
        $maxRouteId = $maxRouteId ? intval($maxRouteId) : 0;

        $tripType = strtoupper($trips[0]->trip_direction);

        if ($tripType === "LOGIN") {
            [$officeLat, $officeLng] = explode(',', $trips[0]->destination_geolocation);
        } else {
            [$officeLat, $officeLng] = explode(',', $trips[0]->employee_geolocation);
        }

        $vehicles = [];

        for ($i = 1; $i <= $vehicleCount; $i++) {

            $newRouteId = $maxRouteId + $i;

            $vehicle = [
                "label" => (string)$newRouteId,

                // "routeDurationLimit" => [
                //     "maxDuration" => "3600s" // 90 minutes
                // ]
            ];

            if ($tripType === "LOGIN") {

                $vehicle["endWaypoint"] = [
                    "location" => [
                        "latLng" => [
                            "latitude"  => (float)$officeLat,
                            "longitude" => (float)$officeLng
                        ]
                    ]
                ];

            } else {

                $vehicle["startWaypoint"] = [
                    "location" => [
                        "latLng" => [
                            "latitude"  => (float)$officeLat,
                            "longitude" => (float)$officeLng
                        ]
                    ]
                ];
            }

            $vehicles[] = $vehicle;
        }

        /*
        ===============================
        GLOBAL WINDOW
        ===============================
        */

        $minDate = collect($tripDates)->min();
        $maxDate = collect($tripDates)->max();

        $globalStart = $minDate->copy()->startOfDay()->utc()->format('Y-m-d\TH:i:s\Z');
        $globalEnd   = $maxDate->copy()->endOfDay()->utc()->format('Y-m-d\TH:i:s\Z');

        $payload = [
            "model" => [
                "globalStartTime" => $globalStart,
                "globalEndTime"   => $globalEnd,
                "shipments"       => $shipments,
                "vehicles"        => $vehicles
            ]
        ];

        $response = $this->client->post(
            "https://routeoptimization.googleapis.com/v1/projects/{$this->providerId}:optimizeTours",
            [
                "headers" => [
                    "Authorization" => "Bearer " . $this->getRouteOptimizationToken(),
                    "Content-Type"  => "application/json"
                ],
                "json" => $payload
            ]
        );

        return [
            "success" => true,
            "data" => json_decode($response->getBody(), true)
        ];

    } catch (\GuzzleHttp\Exception\ClientException $e) {

        return [
            "success" => false,
            "type" => "CLIENT_ERROR",
            "error" => $e->getResponse()->getBody()->getContents()
        ];

    } catch (\Exception $e) {

        return [
            "success" => false,
            "type" => "GENERAL_ERROR",
            "error" => $e->getMessage()
        ];
    }
}


public function optimizeRoute($trips)
{
    if (!Auth::check()) {
        return redirect('/login');
    }

    $company_id = Auth::user()->company_id;

    $company = DB::table('client_companies')
        ->where('company_id', $company_id)
        ->where('company_status', 0)
        ->first();

    if (!$company) {
        return response()->json([
            'success' => false,
            'message' => "Company Not Found"
        ]);
    }

    $company_name = $company->company_name;
    $trips_table = strtolower(str_replace(' ', '_', $company_name)) . '_trips';

    if ($trips instanceof \Illuminate\Support\Collection) {
        $trips = $trips->values()->all();
    }

    if (empty($trips)) {
        return ["success" => false, "message" => "Trips empty"];
    }

    // ============================================
    // INPUT VALIDATION
    // ============================================
    $validationError = $this->validateTripsData($trips);
    if ($validationError) {
        Log::warning('Trip validation failed', $validationError);
        return [
            "success" => false,
            "message" => $validationError['message'],
            "trip_id" => $validationError['trip_id'] ?? null
        ];
    }

    if (!$this->client) {
        $this->client = new \GuzzleHttp\Client([
            'timeout' => 60,
            'http_errors' => true
        ]);
    }

    try {
        $timezone = config('app.timezone', 'UTC');
        $shipments = [];

        // ============================================
        // BUILD SHIPMENTS FOR SINGLE DAY
        // ============================================
        foreach ($trips as $trip) {
            [$empLat, $empLng]   = explode(',', $trip->employee_geolocation);
            [$destLat, $destLng] = explode(',', $trip->destination_geolocation);

            // ✓ FIX: Use trip_id, not tripID
            $tripId = (string)$trip->trip_id;

            $pickupStart = \Carbon\Carbon::parse(
                $trip->trip_date . ' ' . $trip->boarding_time,
                $timezone
            )->subMinutes(15)->utc()->format('Y-m-d\TH:i:s\Z');

            $pickupEnd = \Carbon\Carbon::parse(
                $trip->trip_date . ' ' . $trip->boarding_time,
                $timezone
            )->addMinutes(15)->utc()->format('Y-m-d\TH:i:s\Z');

            $deliveryStart = \Carbon\Carbon::parse(
                $trip->trip_date . ' ' . $trip->drop_time,
                $timezone
            )->subMinutes(15)->utc()->format('Y-m-d\TH:i:s\Z');

            $deliveryEnd = \Carbon\Carbon::parse(
                $trip->trip_date . ' ' . $trip->drop_time,
                $timezone
            )->addMinutes(15)->utc()->format('Y-m-d\TH:i:s\Z');

            $shipments[] = [
                "label" => $tripId,

                "pickups" => [[
                    "arrivalWaypoint" => [
                        "location" => [
                            "latLng" => [
                                "latitude"  => (float)$empLat,
                                "longitude" => (float)$empLng
                            ]
                        ]
                    ],
                    "duration" => "60s",
                    "timeWindows" => [[
                        "startTime" => $pickupStart,
                        "endTime"   => $pickupEnd
                    ]]
                ]],

                "deliveries" => [[
                    "arrivalWaypoint" => [
                        "location" => [
                            "latLng" => [
                                "latitude"  => (float)$destLat,
                                "longitude" => (float)$destLng
                            ]
                        ]
                    ],
                    "duration" => "60s",
                    "timeWindows" => [[
                        "startTime" => $deliveryStart,
                        "endTime"   => $deliveryEnd
                    ]]
                ]],

                "loadDemands" => [
                    "seats" => ["amount" => 1]
                ]
            ];
        }

        // ============================================
        // SINGLE VEHICLE CONFIGURATION
        // ============================================
        $tripType = strtoupper($trips[0]->trip_direction);  // LOGIN or LOGOUT

        // Get next route ID
        

        // Determine start/end location based on trip direction
        if ($tripType === "LOGIN") {

    // LOGIN → vehicle ends at office
    [$officeLat, $officeLng] = explode(',', $trips[0]->destination_geolocation);

    $vehicle = [
        "endWaypoint" => [
            "location" => [
                "latLng" => [
                    "latitude"  => (float)$officeLat,
                    "longitude" => (float)$officeLng
                ]
            ]
        ]
    ];

} else {

    // LOGOUT → vehicle starts at office
    [$officeLat, $officeLng] = explode(',', $trips[0]->employee_geolocation);

    $vehicle = [
        "startWaypoint" => [
            "location" => [
                "latLng" => [
                    "latitude"  => (float)$officeLat,
                    "longitude" => (float)$officeLng
                ]
            ]
        ]
    ];

}


        // ✓ OPTIMAL: Calculate actual route duration from trip times
        $minBoardingTime = collect($trips)->min('boarding_time');
        $maxDropTime = collect($trips)->max('drop_time');
        $tripDate = $trips[0]->trip_date;

        $startTime = \Carbon\Carbon::parse("$tripDate $minBoardingTime", $timezone);
        $endTime = \Carbon\Carbon::parse("$tripDate $maxDropTime", $timezone);

        // Add 2 hour buffer for travel time between pickups/dropoffs
        $routeDurationSeconds = $endTime->diffInSeconds($startTime) + 7200;

        // ✓ IMPORTANT: Vehicle must accommodate ALL trips in ONE vehicle
        // $vehicle["routeDurationLimit"] = [
        //     "maxDuration" => $routeDurationSeconds . "s"
        // ];

        // $vehicle["loadLimits"] = [
        //     "seats" => [
        //         "maxLoad" => count($trips)  // ALL trips must fit!
        //     ]
        // ];

        // ============================================
        // GLOBAL TIME WINDOW (Single Day)
        // ============================================
        $tripDate = $trips[0]->trip_date;
        
        $globalStart = \Carbon\Carbon::parse("$tripDate 00:00:00", $timezone)
            ->startOfDay()->utc()->format('Y-m-d\TH:i:s\Z');
        
        $globalEnd = \Carbon\Carbon::parse("$tripDate 23:59:59", $timezone)
            ->endOfDay()->utc()->format('Y-m-d\TH:i:s\Z');

        // ============================================
        // BUILD API PAYLOAD
        // ============================================
        $payload = [
            "model" => [
                "globalStartTime" => $globalStart,
                "globalEndTime"   => $globalEnd,
                "shipments"       => $shipments,
                "vehicles"        => [$vehicle]  // Single vehicle!
            ]
        ];

        Log::info('Route optimization request', [
            'trips_count' => count($trips),
           
            'trip_direction' => $tripType,
            'vehicle_capacity' => count($trips),
            'route_duration_seconds' => $routeDurationSeconds,
            'min_boarding_time' => $minBoardingTime,
            'max_drop_time' => $maxDropTime
        ]);

        // ============================================
        // CALL GOOGLE ROUTE OPTIMIZATION API
        // ============================================
        $response = $this->client->post(
            "https://routeoptimization.googleapis.com/v1/projects/{$this->providerId}:optimizeTours",
            [
                "headers" => [
                    "Authorization" => "Bearer " . $this->getRouteOptimizationToken(),
                    "Content-Type"  => "application/json"
                ],
                "json" => $payload
            ]
        );

        $responseData = json_decode($response->getBody(), true);

        // ============================================
        // VALIDATE RESPONSE
        // ============================================
        if (empty($responseData['routes']) || !is_array($responseData['routes'])) {
            Log::error('Invalid optimization response - no routes', [
                'response' => $responseData
            ]);

            return [
                'success' => false,
                'message' => 'Route optimization returned invalid response',
                'details' => $responseData
            ];
        }

        // ✓ CHECK: All trips must be assigned to single vehicle
        if (!empty($responseData['unassignedShipments']) && 
            count($responseData['unassignedShipments']) > 0) {
            
            $unassignedIds = array_map(function ($s) {
                return $s['shipmentLabel'] ?? 'unknown';
            }, $responseData['unassignedShipments']);

            Log::error('Unassigned shipments - trips cannot fit in single vehicle', [
                'unassigned_count' => count($responseData['unassignedShipments']),
                'unassigned_ids' => $unassignedIds,
                'total_trips' => count($trips),
                'reasons' => array_map(function ($s) {
                    return $s['reasons'] ?? [];
                }, $responseData['unassignedShipments'])
            ]);

            return [
                'success' => false,
                'message' => 'ERROR: Cannot fit all trips in single vehicle',
                'unassigned_count' => count($responseData['unassignedShipments']),
                'unassigned_trip_ids' => $unassignedIds
            ];
        }

        Log::info('Route optimization success', [
            'trips_count' => count($trips),
            'routes_assigned' => count($responseData['routes']),
          
        ]);

        // ============================================
        // RETURN OPTIMIZED ROUTE DATA
        // ============================================
        return [
            "success" => true,
            "data" => $responseData,
           
            "trip_direction" => $tripType
        ];

    } catch (\GuzzleHttp\Exception\ClientException $e) {
        $errorBody = $e->getResponse()->getBody()->getContents();
        
        Log::error('Route optimization API error', [
            'error' => $errorBody,
            'trips_count' => count($trips),
            'status_code' => $e->getResponse()->getStatusCode()
        ]);

        return [
            "success" => false,
            "type" => "API_ERROR",
            "message" => "Google API error",
            "error" => $errorBody
        ];

    } catch (\Exception $e) {
        Log::error('Route optimization general error', [
            'error' => $e->getMessage(),
            'trace' => $e->getTraceAsString(),
            'trips_count' => count($trips)
        ]);

        return [
            "success" => false,
            "type" => "GENERAL_ERROR",
            "message" => $e->getMessage()
        ];
    }
}

// ============================================
// VALIDATION HELPER
// ============================================
private function validateTripsData($trips)
{
    foreach ($trips as $trip) {
        // Check required fields
        $requiredFields = [
            'trip_id', 
            'employee_geolocation', 
            'destination_geolocation', 
            'trip_date', 
            'boarding_time', 
            'drop_time', 
            'trip_direction'
        ];

        foreach ($requiredFields as $field) {
            if (empty($trip->$field)) {
                return [
                    'message' => "Trip missing required field: $field",
                    'trip_id' => $trip->trip_id ?? 'unknown'
                ];
            }
        }


     $geo = trim($trip->employee_geolocation);        // remove start/end spaces
$geo = preg_replace('/\s+/', '', $geo);          // remove ALL spaces

if (!preg_match('/^-?\d+(\.\d+)?,-?\d+(\.\d+)?$/', $geo)) {
    return [
        'message' => "Invalid employee_geolocation format for trip {$trip->trip_id}",
        'trip_id' => $trip->trip_id
    ];
}
$dest = trim($trip->destination_geolocation);
$dest = preg_replace('/\s+/', '', $dest);
        if (!preg_match('/^-?\d+(\.\d+)?,-?\d+(\.\d+)?$/', $dest)) {
            return [
                'message' => "Invalid destination_geolocation format for trip {$trip->trip_id}",
                'trip_id' => $trip->trip_id
            ];
        }

        // Validate time format (HH:ii:ss)
        if (!preg_match('/^\d{2}:\d{2}:\d{2}$/', $trip->boarding_time)) {
            return [
                'message' => "Invalid boarding_time format for trip {$trip->trip_id}",
                'trip_id' => $trip->trip_id
            ];
        }

        if (!preg_match('/^\d{2}:\d{2}:\d{2}$/', $trip->drop_time)) {
            return [
                'message' => "Invalid drop_time format for trip {$trip->trip_id}",
                'trip_id' => $trip->trip_id
            ];
        }

        // Validate trip direction
        $direction = strtoupper($trip->trip_direction);
        if ($direction !== 'LOGIN' && $direction !== 'LOGOUT') {
            return [
                'message' => "Invalid trip_direction for trip {$trip->trip_id}. Must be LOGIN or LOGOUT",
                'trip_id' => $trip->trip_id
            ];
        }
    }

    return null; // All valid
}

public function generateConsumerJwt($tripID)
{
    try {

        $keyPath = storage_path('app/google-service-account.json');

        if (!file_exists($keyPath)) {
            return [
                'status' => false,
                'message' => 'Service account file not found'
            ];
        }

        $serviceAccount = json_decode(
            file_get_contents($keyPath),
            true
        );
 
        $privateKey = $serviceAccount['private_key'] ?? null;
        $serviceAccountEmail = $serviceAccount['client_email'] ?? null;
        $privateKeyId = $serviceAccount['private_key_id'] ?? null;

        if (!$privateKey || !$serviceAccountEmail) {
            return [
                'status' => false,
                'message' => 'Invalid service account credentials'
            ];
        }

        $now = time();
        $exp = $now + 3600;

        $payload = [
            'iss' => $serviceAccountEmail,
            'sub' => $serviceAccountEmail,
            'aud' => 'https://fleetengine.googleapis.com/',
            'iat' => $now,
            'exp' => $exp,
            'authorization' => [
                'tripid' => $tripID
            ]
        ];

        $jwt = JWT::encode(
            $payload,
            $privateKey,
            'RS256',
            $privateKeyId
        );

        return [
            'status' => true,
            'token' => $jwt,
            'expiresInSeconds' => 3600,
            'expirationTime' => $exp
        ];

    } catch (\Exception $e) {
dd($e->getMessage());
        \Log::error('Fleet JWT Generation Error: ' . $e->getMessage());

        return [
            'status' => false,
            'message' => 'Failed to generate JWT token',
            'error' => $e->getMessage()
        ];
    }
}


public function generateVendorJwt($vehicleId)
{
    try {

        $keyPath = storage_path('app/google-service-account.json');

        if (!file_exists($keyPath)) {
            return [
                'status' => false,
                'message' => 'Service account file not found'
            ];
        }

        $serviceAccount = json_decode(
            file_get_contents($keyPath),
            true
        );
 
        $privateKey = $serviceAccount['private_key'] ?? null;
        $serviceAccountEmail = $serviceAccount['client_email'] ?? null;
        $privateKeyId = $serviceAccount['private_key_id'] ?? null;

        if (!$privateKey || !$serviceAccountEmail) {
            return [
                'status' => false,
                'message' => 'Invalid service account credentials'
            ];
        }

        $now = time();
        $exp = $now + 3600;

        $payload = [
            'iss' => $serviceAccountEmail,
            'sub' => $serviceAccountEmail,
            'aud' => 'https://fleetengine.googleapis.com/',
            'iat' => $now,
            'exp' => $exp,
            'authorization' => [
                'vehicleid' => $vehicleId
            ]
        ];

        $jwt = JWT::encode(
            $payload,
            $privateKey,
            'RS256',
            $privateKeyId
        );

        return [
            'status' => true,
            'token' => $jwt,
            'expiresInSeconds' => 3600,
            'expirationTime' => $exp
        ];

    } catch (\Exception $e) {
dd($e->getMessage());
        \Log::error('Fleet JWT Generation Error: ' . $e->getMessage());

        return [
            'status' => false,
            'message' => 'Failed to generate JWT token',
            'error' => $e->getMessage()
        ];
    }
}
}