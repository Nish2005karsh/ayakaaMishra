import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../const/api_routes.dart';
import '../../const/app_session.dart';
import '../../model/api_response_model.dart';
import '../../model/document_model.dart';
import '../remote/dio_client.dart';

class DocumentRepository {
  // GET /documentNames
  Future<List<DocumentName>> getDocumentNames() async {
    final driverId  = AppSession.driverId;
    final companyId = AppSession.companyId;

    debugPrint('=== API CALL: documentNames ===');
    debugPrint('→ d_id: $driverId, company_id: $companyId');

    final response = await DioClient.instance.get(
      ApiRoutes.documentNames,
      queryParameters: {'d_id': driverId, 'company_id': companyId},
    );
    debugPrint('← response status: ${response.statusCode}');
    debugPrint('← data: ${response.data}');

    final data   = response.data as Map<String, dynamic>;
    final status = ApiStatus.fromJson(data['status']);
    if (!status.isSuccess) {
      debugPrint('documentNames failed: ${status.message}');
      return [];
    }

    final list = (data['data'] ?? data['documentNames']) as List<dynamic>? ?? [];
    return list
        .map((e) => DocumentName.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // GET /document_details
  // Tries all known driver-identity param combinations so a backend mismatch
  // between how docs are stored vs queried doesn't silently return [].
  Future<List<DocumentDetail>> getDocumentDetails() async {
    final driverId  = AppSession.driverId;
    final companyId = AppSession.companyId;

    debugPrint('=== API CALL: document_details ===');
    debugPrint('→ driver_id: $driverId, company_id: $companyId');

    final response = await DioClient.instance.get(
      ApiRoutes.documentDetails,
      queryParameters: {
        'driver_id' : driverId,  // API param is driver_id (not d_id)
        'company_id': companyId,
      },
    );
    debugPrint('← response status: ${response.statusCode}');
    debugPrint('← data: ${response.data}');

    final data   = response.data as Map<String, dynamic>;
    final status = ApiStatus.fromJson(data['status']);
    if (!status.isSuccess) {
      debugPrint('document_details failed: ${status.message}');
      return [];
    }

    final list = (data['data'] ?? data['documents']) as List<dynamic>? ?? [];
    return list
        .map((e) => DocumentDetail.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // POST /upload_docs
  Future<ApiStatus> uploadDocument({
    required int docId,
    required List<Map<String, dynamic>> fields,
  }) async {
    final driverId  = AppSession.driverId;
    final userId    = AppSession.userId;
    final companyId = AppSession.companyId;

    debugPrint('=== API CALL: upload_docs ===');
    debugPrint('→ driver_id: $driverId, user_id: $userId, company_id: $companyId, document_id: $docId');
    debugPrint('→ fields count: ${fields.length}');
    for (final f in fields) {
      final val     = f['value']?.toString() ?? '';
      final preview = val.startsWith('data:image')
          ? '[base64 image ${val.length} chars]'
          : val;
      debugPrint('   fields[${f['name']}] = $preview');
    }

    // Send both driver_id and user_id so backend matches regardless
    // of which column it uses to store the record.
    final formMap = <String, dynamic>{
      'driver_id'  : driverId,
      'd_id'       : driverId,
      'user_id'    : userId,
      'company_id' : companyId,
      'document_id': docId,
    };
    for (final f in fields) {
      formMap['fields[${f['name']}]'] = f['value'];
    }

    final response = await DioClient.instance.post(
      ApiRoutes.uploadDocs,
      data: FormData.fromMap(formMap),
    );
    debugPrint('← upload response: ${response.data}');

    final data = response.data as Map<String, dynamic>;

    // API returns nested response — not a flat {status: {...}}.
    // Success: { "inserted": { "status": {...} } }
    //       or { "updated":  { "status": {...} } }
    // Error:  { "status": { "code": "1", ... } }  (flat fallback)
    Map<String, dynamic>? statusMap;
    if (data['inserted'] is Map) {
      statusMap = (data['inserted'] as Map<String, dynamic>)['status']
          as Map<String, dynamic>?;
    } else if (data['updated'] is Map) {
      statusMap = (data['updated'] as Map<String, dynamic>)['status']
          as Map<String, dynamic>?;
    }
    statusMap ??= data['status'] as Map<String, dynamic>? ?? data;

    debugPrint('← upload status: ${statusMap['code']} — ${statusMap['message']}');
    return ApiStatus.fromJson(statusMap);
  }
}
