import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/document_repository.dart';
import '../../model/document_model.dart';
import 'document_event.dart';
import 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final DocumentRepository _repo;

  DocumentBloc(this._repo) : super(const DocumentInitial()) {
    on<LoadDocuments>(_onLoad);
    on<RefreshDocuments>(_onRefresh);
  }

  Future<void> _onLoad(LoadDocuments event, Emitter<DocumentState> emit) async {
    emit(const DocumentLoading());
    await _fetch(emit);
  }

  Future<void> _onRefresh(RefreshDocuments event, Emitter<DocumentState> emit) async {
    await _fetch(emit);
  }

  Future<void> _fetch(Emitter<DocumentState> emit) async {
    try {
      final results = await Future.wait([
        _repo.getDocumentNames(),
        _repo.getDocumentDetails(),
      ]);

      final docNames   = results[0] as List<DocumentName>;
      final docDetails = results[1] as List<DocumentDetail>;

      debugPrint('=== documentNames: ${docNames.length}, document_details: ${docDetails.length} ===');

      // Primary lookup: by docId from document_details
      final detailMap = {for (final d in docDetails) d.docId: d};

      final items = docNames.map((name) {
        DocumentDetail? detail = detailMap[name.docId];

        return DocumentItem(name: name, detail: detail);
      }).toList();

      // Only docs with an actual file uploaded count as "uploaded".
      // `pending` = form record exists but no file → still needs upload.
      // `notUploaded` = no record at all.
      // `rejected` = file expired / rejected → needs re-upload.
      final uploaded = items
          .where((i) => i.status == DocumentStatus.approved)
          .length;

      debugPrint('=== Documents loaded: ${items.length} types, $uploaded uploaded ===');

      emit(DocumentsLoaded(
        items: items,
        uploadedCount: uploaded,
        totalCount: items.length,
      ));
    } catch (e) {
      debugPrint('DocumentBloc fetch error: $e');
      emit(DocumentError('Failed to load documents. Check your connection.'));
    }
  }
}
