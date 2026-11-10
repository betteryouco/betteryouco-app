import '../../models/program_model.dart';

class ProgramState {
  final bool isLoading;
  final bool isSaving;
  final bool isSuccess;
  final String? successMessage;
  final String? errorMessage;
  final Map<String, dynamic>? validationErrors;
  final List<ProgramModel> programs;
  final List<ProgramModel> browsePrograms;

  const ProgramState({
    this.isLoading = false,
    this.isSaving = false,
    this.isSuccess = false,
    this.successMessage,
    this.errorMessage,
    this.validationErrors,
    this.programs = const [],
    this.browsePrograms = const [],
  });

  factory ProgramState.initial() {
    return const ProgramState();
  }

  ProgramState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isSuccess,
    String? successMessage,
    String? errorMessage,
    Map<String, dynamic>? validationErrors,
    List<ProgramModel>? programs,
    List<ProgramModel>? browsePrograms,
  }) {
    return ProgramState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isSuccess: isSuccess ?? this.isSuccess,
      successMessage: successMessage,
      errorMessage: errorMessage,
      validationErrors: validationErrors,
      programs: programs ?? this.programs,
      browsePrograms: browsePrograms ?? this.browsePrograms,
    );
  }
}
