import 'dart:convert';
import 'package:flutter/foundation.dart';

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

// A document type with its dynamic field definitions
class DocumentName {
  final int docId;
  final String docName;
  final List<DocumentField> fields;

  const DocumentName({
    required this.docId,
    required this.docName,
    required this.fields,
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
    // API confirmed (from logs): document_id + document_name (not doc_id / doc_name)
    return DocumentName(
      docId: j['document_id'] ?? j['doc_id'] ?? 0,
      docName: j['document_name']?.toString() ?? j['doc_name']?.toString() ?? '',
      fields: fields,
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
    DocumentStatus status = DocumentStatus.notUploaded;
    final raw = j['doc_status']?.toString();
    if (raw == '1' || raw == 'approved') {
      status = DocumentStatus.approved;
    } else if (raw == '0' || raw == 'pending') {
      status = DocumentStatus.pending;
    } else if (raw == '2' || raw == 'rejected') {
      status = DocumentStatus.rejected;
    }

    return DocumentDetail(
      docId: j['doc_id'] ?? 0,
      docName: j['doc_name']?.toString() ?? '',
      status: status,
      expiryDate: j['doc_exp_date']?.toString(),
      filePath: j['doc_file']?.toString(),
    );
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

  bool get canUpload => this == DocumentStatus.notUploaded || this == DocumentStatus.rejected;
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
