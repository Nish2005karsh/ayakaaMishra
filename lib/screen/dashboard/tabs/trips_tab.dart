import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../bloc/trip/trip_bloc.dart';
import '../../../bloc/trip/trip_event.dart';
import '../../../bloc/trip/trip_state.dart';
import '../../../const/app_colors.dart';
import '../../../model/trip_model.dart';

class TripsTab extends StatefulWidget {
  const TripsTab({super.key});

  @override
  State<TripsTab> createState() => _TripsTabState();
}

class _TripsTabState extends State<TripsTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<TripBloc>().add(const LoadTrips());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text('My Trips',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.surface)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.surface),
            onPressed: () =>
                context.read<TripBloc>().add(const RefreshTrips()),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.surface.withValues(alpha: 0.5),
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          isScrollable: false,
          labelStyle:
              GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Ongoing'),
            Tab(text: 'Completed'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: BlocBuilder<TripBloc, TripState>(
        builder: (context, state) {
          if (state is TripLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is TripError) {
            return _ErrorView(
              message: state.message,
              onRetry: () => context.read<TripBloc>().add(const LoadTrips()),
            );
          }
          if (state is TripsLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _TripList(trips: state.result.upcoming, status: TripStatus.upcoming),
                _TripList(trips: state.result.ongoing, status: TripStatus.ongoing),
                _TripList(trips: state.result.completed, status: TripStatus.completed),
                _TripList(trips: state.result.rejected, status: TripStatus.rejected),
              ],
            );
          }
          // Initial state — show loading
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        },
      ),
    );
  }
}

// ── ERROR VIEW ────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded,
                size: 56, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded,
                  color: AppColors.primaryDark),
              label: Text('Retry',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── TRIP LIST ─────────────────────────────────
class _TripList extends StatelessWidget {
  final List<TripModel> trips;
  final TripStatus status;
  const _TripList({required this.trips, required this.status});

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return _EmptyState(status: status);
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trips.length,
      itemBuilder: (_, i) => _TripCard(trip: trips[i]),
    );
  }
}

// ── EMPTY STATE ───────────────────────────────
class _EmptyState extends StatelessWidget {
  final TripStatus status;
  const _EmptyState({required this.status});

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      TripStatus.upcoming   => 'No upcoming trips',
      TripStatus.ongoing    => 'No ongoing trips',
      TripStatus.completed  => 'No completed trips',
      TripStatus.rejected   => 'No rejected trips',
    };
    final sublabel = status == TripStatus.upcoming
        ? 'Go online and trips will appear here'
        : null;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_car_outlined,
              size: 64,
              color: AppColors.border),
          const SizedBox(height: 16),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500)),
          if (sublabel != null) ...[
            const SizedBox(height: 6),
            Text(sublabel,
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.textSecondary)),
          ],
        ],
      ),
    );
  }
}

// ── TRIP CARD ─────────────────────────────────
class _TripCard extends StatelessWidget {
  final TripModel trip;
  const _TripCard({required this.trip});

  Color get _directionColor =>
      trip.direction.toLowerCase() == 'login' ? AppColors.success : AppColors.error;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/trips/detail', extra: trip),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 10,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          children: [
            // ── HEADER ──
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _directionColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: _directionColor.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      trip.direction.toUpperCase(),
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: _directionColor),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(trip.officeName,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.surface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(trip.distanceLabel,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                  ),
                ],
              ),
            ),
            // ── DETAILS ──
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _Row(
                    icon: Icons.calendar_today_rounded,
                    text: '${trip.tripDate}  ·  ${trip.formattedTime}',
                  ),
                  const SizedBox(height: 6),
                  _Row(
                    icon: Icons.location_on_rounded,
                    text: trip.employeeAddress.isNotEmpty
                        ? trip.employeeAddress
                        : 'Pickup location not set',
                  ),
                  const SizedBox(height: 6),
                  _Row(
                    icon: Icons.people_rounded,
                    text:
                        '${trip.employeeCount} passenger${trip.employeeCount != 1 ? 's' : ''}',
                  ),
                  const Divider(height: 18, color: AppColors.divider),
                  Row(
                    children: [
                      const Icon(Icons.tag_rounded,
                          size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(trip.tripId,
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.textSecondary)),
                      ),
                      Row(
                        children: [
                          Text('View Details',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDark)),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              size: 11, color: AppColors.primaryDark),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Row({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppColors.textPrimary)),
        ),
      ],
    );
  }
}
