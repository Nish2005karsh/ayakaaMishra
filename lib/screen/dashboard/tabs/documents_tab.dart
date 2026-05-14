import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../bloc/document/document_bloc.dart';
import '../../../bloc/document/document_event.dart';
import '../../../bloc/document/document_state.dart';
import '../../../const/app_colors.dart';
import '../../../model/document_model.dart';

class DocumentsTab extends StatefulWidget {
  const DocumentsTab({super.key});

  @override
  State<DocumentsTab> createState() => _DocumentsTabState();
}

class _DocumentsTabState extends State<DocumentsTab> {
  @override
  void initState() {
    super.initState();
    context.read<DocumentBloc>().add(const LoadDocuments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        title: Text('Documents',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.surface)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.surface),
            onPressed: () =>
                context.read<DocumentBloc>().add(const RefreshDocuments()),
          ),
        ],
      ),
      body: BlocBuilder<DocumentBloc, DocumentState>(
        builder: (context, state) {
          if (state is DocumentLoading) return _LoadingView();
          if (state is DocumentError) return _ErrorView(message: state.message);
          if (state is DocumentsLoaded) return _LoadedView(state: state);
          return _LoadingView();
        },
      ),
    );
  }
}

// ── LOADING ──────────────────────────────────
class _LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

// ── ERROR ─────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

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
              onPressed: () =>
                  context.read<DocumentBloc>().add(const LoadDocuments()),
              icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryDark),
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

// ── LOADED ────────────────────────────────────
class _LoadedView extends StatelessWidget {
  final DocumentsLoaded state;
  const _LoadedView({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Summary banner
        _SummaryBanner(
            uploaded: state.uploadedCount, total: state.totalCount),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            separatorBuilder: (_, index) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _DocCard(item: state.items[i]),
          ),
        ),
      ],
    );
  }
}

// ── SUMMARY BANNER ────────────────────────────
class _SummaryBanner extends StatelessWidget {
  final int uploaded;
  final int total;
  const _SummaryBanner({required this.uploaded, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDark,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Text('$uploaded / $total',
                style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary)),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Documents Uploaded',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.surface)),
                Text('${total - uploaded} missing or pending',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.surface.withValues(alpha: 0.5))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── DOC CARD ──────────────────────────────────
class _DocCard extends StatelessWidget {
  final DocumentItem item;
  const _DocCard({required this.item});

  Color get _statusColor {
    return switch (item.status) {
      DocumentStatus.approved    => AppColors.success,
      DocumentStatus.pending     => Colors.orange,
      DocumentStatus.rejected    => AppColors.error,
      DocumentStatus.notUploaded => AppColors.textSecondary,
    };
  }

  IconData get _statusIcon {
    return switch (item.status) {
      DocumentStatus.approved    => Icons.check_circle_rounded,
      DocumentStatus.pending     => Icons.hourglass_bottom_rounded,
      DocumentStatus.rejected    => Icons.cancel_rounded,
      DocumentStatus.notUploaded => Icons.upload_file_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              color: _statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_statusIcon, color: _statusColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name.docName,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                if (item.expiryDate != null && item.expiryDate!.isNotEmpty)
                  Text('Expiry: ${item.expiryDate}',
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: item.status == DocumentStatus.rejected
                              ? AppColors.error
                              : AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(item.status.label,
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _statusColor)),
              ),
              // Upload for missing/pending/rejected, Re-upload for approved
              ...[
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => context.push('/documents/upload', extra: {
                    'docId': item.name.docId,
                    'docName': item.name.docName,
                    'fields': item.name.fields,
                  }),
                  child: Row(
                    children: [
                      Text(
                        item.status == DocumentStatus.approved
                            ? 'Re-upload'
                            : 'Upload',
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: item.status == DocumentStatus.approved
                                ? AppColors.textSecondary
                                : AppColors.primaryDark),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: item.status == DocumentStatus.approved
                              ? AppColors.textSecondary
                              : AppColors.primaryDark),
                    ],
                  ),
                ),
              ],
              // View button — shown for ANY doc that has a file path,
              // including expired (rejected) ones so driver can still see it.
              if (item.detail?.fullImageUrl != null) ...[
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => context.push('/documents/preview', extra: {
                    'imageUrl': item.detail!.fullImageUrl!,
                    'docName': item.name.docName,
                  }),
                  child: Row(
                    children: [
                      Text('View',
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark)),
                      const SizedBox(width: 2),
                      const Icon(Icons.visibility_rounded,
                          size: 11, color: AppColors.primaryDark),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
