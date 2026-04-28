import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Orange chip shown in AppBar of screens not yet connected to real API data.
// Remove from a screen once it is fully integrated.
class BackendChip extends StatelessWidget {
  const BackendChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 11, color: Colors.orange),
          const SizedBox(width: 4),
          Text(
            'Not integrated',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

// Notification bell with a lime-green dot indicator.
class NotificationIcon extends StatelessWidget {
  final Color iconColor;
  const NotificationIcon({super.key, this.iconColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(Icons.notifications_outlined, color: iconColor, size: 24),
          Positioned(
            right: -1,
            top: -1,
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: const Color(0xFFCAFF00),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
