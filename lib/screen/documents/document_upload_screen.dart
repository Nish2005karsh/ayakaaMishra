import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../bloc/document/document_bloc.dart';
import '../../bloc/document/document_event.dart';
import '../../const/app_colors.dart';
import '../../data/repository/document_repository.dart';
import '../../model/document_model.dart';

class DocumentUploadScreen extends StatefulWidget {
  final int docId;
  final String docName;
  final List<DocumentField> fields;

  const DocumentUploadScreen({
    super.key,
    required this.docId,
    required this.docName,
    required this.fields,
  });

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = DocumentRepository();
  final _picker = ImagePicker();

  // Stores field values: field.name → value (String or base64)
  final Map<String, String> _values = {};
  // Stores picked file paths for preview
  final Map<String, String> _filePaths = {};

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    for (final f in widget.fields) {
      _values[f.name] = '';
    }
    // If the API didn't provide a file field, add a default one
    if (!widget.fields.any((f) => f.type == 'file')) {
      _values['doc_data'] = '';
    }
  }

  Future<void> _pickImage(String fieldName) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked == null) return;

    final bytes = await File(picked.path).readAsBytes();
    final ext = picked.path.split('.').last.toLowerCase();
    final mime = ext == 'png' ? 'image/png' : 'image/jpeg';
    final base64Str = 'data:$mime;base64,${base64Encode(bytes)}';

    setState(() {
      _values[fieldName] = base64Str;
      _filePaths[fieldName] = picked.path;
    });
  }

  Future<void> _pickDate(String fieldName) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 365)),
      firstDate: now,
      lastDate: DateTime(2040),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryDark,
            onPrimary: AppColors.primary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _values[fieldName] =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate required fields
    for (final f in widget.fields) {
      if (f.required && (_values[f.name]?.isEmpty ?? true)) {
        _showSnack('${f.label} is required', isError: true);
        return;
      }
    }

    // Block submission if ALL fields are empty — prevents accidental silent uploads
    final allEmpty = _values.values.every((v) => v.isEmpty);
    if (allEmpty && widget.fields.isNotEmpty) {
      _showSnack('Please fill in at least one field before uploading.',
          isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    final fields = widget.fields
        .map((f) => {'name': f.name, 'value': _values[f.name] ?? ''})
        .toList();

    // Include the auto-added doc_data file field if it was picked
    if (!widget.fields.any((f) => f.type == 'file') &&
        (_values['doc_data']?.isNotEmpty ?? false)) {
      fields.add({'name': 'doc_data', 'value': _values['doc_data']!});
    }

    try {
      final status = await _repo.uploadDocument(
        docId: widget.docId,
        fields: fields,
      );

      if (!mounted) return;

      if (status.isSuccess) {
        _showSnack('Document uploaded successfully!', isError: false);
        // Refresh documents list in the parent BLoC
        context.read<DocumentBloc>().add(const RefreshDocuments());
        await Future.delayed(const Duration(milliseconds: 600));
        if (mounted) {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/dashboard');
          }
        }
      } else {
        _showSnack(status.message, isError: true);
      }
    } catch (e) {
      if (mounted) _showSnack('Upload failed. Check your connection.', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnack(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.poppins(fontSize: 13)),
      backgroundColor: isError ? AppColors.error : AppColors.success,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.fields.isEmpty &&
                        widget.fields.any((f) => f.type == 'file'))
                      _EmptyFields()
                    else ...[
                      ...widget.fields.map((f) => _buildField(f)),
                      // If API has no file field, show a default document image picker
                      if (!widget.fields.any((f) => f.type == 'file')) ...[
                        const SizedBox(height: 4),
                        _buildDefaultFileField(),
                      ],
                      const SizedBox(height: 32),
                      _SubmitButton(
                        isLoading: _isSubmitting,
                        onTap: _submit,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.primaryDark,
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 12, 20, 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.canPop()
                ? context.pop()
                : context.go('/dashboard'),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Upload Document',
                    style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.surface)),
                Text(widget.docName,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(DocumentField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(field.label,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary)),
              if (field.required)
                Text(' *',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error)),
            ],
          ),
          const SizedBox(height: 8),
          switch (field.type) {
            'file' => _FileField(
                fieldName: field.name,
                filePath: _filePaths[field.name],
                onPick: () => _pickImage(field.name),
              ),
            'date' => _DateField(
                value: _values[field.name] ?? '',
                onTap: () => _pickDate(field.name),
              ),
            'enum' => _EnumField(
                value: _values[field.name],
                options: field.options,
                onChanged: (v) => setState(() => _values[field.name] = v),
              ),
            _ => _TextField(
                value: _values[field.name] ?? '',
                onChanged: (v) => setState(() => _values[field.name] = v),
                required: field.required,
                label: field.label,
              ),
          },
        ],
      ),
    );
  }

  // Default file picker shown when the API provides no file field for this doc
  Widget _buildDefaultFileField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Document Image',
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          _FileField(
            fieldName: 'doc_data',
            filePath: _filePaths['doc_data'],
            onPick: () => _pickImage('doc_data'),
          ),
        ],
      ),
    );
  }
}

// ── FILE PICK FIELD ───────────────────────────
class _FileField extends StatelessWidget {
  final String fieldName;
  final String? filePath;
  final VoidCallback onPick;
  const _FileField({required this.fieldName, this.filePath, required this.onPick});

  @override
  Widget build(BuildContext context) {
    if (filePath != null && filePath!.isNotEmpty) {
      return GestureDetector(
        onTap: onPick,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(
                File(filePath!),
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 8, right: 8,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit_rounded,
                    color: AppColors.primary, size: 16),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onPick,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.upload_rounded,
                  color: AppColors.primaryDark, size: 24),
            ),
            const SizedBox(height: 10),
            Text('Tap to pick image',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
            Text('JPG, PNG supported',
                style: GoogleFonts.poppins(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

// ── DATE FIELD ────────────────────────────────
class _DateField extends StatelessWidget {
  final String value;
  final VoidCallback onTap;
  const _DateField({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 12),
            Text(
              value.isEmpty ? 'Select date' : value,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: value.isEmpty ? FontWeight.w400 : FontWeight.w600,
                color: value.isEmpty
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down_rounded,
                color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

// ── ENUM DROPDOWN ─────────────────────────────
class _EnumField extends StatelessWidget {
  final String? value;
  final List<String> options;
  final void Function(String) onChanged;
  const _EnumField(
      {required this.value, required this.options, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value?.isEmpty ?? true ? null : value,
          isExpanded: true,
          hint: Text('Select option',
              style: GoogleFonts.poppins(
                  color: AppColors.textSecondary, fontSize: 14)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary),
          items: options
              .map((o) => DropdownMenuItem(
                    value: o,
                    child: Text(o,
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: AppColors.textPrimary)),
                  ))
              .toList(),
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
    );
  }
}

// ── TEXT FIELD ────────────────────────────────
class _TextField extends StatelessWidget {
  final String value;
  final void Function(String) onChanged;
  final bool required;
  final String label;
  const _TextField({
    required this.value,
    required this.onChanged,
    required this.required,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      style: GoogleFonts.poppins(fontSize: 15, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Enter $label',
        hintStyle: GoogleFonts.poppins(
            color: AppColors.textSecondary, fontSize: 14),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: AppColors.primaryDark, width: 1.8)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.error)),
      ),
      validator: required
          ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
          : null,
    );
  }
}

// ── SUBMIT BUTTON ─────────────────────────────
class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  const _SubmitButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: AppColors.primaryDark),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload_rounded,
                      size: 20, color: AppColors.primaryDark),
                  const SizedBox(width: 10),
                  Text('Upload Document',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark)),
                ],
              ),
      ),
    );
  }
}

class _EmptyFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(Icons.info_outline_rounded,
                size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text('No fields defined for this document.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
