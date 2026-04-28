import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../bloc/document/document_bloc.dart';
import '../../../bloc/document/document_state.dart';
import '../../../bloc/trip/trip_bloc.dart';
import '../../../bloc/trip/trip_event.dart';
import '../../../bloc/trip/trip_state.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_session.dart';
import '../../../model/trip_model.dart';
import '../../../provider/availability_provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    // Kick off trips load if not already loaded (shared BLoC with Trips tab)
    final tripState = context.read<TripBloc>().state;
    if (tripState is TripInitial) {
      context.read<TripBloc>().add(const LoadTrips());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AvailabilityProvider>(
      builder: (context, availability, child) {
        // Show error snackbar whenever the provider sets an error
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (availability.errorMessage != null &&
              availability.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(availability.errorMessage!,
                  style: GoogleFonts.poppins(fontSize: 13)),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 4),
            ));
          }
        });

        return Column(
        children: [
          _Header(
            isOnline: availability.isOnline,
            isLoading: availability.isLoading,
            onToggle: availability.toggle,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats — real data from both BLoCs
                  BlocBuilder<TripBloc, TripState>(
                    builder: (context, tripState) =>
                        BlocBuilder<DocumentBloc, DocumentState>(
                      builder: (context, docState) {
                        final todayTrips = tripState is TripsLoaded
                            ? tripState.result.upcoming.length +
                                tripState.result.ongoing.length
                            : 0;
                        final completed = tripState is TripsLoaded
                            ? tripState.result.completed.length
                            : 0;
                        final pendingDocs = docState is DocumentsLoaded
                            ? docState.totalCount - docState.uploadedCount
                            : 0;
                        return _StatsRow(
                          todayTrips: todayTrips,
                          completed: completed,
                          pendingDocs: pendingDocs,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  _QuickActions(),
                  const SizedBox(height: 24),
                  // Today's trips — real data from TripBloc
                  BlocBuilder<TripBloc, TripState>(
                    builder: (context, state) {
                      if (state is TripLoading || state is TripInitial) {
                        return _TripsShimmer();
                      }
                      if (state is TripsLoaded) {
                        final upcoming = state.result.upcoming.take(2).toList();
                        return _UpcomingSection(trips: upcoming);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );   // closes Column (return value)
      },   // closes builder block
    );     // closes Consumer
  }
}

// ── DARK HEADER ──────────────────────────────
class _Header extends StatelessWidget {
  final bool isOnline;
  final bool isLoading;
  final VoidCallback onToggle;
  const _Header({
    required this.isOnline,
    required this.isLoading,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDark,
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 16, 20, 24),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary,
                child: Text(
                  AppSession.driverName.isNotEmpty
                      ? AppSession.driverName[0].toUpperCase()
                      : 'D',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${AppSession.driverName.isNotEmpty ? AppSession.driverName : 'Driver'} 👋',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.surface,
                      ),
                    ),
                    Text(
                      'Company ID: ${AppSession.companyId}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.surface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.surface),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: isLoading ? null : onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isOnline
                    ? AppColors.primary
                    : AppColors.surface.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isOnline
                      ? AppColors.primary
                      : AppColors.surface.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.primary),
                    )
                  else ...[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isOnline ? AppColors.primaryDark : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isOnline ? 'You are ONLINE' : 'You are OFFLINE',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isOnline
                            ? AppColors.primaryDark
                            : AppColors.surface,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      isOnline
                          ? Icons.toggle_on_rounded
                          : Icons.toggle_off_rounded,
                      size: 28,
                      color: isOnline ? AppColors.primaryDark : Colors.grey,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── STATS ROW — real data ─────────────────────
class _StatsRow extends StatelessWidget {
  final int todayTrips;
  final int completed;
  final int pendingDocs;
  const _StatsRow({
    required this.todayTrips,
    required this.completed,
    required this.pendingDocs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          label: "Today's Trips",
          value: '$todayTrips',
          icon: Icons.route_rounded,
        ),
        const SizedBox(width: 12),
        _StatCard(
          label: 'Completed',
          value: '$completed',
          icon: Icons.check_circle_outline_rounded,
        ),
        const SizedBox(width: 12),
        _StatCard(
          label: 'Pending Docs',
          value: '$pendingDocs',
          icon: Icons.folder_open_rounded,
          alert: pendingDocs > 0,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool alert;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.alert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon,
                size: 20,
                color: alert ? AppColors.error : AppColors.primary),
            const SizedBox(height: 8),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

// ── QUICK ACTIONS ─────────────────────────────
class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions',
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.4,
          children: [
            _ActionTile(
              icon: Icons.directions_car_rounded,
              label: 'Register Vehicle',
              onTap: () => context.push('/vehicle-registration'),
            ),
            _ActionTile(
              icon: Icons.folder_rounded,
              label: 'My Documents',
              onTap: () => _showTabHint(context, 'Documents'),
            ),
            _ActionTile(
              icon: Icons.history_rounded,
              label: 'Trip History',
              onTap: () => _showTabHint(context, 'Trips'),
            ),
            _ActionTile(
              icon: Icons.headset_mic_rounded,
              label: 'Support',
              onTap: () => _showComingSoon(context, 'Support'),
            ),
          ],
        ),
      ],
    );
  }

  void _showTabHint(BuildContext context, String tab) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Tap the $tab tab at the bottom to navigate',
          style: GoogleFonts.poppins(fontSize: 13)),
      backgroundColor: AppColors.primaryDark,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$feature — coming soon',
          style: GoogleFonts.poppins(fontSize: 13)),
      backgroundColor: AppColors.primaryDark,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: AppColors.primaryDark),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                  maxLines: 2),
            ),
          ],
        ),
      ),
    );
  }
}

// ── UPCOMING TRIPS — real data ────────────────
class _UpcomingSection extends StatelessWidget {
  final List<TripModel> trips;
  const _UpcomingSection({required this.trips});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Today's Trips",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const Spacer(),
            TextButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tap the Trips tab at the bottom',
                      style: GoogleFonts.poppins(fontSize: 13)),
                  backgroundColor: AppColors.primaryDark,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              child: Text('View all',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (trips.isEmpty)
          _EmptyTrips()
        else
          ...trips.map((t) => _HomeTripCard(trip: t)),
      ],
    );
  }
}

class _EmptyTrips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.directions_car_outlined,
              size: 40, color: AppColors.border),
          const SizedBox(height: 10),
          Text('No upcoming trips',
              style: GoogleFonts.poppins(
                  fontSize: 14, color: AppColors.textSecondary)),
          Text('Go online to receive trips',
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _HomeTripCard extends StatelessWidget {
  final TripModel trip;
  const _HomeTripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/trips/detail', extra: trip),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.directions_car_rounded,
                  color: AppColors.primaryDark, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trip.officeName,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(
                      '${trip.tripDate}  ·  ${trip.formattedTime}  ·  ${trip.distanceLabel}',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(trip.direction.toUpperCase(),
                  style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── LOADING SHIMMER ───────────────────────────
class _TripsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Today's Trips",
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        ...List.generate(
          2,
          (_) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.shimmer,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}
