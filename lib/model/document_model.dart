import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../const/app_constants.dart';

// Single dynamic field definition from /documentNames → fileds (API typo)
class DocumentField {
  final String type;   // text | date | file | enum
  final String name;
  final String label;
  final bool required;
  final List<String> options; // only for enum type

  const DocumentField({
    required this.type,
    required this.name,
    required this.label,
    required this.required,
    this.options = const [],
  });

  factory DocumentField.fromJson(Map<String, dynamic> j) {
    List<String> opts = [];
    if (j['options'] != null) {
      opts = List<String>.from(j['options'] as List);
    }
    return DocumentField(
      type: j['type']?.toString() ?? 'text',
      name: j['name']?.toString() ?? '',
      label: j['label']?.toString() ?? '',
      required: j['required'] == true || j['required'] == 'true' || j['required'] == 1,
      options: opts,
    );
  }
}

// A document type with its dynamic field definitions.
// The API also embeds a per-driver status as 'documnet_status' (backend typo).
// We store it here so DocumentBloc can use it as fallback when document_details
// returns an empty list.
class DocumentName {
  final int docId;
  final String docName;
  final List<DocumentField> fields;
  // Null when the API doesn't return per-driver status for this doc type.
  final DocumentStatus? embeddedStatus;

  const DocumentName({
    required this.docId,
    required this.docName,
    required this.fields,
    this.embeddedStatus,
  });

  factory DocumentName.fromJson(Map<String, dynamic> j) {
    // 'fileds' is a JSON STRING (API typo). Confirmed structure from logs:
    // {"fields": [{...}, ...]}  — it's a Map with a 'fields' key, NOT a bare List.
    List<DocumentField> fields = [];
    final raw = j['fileds'];
    if (raw != null && raw.toString().isNotEmpty) {
      try {
        final decoded = jsonDecode(raw.toString());
        List<dynamic> fieldsList;
        if (decoded is Map) {
          // Confirmed format: {"fields": [...]}
          fieldsList = (decoded['fields'] as List<dynamic>?) ?? [];
        } else if (decoded is List) {
          fieldsList = decoded;
        } else {
          fieldsList = [];
        }
        fields = fieldsList
            .map((f) => DocumentField.fromJson(f as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('DocumentName fileds parse error: $e');
        fields = [];
      }
    }
    // Parse 'documnet_status' (backend typo for 'document_status').
    // 0 = not uploaded / pending, 1 = uploaded/approved, 2 = rejected.
    DocumentStatus? embeddedStatus;
    final rawStatus = j['documnet_status'] ?? j['document_status'];
    if (rawStatus != null) {
      final s = rawStatus.toString();
      embeddedStatus = switch (s) {
        '1' || 'approved'  => DocumentStatus.approved,
        '2' || 'rejected'  => DocumentStatus.rejected,
        '0' || 'pending'   => DocumentStatus.pending,
        _                  => null,
      };
    }

    return DocumentName(
      docId: j['document_id'] ?? j['doc_id'] ?? 0,
      docName: j['document_name']?.toString() ?? j['doc_name']?.toString() ?? '',
      fields: fields,
      embeddedStatus: embeddedStatus,
    );
  }
}

// A document that the driver has uploaded (from /document_details)
class DocumentDetail {
  final int docId;
  final String docName;
  final DocumentStatus status;
  final String? expiryDate;
  final String? filePath;

  const DocumentDetail({
    required this.docId,
    required this.docName,
    required this.status,
    this.expiryDate,
    this.filePath,
  });

  factory DocumentDetail.fromJson(Map<String, dynamic> j) {
    // API fields (from docs): document_id, doc_data (JSON string),
    // expiry_dt, id_expired, allow_upload.
    // No doc_status field exists — status is derived from allow_upload + id_expired.

    // Parse the doc_data JSON string to extract file path and expiry.
    String? filePath;
    String? expiryDate = j['expiry_dt']?.toString();

    final rawDocData = j['doc_data']?.toString() ?? '';
    if (rawDocData.isNotEmpty && rawDocData != '[]') {
      try {
        final decoded = jsonDecode(rawDocData);
        if (decoded is Map) {
          // File path lives at doc_data.doc_data (confirmed from API docs)
          filePath = decoded['doc_data']?.toString();
          // Expiry might also be inside doc_data
          expiryDate ??= decoded['expiry_dt']?.toString() ??
              decoded['expire_date']?.toString();
        }
      } catch (_) {}
    }

    // Determine status from allow_upload + id_expired + whether a file exists.
    // allow_upload = "false"  → record exists in DB
    //   + has file path       → approved (driver actually uploaded something)
    //   + no file path        → pending  (form record exists but no file yet)
    // allow_upload = "1"      → not uploaded / expired
    // id_expired   = "1"      → uploaded but expired → rejected (re-upload needed)
    final allowUpload = j['allow_upload']?.toString() ?? '1';
    final idExpired   = j['id_expired']?.toString()   ?? 'false';
    final hasFile     = filePath != null && filePath.isNotEmpty;

    DocumentStatus status;
    if (idExpired == '1' || idExpired == 'true') {
      status = DocumentStatus.rejected; // expired → needs re-upload
    } else if (allowUpload == 'false' || allowUpload == '0') {
      // Record exists — but only mark approved if an actual file was uploaded.
      // Docs with all-null form data (no file) show as pending.
      status = hasFile ? DocumentStatus.approved : DocumentStatus.pending;
    } else {
      status = DocumentStatus.notUploaded;
    }

    return DocumentDetail(
      docId: j['document_id'] ?? j['doc_id'] ?? 0,
      docName: j['document_name']?.toString() ?? j['doc_name']?.toString() ?? '',
      status: status,
      expiryDate: (expiryDate?.isEmpty ?? true) ? null : expiryDate,
      filePath: (filePath?.isEmpty ?? true) ? null : filePath,
    );
  }

  /// Full URL ready to pass to Image.network.
  /// Returns null when no file path is available.
  String? get fullImageUrl {
    final path = filePath;
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    // Strip any leading slash so we don't double-up with the base URL
    final cleaned = path.startsWith('/') ? path.substring(1) : path;
    return '${AppConstants.photoBaseUrl}$cleaned';
  }
}

enum DocumentStatus { notUploaded, pending, approved, rejected }

extension DocumentStatusX on DocumentStatus {
  String get label {
    return switch (this) {
      DocumentStatus.notUploaded => 'Missing',
      DocumentStatus.pending     => 'Pending',
      DocumentStatus.approved    => 'Approved',
      DocumentStatus.rejected    => 'Rejected',
    };
  }

  // pending = form submitted but no file yet → still allow upload
  bool get canUpload => this != DocumentStatus.approved;
}

// Merged view: a document type + its current upload status
class DocumentItem {
  final DocumentName name;
  final DocumentDetail? detail;

  const DocumentItem({required this.name, this.detail});

  DocumentStatus get status => detail?.status ?? DocumentStatus.notUploaded;
  String? get expiryDate => detail?.expiryDate;
  bool get canUpload => status.canUpload;
}
