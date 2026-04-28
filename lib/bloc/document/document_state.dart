import 'package:equatable/equatable.dart';
import '../../model/document_model.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();
  @override
  List<Object?> get props => [];
}

class DocumentInitial extends DocumentState {
  const DocumentInitial();
}

class DocumentLoading extends DocumentState {
  const DocumentLoading();
}

class DocumentsLoaded extends DocumentState {
  final List<DocumentItem> items;
  final int uploadedCount;
  final int totalCount;

  const DocumentsLoaded({
    required this.items,
    required this.uploadedCount,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [items, uploadedCount, totalCount];
}

class DocumentError extends DocumentState {
  final String message;
  const DocumentError(this.message);
  @override
  List<Object?> get props => [message];
}
