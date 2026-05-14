import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../const/app_colors.dart';

class DocumentPreviewScreen extends StatelessWidget {
  final String imageUrl;
  final String docName;

  const DocumentPreviewScreen({
    super.key,
    required this.imageUrl,
    required this.docName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.surface),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('/dashboard'),
        ),
        title: Text(
          docName,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.surface,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                          : null,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Loading document…',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.surface.withValues(alpha: 0.6)),
                    ),
                  ],
                ),
              );
            },
            errorBuilder: (context, error, stack) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.broken_image_rounded,
                    size: 56, color: AppColors.textSecondary),
                const SizedBox(height: 12),
                Text(
                  'Could not load document image.',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
