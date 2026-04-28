import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../const/app_colors.dart';
import '../../data/repository/trip_repository.dart';
import '../../model/trip_model.dart';

class TripDetailScreen extends StatelessWidget {
  final TripModel trip;
  const TripDetailScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _Header(trip: trip),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoCard(trip: trip),
                  const SizedBox(height: 20),
                  _EmployeeSection(trip: trip),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── DARK HEADER ──────────────────────────────
class _Header extends StatelessWidget {
  final TripModel trip;
  const _Header({required this.trip});

  Color get _dirColor =>
      trip.direction.toLowerCase() == 'login' ? AppColors.success : AppColors.error;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDark,
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 12, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.surface, size: 16),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text('Trip Details',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.surface)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _dirColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _dirColor.withValues(alpha: 0.5)),
                ),
                child: Text(trip.direction.toUpperCase(),
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: _dirColor)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(trip.officeName,
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.surface)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(trip.tripId,
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.surface.withValues(alpha: 0.45))),
        ],
      ),
    );
  }
}

// ── INFO CARD ─────────────────────────────────
class _InfoCard extends StatelessWidget {
  final TripModel trip;
  const _InfoCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trip Info',
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 14),
          Row(
            children: [
              _InfoTile(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date',
                  value: trip.tripDate),
              _InfoTile(
                  icon: Icons.access_time_rounded,
                  label: 'Time',
                  value: trip.formattedTime),
              _InfoTile(
                  icon: Icons.route_rounded,
                  label: 'Distance',
                  value: trip.distanceLabel),
            ],
          ),
          const Divider(height: 24, color: AppColors.divider),
          _DetailRow(
              icon: Icons.business_rounded,
              label: 'Office',
              value: trip.officeName),
          const SizedBox(height: 10),
          _DetailRow(
              icon: Icons.location_on_rounded,
              label: 'Pickup Area',
              value: trip.employeeAddress.isNotEmpty
                  ? trip.employeeAddress
                  : 'Not specified'),
          const SizedBox(height: 10),
          _DetailRow(
              icon: Icons.people_rounded,
              label: 'Passengers',
              value:
                  '${trip.employeeCount} passenger${trip.employeeCount != 1 ? 's' : ''}'),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 6),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 10, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 10, color: AppColors.textSecondary)),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ],
        ),
      ],
    );
  }
}

// ── EMPLOYEE SECTION ──────────────────────────
class _EmployeeSection extends StatelessWidget {
  final TripModel trip;
  const _EmployeeSection({required this.trip});

  @override
  Widget build(BuildContext context) {
    if (trip.pickupDrops.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
        ),
        child: Center(
          child: Text('No employee details available',
              style: GoogleFonts.poppins(
                  fontSize: 14, color: AppColors.textSecondary)),
        ),
      );
    }

    final canVerify = trip.status == TripStatus.upcoming ||
        trip.status == TripStatus.ongoing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text('Passengers (${trip.pickupDrops.length})',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
        ),
        ...trip.pickupDrops.map(
          (emp) => _EmployeeCard(
            emp: emp,
            tripId: trip.tripId,
            canVerify: canVerify,
          ),
        ),
      ],
    );
  }
}

// ── EMPLOYEE CARD ─────────────────────────────
class _EmployeeCard extends StatelessWidget {
  final PickupDrop emp;
  final String tripId;
  final bool canVerify;
  const _EmployeeCard(
      {required this.emp, required this.tripId, required this.canVerify});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            child: Text(
              emp.empName.isNotEmpty ? emp.empName[0].toUpperCase() : 'E',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emp.empName,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                if (emp.empAddress.isNotEmpty)
                  Text(emp.empAddress,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (canVerify) ...[
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => _showOtpDialog(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Verify OTP',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showOtpDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _OtpDialog(
        empName: emp.empName,
        tripId: tripId,
        empId: emp.empId,
      ),
    );
  }
}

// ── OTP VERIFY DIALOG ─────────────────────────
class _OtpDialog extends StatefulWidget {
  final String empName;
  final String tripId;
  final int empId;
  const _OtpDialog(
      {required this.empName, required this.tripId, required this.empId});

  @override
  State<_OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<_OtpDialog> {
  final _repo = TripRepository();
  final _ctrl = TextEditingController();
  bool _isLoading = false;
  String? _error;
  bool _verified = false;

  Future<void> _verify() async {
    final otp = _ctrl.text.trim();
    if (otp.isEmpty) {
      setState(() => _error = 'Please enter the OTP');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final status = await _repo.verifyTripOtp(
        tripId: widget.tripId,
        empId: widget.empId,
        otp: otp,
      );
      if (!mounted) return;
      if (status.isSuccess) {
        setState(() => _verified = true);
      } else {
        setState(() => _error = status.message);
      }
    } catch (e) {
      if (mounted) {
        setState(
            () => _error = 'Network error. Check your connection.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.surface,
      contentPadding: const EdgeInsets.all(24),
      content: _verified ? _SuccessContent(empName: widget.empName) : Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.verified_user_rounded,
                    color: AppColors.primaryDark, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Verify OTP',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    Text(widget.empName,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Enter the OTP shown by the passenger:',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          TextField(
            controller: _ctrl,
            keyboardType: TextInputType.number,
            autofocus: true,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
                color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: '------',
              hintStyle: GoogleFonts.poppins(
                  color: AppColors.border, fontSize: 22, letterSpacing: 4),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                      color: AppColors.primaryDark, width: 2)),
              errorText: _error,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel',
                      style: GoogleFonts.poppins(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: 0.6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.primaryDark))
                      : Text('Verify',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuccessContent extends StatelessWidget {
  final String empName;
  const _SuccessContent({required this.empName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle),
          child: const Icon(Icons.check_circle_rounded,
              color: AppColors.success, size: 36),
        ),
        const SizedBox(height: 16),
        Text('OTP Verified!',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        Text('$empName has been verified',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text('Done',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700, color: AppColors.surface)),
          ),
        ),
      ],
    );
  }
}
