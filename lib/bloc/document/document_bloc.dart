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
    // Keep current state visible while refreshing
    await _fetch(emit);
  }

  Future<void> _fetch(Emitter<DocumentState> emit) async {
    try {
      // Parallel fetch: all doc types + driver's uploaded docs
      final results = await Future.wait([
        _repo.getDocumentNames(),
        _repo.getDocumentDetails(),
      ]);

      final docNames = results[0] as List<DocumentName>;
      final docDetails = results[1] as List<DocumentDetail>;

      // Map detail by docId for quick lookup
      final detailMap = {for (final d in docDetails) d.docId: d};

      // Merge: every document type gets its upload status
      final items = docNames.map((name) {
        return DocumentItem(
          name: name,
          detail: detailMap[name.docId],
        );
      }).toList();

      final uploaded = items
          .where((i) => i.status == DocumentStatus.approved || i.status == DocumentStatus.pending)
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
