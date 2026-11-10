import '../../models/note_model.dart';

class NoteState {
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final List<NoteModel> notes;

  const NoteState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.notes = const [],
  });

  factory NoteState.initial() {
    return const NoteState();
  }

  NoteState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    List<NoteModel>? notes,
  }) {
    return NoteState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      notes: notes ?? this.notes,
    );
  }
}
