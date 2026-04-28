import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_event.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_session.dart';
import '../../../widget/backend_chip.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ProfileHeader(),
            const SizedBox(height: 20),
            _InfoSection(),
            const SizedBox(height: 16),
            _SettingsSection(),
            const SizedBox(height: 24),
            _LogoutButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── PROFILE HEADER ────────────────────────────
class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name =
        AppSession.driverName.isNotEmpty ? AppSession.driverName : 'Driver';
    final initial = name[0].toUpperCase();
    return Container(
      color: AppColors.primaryDark,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          24, MediaQuery.of(context).padding.top + 8, 24, 32),
      child: Column(
        children: [
          // Top bar: title + notification only (data is real — chip removed)
          Row(
            children: [
              Text('Profile',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.surface)),
              const Spacer(),
              const NotificationIcon(),
            ],
          ),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.primary,
            child: Text(initial,
                style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark)),
          ),
          const SizedBox(height: 14),
          Text(name,
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.surface)),
          const SizedBox(height: 4),
          Text('Driver ID: ${AppSession.driverId}',
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.surface.withValues(alpha: 0.5))),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
            ),
            child: Text('Company ID: ${AppSession.companyId}',
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ── INFO SECTION ──────────────────────────────
class _InfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Driver Info',
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary)),
            ),
            _InfoRow(
                icon: Icons.badge_rounded,
                label: 'Driver ID',
                value: AppSession.driverId.toString()),
            _InfoRow(
                icon: Icons.business_rounded,
                label: 'Company ID',
                value: AppSession.companyId.toString()),
            _InfoRow(
                icon: Icons.group_rounded,
                label: 'Vendor ID',
                value: AppSession.vendorId.toString()),
            _InfoRow(
                icon: Icons.person_rounded,
                label: 'User ID',
                value: AppSession.userId.toString(),
                isLast: true),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final bool isLast;
  const _InfoRow(
      {required this.icon,
      required this.label,
      required this.value,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textSecondary)),
              const Spacer(),
              Text(value,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 46, color: AppColors.divider),
      ],
    );
  }
}

// ── SETTINGS SECTION ──────────────────────────
class _SettingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Settings',
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary)),
            ),
            _SettingsTile(
              icon: Icons.directions_car_rounded,
              label: 'Vehicle Registration',
              onTap: () => context.push('/vehicle-registration'),
            ),
            _SettingsTile(
              icon: Icons.folder_rounded,
              label: 'Documents',
              // Documents is the tab — switch to it by popping to dashboard
              onTap: () => _showComingSoon(context, 'Documents'),
            ),
            _SettingsTile(
              icon: Icons.notifications_rounded,
              label: 'Notifications',
              onTap: () => _showComingSoon(context, 'Notifications'),
            ),
            _SettingsTile(
              icon: Icons.help_rounded,
              label: 'Help & Support',
              onTap: () => _showComingSoon(context, 'Help & Support'),
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$feature — coming soon',
          style: GoogleFonts.poppins(fontSize: 13)),
      backgroundColor: AppColors.primaryDark,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
    ));
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLast;
  const _SettingsTile(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primaryDark),
          ),
          title: Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary)),
          trailing: const Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: AppColors.textSecondary),
          onTap: onTap,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 68, color: AppColors.divider),
      ],
    );
  }
}

// ── LOGOUT ────────────────────────────────────
class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          context.read<AuthBloc>().add(const LogoutRequested());
          context.go('/login');
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: AppColors.error.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout_rounded,
                  color: AppColors.error, size: 20),
              const SizedBox(width: 10),
              Text('Logout',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.error)),
            ],
          ),
        ),
      ),
    );
  }
}
