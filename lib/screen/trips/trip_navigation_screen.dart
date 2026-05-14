import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';

import '../../const/app_colors.dart';
import '../../data/repository/trip_repository.dart';
import '../../model/trip_model.dart';
import '../../service/fleet_engine_service.dart';
import '../../service/location_service.dart';
import '../../widget/custom_button.dart';
import '../../widget/trip_otp_dialog.dart';

class TripNavigationScreen extends StatefulWidget {
  final TripModel trip;
  const TripNavigationScreen({super.key, required this.trip});

  @override
  State<TripNavigationScreen> createState() => _TripNavigationScreenState();
}

class _TripNavigationScreenState extends State<TripNavigationScreen> {
  bool _sessionInitialized = false;
  bool _isNavigating = false;
  bool _isSettingRoute = false;
  String? _initError;

  // Waypoint tracking
  StreamSubscription<OnArrivalEvent>? _arrivalSub;
  StreamSubscription<Position>? _proximitySub;
  NavigationWaypoint? _arrivedWaypoint;   // set when driver reaches a stop
  int _completedWaypoints = 0;            // how many stops done so far
  bool _tripCompleted = false;
  final Set<int> _proximityTriggered = {}; // waypoint indices already alerted
  static const double _proximityRadiusMeters = 300;

  List<NavigationWaypoint> get _allWaypoints => _buildWaypoints();

  bool get _isLastWaypoint =>
      _completedWaypoints >= _allWaypoints.length - 1;

  // Matched passenger for current arrived waypoint
  PickupDrop? get _arrivedPassenger {
    if (_arrivedWaypoint == null) return null;
    final idx = _completedWaypoints.clamp(0, widget.trip.pickupDrops.length - 1);
    return widget.trip.pickupDrops.isNotEmpty
        ? widget.trip.pickupDrops[idx]
        : null;
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  // ── INIT ──────────────────────────────────────────────────────────────────
  Future<void> _init() async {
    // google_navigation_flutter is Android/iOS only — not supported on web.
    if (kIsWeb) {
      setState(() => _initError =
          'Navigation is not supported on web.\nPlease use the Android app.');
      return;
    }

    final granted = await LocationService().requestPermission();
    if (!mounted) return;
    if (!granted) {
      setState(() => _initError =
          'Location permission is required for navigation.\nPlease enable it in Settings.');
      return;
    }

    if (!await GoogleMapsNavigator.areTermsAccepted()) {
      final accepted = await GoogleMapsNavigator.showTermsAndConditionsDialog(
        'Navigation Terms', 'Ayakaa',
      );
      if (!mounted) return;
      if (!accepted) {
        setState(() => _initError =
            'Navigation terms must be accepted to use this feature.');
        return;
      }
    }

    await GoogleMapsNavigator.initializeNavigationSession(
      taskRemovedBehavior: TaskRemovedBehavior.continueService,
    );
    if (!mounted) return;
    setState(() => _sessionInitialized = true);
  }

  void _onViewCreated(GoogleNavigationViewController controller) {
    controller.setMyLocationEnabled(true);
  }

  // ── WAYPOINT BUILDER ──────────────────────────────────────────────────────
  LatLng? _parseLatLng(String geocode) {
    if (geocode.isEmpty) return null;
    final parts = geocode.split(',');
    if (parts.length != 2) return null;
    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    if (lat == null || lng == null) return null;
    return LatLng(latitude: lat, longitude: lng);
  }

  List<NavigationWaypoint> _buildWaypoints() {
    final waypoints = <NavigationWaypoint>[];
    for (final emp in widget.trip.pickupDrops) {
      final latLng = _parseLatLng(emp.empGeocode);
      if (latLng != null) {
        waypoints.add(NavigationWaypoint.withLatLngTarget(
          title: emp.empName.isNotEmpty ? emp.empName : 'Passenger',
          target: latLng,
        ));
      }
    }
    return waypoints;
  }

  // ── NAVIGATION CONTROLS ───────────────────────────────────────────────────
  Future<void> _startNavigation() async {
    final waypoints = _buildWaypoints();
    if (waypoints.isEmpty) {
      _showSnack('No GPS coordinates found for passengers on this trip.');
      return;
    }

    setState(() => _isSettingRoute = true);
    try {
      final status = await GoogleMapsNavigator.setDestinations(
        Destinations(
          waypoints: waypoints,
          displayOptions: NavigationDisplayOptions(),
        ),
      );
      if (!mounted) return;
      if (status == NavigationRouteStatus.statusOk) {
        await GoogleMapsNavigator.startGuidance();

        // ── Register trip + start GPS reporting in Fleet Engine ───────────
        FleetEngineService().startTrip(widget.trip);

        // ── Subscribe to arrival events ────────────────────────────────────
        _arrivalSub = GoogleMapsNavigator.setOnArrivalListener((event) {
          final passenger = _arrivedPassenger;
          if (passenger != null) {
            TripRepository().recordArrival(
              tripId: widget.trip.tripId,
              empId: passenger.empId,
              actualArrivalTime: DateTime.now().toUtc().toIso8601String(),
            );
          }
          if (mounted) setState(() => _arrivedWaypoint = event.waypoint);
        });

        if (mounted) setState(() => _isNavigating = true);
        _startProximityDetection();
      } else {
        _showSnack('Could not calculate route. Try again in a moment.');
      }
    } catch (e) {
      if (mounted) _showSnack('Navigation error: $e');
    } finally {
      if (mounted) setState(() => _isSettingRoute = false);
    }
  }

  // ── PROXIMITY DETECTION ───────────────────────────────────────────────────

  void _startProximityDetection() {
    _proximitySub?.cancel();
    _proximitySub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 20,
      ),
    ).listen(_checkProximity);
  }

  void _stopProximityDetection() {
    _proximitySub?.cancel();
    _proximitySub = null;
  }

  void _checkProximity(Position pos) {
    if (!_isNavigating) return;
    final nextIndex = _completedWaypoints;
    if (nextIndex >= widget.trip.pickupDrops.length) return;
    if (_proximityTriggered.contains(nextIndex)) return;

    final nextStop = widget.trip.pickupDrops[nextIndex];
    final parts = nextStop.empGeocode.split(',');
    if (parts.length != 2) return;
    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    if (lat == null || lng == null) return;

    final distance = Geolocator.distanceBetween(
      pos.latitude, pos.longitude, lat, lng,
    );

    if (distance <= _proximityRadiusMeters) {
      _proximityTriggered.add(nextIndex);
      debugPrint('Proximity: ${distance.toStringAsFixed(0)}m from ${nextStop.empName}');
      TripRepository().sendProximityAlert(
        tripId: widget.trip.tripId,
        empId: nextStop.empId,
        latitude: pos.latitude,
        longitude: pos.longitude,
        distanceMeters: distance,
      );
    }
  }

  /// Called when driver taps "Next Stop" after arriving at a waypoint.
  /// The SDK advances its internal pointer; we increment our counter.
  Future<void> _continueToNext() async {
    setState(() => _arrivedWaypoint = null);
    await GoogleMapsNavigator.continueToNextDestination();
    if (mounted) setState(() => _completedWaypoints++);

    // Sync next destination with Fleet Engine
    final remaining = widget.trip.pickupDrops
        .skip(_completedWaypoints)
        .map((e) => _parseLatLng(e.empGeocode))
        .whereType<LatLng>()
        .toList();
    FleetEngineService().advanceToWaypoint(
      remaining.isNotEmpty
          ? {'lat': remaining.first.latitude, 'lng': remaining.first.longitude}
          : null,
    );
  }

  /// Called after the last waypoint is confirmed.
  Future<void> _completeTrip() async {
    _stopProximityDetection();
    await GoogleMapsNavigator.stopGuidance();
    FleetEngineService().endTrip();
    _arrivalSub?.cancel();
    if (mounted) {
      setState(() {
        _arrivedWaypoint = null;
        _isNavigating = false;
        _tripCompleted = true;
      });
    }
  }

  Future<void> _stopNavigation() async {
    _stopProximityDetection();
    _arrivalSub?.cancel();
    FleetEngineService().endTrip();
    await GoogleMapsNavigator.stopGuidance();
    if (mounted) {
      setState(() {
        _isNavigating = false;
        _arrivedWaypoint = null;
      });
    }
  }

  Future<void> _handleNoShow() async {
    final passenger = _arrivedPassenger;
    if (passenger == null) return;
    final status = await TripRepository().reportNoShow(
      tripId: widget.trip.tripId,
      empId: passenger.empId,
    );
    if (!mounted) return;
    _showSnack(status.isSuccess
        ? '${passenger.empName} marked as no show'
        : 'Failed: ${status.message}');
    _continueToNext();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.poppins(fontSize: 13)),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _showPassengersSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PassengersSheet(trip: widget.trip),
    );
  }

  @override
  void dispose() {
    _arrivalSub?.cancel();
    if (_sessionInitialized) GoogleMapsNavigator.cleanup();
    super.dispose();
  }

  // ── BUILD ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── MAP / LOADING / ERROR ──────────────────────────────────────────
          if (_sessionInitialized)
            Positioned.fill(
              child: GoogleMapsNavigationView(
                onViewCreated: _onViewCreated,
                initialNavigationUIEnabledPreference:
                    NavigationUIEnabledPreference.automatic,
                initialForceNightMode: NavigationForceNightMode.auto,
              ),
            )
          else if (_initError != null)
            _ErrorView(message: _initError!, onBack: () => context.canPop() ? context.pop() : context.go('/dashboard'))
          else
            const _LoadingView(),

          // ── TOP BAR ───────────────────────────────────────────────────────
          if (_sessionInitialized || _initError != null)
            Positioned(
              top: 0, left: 0, right: 0,
              child: _TopBar(trip: widget.trip),
            ),

          // ── ARRIVAL OVERLAY — shown when driver reaches a stop ─────────────
          if (_sessionInitialized && _arrivedWaypoint != null)
            Positioned(
              left: 16, right: 16,
              bottom: MediaQuery.of(context).padding.bottom + 200,
              child: _ArrivalOverlay(
                waypoint: _arrivedWaypoint!,
                passenger: _arrivedPassenger,
                isLastStop: _isLastWaypoint,
                completedCount: _completedWaypoints,
                totalCount: _allWaypoints.length,
                tripId: widget.trip.tripId,
                onContinue: _continueToNext,
                onComplete: _completeTrip,
                onNoShow: _handleNoShow,
              ),
            ),

          // ── TRIP COMPLETE OVERLAY ─────────────────────────────────────────
          if (_tripCompleted)
            Positioned.fill(
              child: _TripCompleteOverlay(onBack: () => context.canPop() ? context.pop() : context.go('/dashboard')),
            ),

          // ── BOTTOM CONTROLS ───────────────────────────────────────────────
          if (_sessionInitialized && !_tripCompleted)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _BottomControls(
                trip: widget.trip,
                isNavigating: _isNavigating,
                isLoading: _isSettingRoute,
                completedWaypoints: _completedWaypoints,
                totalWaypoints: _allWaypoints.length,
                onStart: _startNavigation,
                onStop: _stopNavigation,
                onViewPassengers: _showPassengersSheet,
              ),
            ),
        ],
      ),
    );
  }
}

// ── ARRIVAL OVERLAY ───────────────────────────────────────────────────────────
/// Appears when the Navigation SDK fires an OnArrivalEvent.
class _ArrivalOverlay extends StatelessWidget {
  final NavigationWaypoint waypoint;
  final PickupDrop? passenger;
  final bool isLastStop;
  final int completedCount;
  final int totalCount;
  final String tripId;
  final VoidCallback onContinue;
  final VoidCallback onComplete;
  final VoidCallback onNoShow;

  const _ArrivalOverlay({
    required this.waypoint,
    required this.passenger,
    required this.isLastStop,
    required this.completedCount,
    required this.totalCount,
    required this.tripId,
    required this.onContinue,
    required this.onComplete,
    required this.onNoShow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on_rounded,
                    color: AppColors.success, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('You\'ve Arrived!',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary)),
                    Text(
                      'Stop ${completedCount + 1} of $totalCount',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 10),

          // Passenger info
          if (passenger != null) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Text(
                    passenger!.empName.isNotEmpty
                        ? passenger!.empName[0].toUpperCase()
                        : 'P',
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(passenger!.empName,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                      if (passenger!.empAddress.isNotEmpty)
                        Text(passenger!.empAddress,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                // Verify OTP button
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => TripOtpDialog(
                      empName: passenger!.empName,
                      tripId: tripId,
                      empId: passenger!.empId,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Verify OTP',
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // No Show button — only shown when there's a passenger
          if (passenger != null) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onNoShow,
                icon: const Icon(Icons.person_off_rounded,
                    size: 18, color: AppColors.error),
                label: Text('No Show',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.error)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],

          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLastStop ? onComplete : onContinue,
              icon: Icon(
                isLastStop
                    ? Icons.check_circle_rounded
                    : Icons.arrow_forward_rounded,
                size: 18,
                color: AppColors.primaryDark,
              ),
              label: Text(
                isLastStop ? 'Complete Trip' : 'Next Stop',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.primaryDark),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isLastStop ? AppColors.success : AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── TRIP COMPLETE OVERLAY ─────────────────────────────────────────────────────
class _TripCompleteOverlay extends StatelessWidget {
  final VoidCallback onBack;
  const _TripCompleteOverlay({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDark,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: AppColors.success, size: 48),
              ),
              const SizedBox(height: 20),
              Text('Trip Completed!',
                  style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.surface)),
              const SizedBox(height: 8),
              Text(
                'All passengers have been picked up.\nGreat job!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.surface.withValues(alpha: 0.6)),
              ),
              const SizedBox(height: 32),
              CustomButton(
                label: 'Back to Dashboard',
                onTap: onBack,
                icon: const Icon(Icons.home_rounded,
                    size: 18, color: AppColors.primaryDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── TOP OVERLAY ───────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final TripModel trip;
  const _TopBar({required this.trip});

  Color get _dirColor =>
      trip.direction.toLowerCase() == 'login'
          ? AppColors.success
          : AppColors.error;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.75), Colors.transparent],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 10, 16, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.canPop()
                ? context.pop()
                : context.go('/dashboard'),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trip.officeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                Text(trip.tripId,
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.6))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _dirColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _dirColor.withValues(alpha: 0.6)),
            ),
            child: Text(trip.direction.toUpperCase(),
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: _dirColor)),
          ),
        ],
      ),
    );
  }
}

// ── BOTTOM CONTROLS ───────────────────────────────────────────────────────────
class _BottomControls extends StatelessWidget {
  final TripModel trip;
  final bool isNavigating;
  final bool isLoading;
  final int completedWaypoints;
  final int totalWaypoints;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onViewPassengers;

  const _BottomControls({
    required this.trip,
    required this.isNavigating,
    required this.isLoading,
    required this.completedWaypoints,
    required this.totalWaypoints,
    required this.onStart,
    required this.onStop,
    required this.onViewPassengers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, -4)),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36, height: 4,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Progress row (shown when navigating)
          if (isNavigating && totalWaypoints > 0) ...[
            Row(
              children: [
                const Icon(Icons.route_rounded,
                    size: 15, color: AppColors.primaryDark),
                const SizedBox(width: 6),
                Text(
                  '$completedWaypoints / $totalWaypoints stops completed',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark),
                ),
                const Spacer(),
                Text(trip.distanceLabel,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: totalWaypoints > 0
                    ? completedWaypoints / totalWaypoints
                    : 0,
                backgroundColor: AppColors.border,
                color: AppColors.primary,
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 14),
          ] else ...[
            Row(
              children: [
                _SummaryChip(
                    icon: Icons.people_rounded,
                    label:
                        '${trip.employeeCount} passenger${trip.employeeCount != 1 ? 's' : ''}'),
                const SizedBox(width: 10),
                _SummaryChip(
                    icon: Icons.route_rounded, label: trip.distanceLabel),
                const SizedBox(width: 10),
                _SummaryChip(
                    icon: Icons.access_time_rounded,
                    label: trip.formattedTime),
              ],
            ),
            const SizedBox(height: 14),
          ],

          CustomButton(
            label: isNavigating ? 'Stop Navigation' : 'Start Navigation',
            isLoading: isLoading,
            color: isNavigating ? AppColors.error : AppColors.primary,
            textColor: isNavigating ? Colors.white : AppColors.primaryDark,
            icon: isNavigating
                ? const Icon(Icons.stop_rounded,
                    size: 18, color: Colors.white)
                : const Icon(Icons.navigation_rounded,
                    size: 18, color: AppColors.primaryDark),
            onTap: isNavigating ? onStop : onStart,
          ),
          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: onViewPassengers,
              icon: const Icon(Icons.people_outline_rounded,
                  size: 18, color: AppColors.primaryDark),
              label: Text(
                'View Passengers & Verify OTP',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SummaryChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: AppColors.primaryDark),
            const SizedBox(width: 5),
            Flexible(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── PASSENGERS BOTTOM SHEET ───────────────────────────────────────────────────
class _PassengersSheet extends StatelessWidget {
  final TripModel trip;
  const _PassengersSheet({required this.trip});

  @override
  Widget build(BuildContext context) {
    final canVerify = trip.status == TripStatus.upcoming ||
        trip.status == TripStatus.ongoing;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36, height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              children: [
                Text('Passengers (${trip.pickupDrops.length})',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded,
                      color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          if (trip.pickupDrops.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text('No passenger details available.',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.textSecondary)),
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.55,
              ),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                shrinkWrap: true,
                itemCount: trip.pickupDrops.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final emp = trip.pickupDrops[i];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.15),
                          child: Text(
                            emp.empName.isNotEmpty
                                ? emp.empName[0].toUpperCase()
                                : 'E',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryDark),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(emp.empName,
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary)),
                              if (emp.empAddress.isNotEmpty)
                                Text(emp.empAddress,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        if (canVerify)
                          GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => TripOtpDialog(
                                empName: emp.empName,
                                tripId: trip.tripId,
                                empId: emp.empId,
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('Verify OTP',
                                  style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryDark)),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ── LOADING ───────────────────────────────────────────────────────────────────
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDark,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 20),
            Text('Initializing Navigation…',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.surface.withValues(alpha: 0.7))),
          ],
        ),
      ),
    );
  }
}

// ── ERROR ─────────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onBack;
  const _ErrorView({required this.message, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDark,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off_rounded,
              size: 56, color: AppColors.error),
          const SizedBox(height: 20),
          Text(message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.surface.withValues(alpha: 0.8))),
          const SizedBox(height: 28),
          CustomButton(
            label: 'Go Back',
            onTap: onBack,
            icon: const Icon(Icons.arrow_back_rounded,
                size: 18, color: AppColors.primaryDark),
          ),
        ],
      ),
    );
  }
}
