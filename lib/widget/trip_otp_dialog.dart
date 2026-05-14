import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../const/app_colors.dart';
import '../data/repository/trip_repository.dart';
import '../model/api_response_model.dart';

/// Reusable OTP verification dialog for a single passenger.
/// Used in both TripDetailScreen and TripNavigationScreen.
class TripOtpDialog extends StatefulWidget {
  final String empName;
  final String tripId;
  final int empId;

  const TripOtpDialog({
    super.key,
    required this.empName,
    required this.tripId,
    required this.empId,
  });

  @override
  State<TripOtpDialog> createState() => _TripOtpDialogState();
}

class _TripOtpDialogState extends State<TripOtpDialog> {
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
      final ApiStatus status = await _repo.verifyTripOtp(
        tripId: widget.tripId,
        empId: widget.empId,
        otp: otp,
      );
      if (!mounted) return;
      if (status.isSuccess) {
        setState(() => _verified = true);
      } else {
        setState(() => _error = status.message.isNotEmpty ? status.message : 'Invalid OTP');
      }
    } catch (e) {
      if (!mounted) return;
      String msg = 'Network error. Check your connection.';
      if (e.toString().contains('timeout')) {
        msg = 'Request timed out. Try again.';
      } else if (e.toString().contains('SocketException')) {
        msg = 'No internet connection.';
      }
      setState(() => _error = msg);
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
      content: _verified ? _SuccessContent(empName: widget.empName) : _InputContent(
        ctrl: _ctrl,
        empName: widget.empName,
        isLoading: _isLoading,
        error: _error,
        onVerify: _verify,
      ),
    );
  }
}

class _InputContent extends StatelessWidget {
  final TextEditingController ctrl;
  final String empName;
  final bool isLoading;
  final String? error;
  final VoidCallback onVerify;

  const _InputContent({
    required this.ctrl,
    required this.empName,
    required this.isLoading,
    required this.error,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
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
                  Text(empName,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.textSecondary)),
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
          controller: ctrl,
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
                borderSide:
                    const BorderSide(color: AppColors.primaryDark, width: 2)),
            errorText: error,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: isLoading ? null : onVerify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor:
                      AppColors.primary.withValues(alpha: 0.6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
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
          width: 64,
          height: 64,
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
