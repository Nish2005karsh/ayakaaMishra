import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../const/api_routes.dart';
import '../../const/app_session.dart';
import '../../model/api_response_model.dart';
import '../../model/document_model.dart';
import '../remote/dio_client.dart';

class DocumentRepository {
  // GET /documentNames — all document types with their dynamic field definitions
  Future<List<DocumentName>> getDocumentNames() async {
    debugPrint('=== API CALL: documentNames ===');
    debugPrint('→ (no params required)');

    final response = await DioClient.instance.get(ApiRoutes.documentNames);
    debugPrint('← response status: ${response.statusCode}');
    debugPrint('← data: ${response.data}');

    final data = response.data as Map<String, dynamic>;
    final status = ApiStatus.fromJson(data['status']);
    if (!status.isSuccess) {
      debugPrint('documentNames failed: ${status.message}');
      return [];
    }

    // API confirmed (from logs): response key is 'data', not 'documentNames'
    final list = (data['data'] ?? data['documentNames']) as List<dynamic>? ?? [];
    return list
        .map((e) => DocumentName.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // GET /document_details — driver's uploaded docs with status
  Future<List<DocumentDetail>> getDocumentDetails() async {
    final driverId = AppSession.driverId;
    final companyId = AppSession.companyId;

    debugPrint('=== API CALL: document_details ===');
    debugPrint('→ d_id: $driverId, company_id: $companyId');

    final response = await DioClient.instance.get(
      ApiRoutes.documentDetails,
      queryParameters: {'d_id': driverId, 'company_id': companyId},
    );
    debugPrint('← response status: ${response.statusCode}');
    debugPrint('← data: ${response.data}');

    final data = response.data as Map<String, dynamic>;
    final status = ApiStatus.fromJson(data['status']);
    if (!status.isSuccess) {
      debugPrint('document_details failed: ${status.message}');
      return [];
    }

    // API confirmed (from logs): response key is 'data', not 'documents'
    final list = (data['data'] ?? data['documents']) as List<dynamic>? ?? [];
    return list
        .map((e) => DocumentDetail.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // POST /upload_docs
  // Doc-confirmed format: multipart FormData with PHP array notation fields[name]=value
  // Params: driver_id, company_id, document_id, then fields[license_number], fields[expire_date], fields[doc_data]
  Future<ApiStatus> uploadDocument({
    required int docId,
    required List<Map<String, dynamic>> fields,
  }) async {
    final driverId = AppSession.driverId;
    final companyId = AppSession.companyId;

    debugPrint('=== API CALL: upload_docs ===');
    debugPrint('→ driver_id: $driverId, company_id: $companyId, document_id: $docId');
    debugPrint('→ fields count: ${fields.length}');
    for (final f in fields) {
      final val = f['value']?.toString() ?? '';
      final preview = val.startsWith('data:image') ? '[base64 image ${val.length} chars]' : val;
      debugPrint('   fields[${f['name']}] = $preview');
    }

    // Build FormData with PHP array notation: fields[name]=value
    final formMap = <String, dynamic>{
      'driver_id': driverId,
      'company_id': companyId,
      'document_id': docId,
    };
    for (final f in fields) {
      formMap['fields[${f['name']}]'] = f['value'];
    }

    final response = await DioClient.instance.post(
      ApiRoutes.uploadDocs,
      data: FormData.fromMap(formMap),
    );
    debugPrint('← response: ${response.data}');

    final data = response.data as Map<String, dynamic>;
    return ApiStatus.fromJson(data['status']);
  }
}
