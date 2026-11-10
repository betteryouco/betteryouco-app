import '../../../models/health_summary_model.dart';

class HealthState {
  final bool isLoading;

  final bool isSuccess;

  final String? successMessage;

  final String? errorMessage;

  final Map<String, dynamic>? validationErrors;
  final HealthSummaryModel? summary;

  const HealthState({
    this.isLoading = false,
    this.isSuccess = false,
    this.successMessage,
    this.errorMessage,
    this.validationErrors,
    this.summary,
  });

  factory HealthState.initial() {
    return const HealthState();
  }

  HealthState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? successMessage,
    String? errorMessage,
    Map<String, dynamic>? validationErrors,
    HealthSummaryModel? summary,
  }) {
    return HealthState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      successMessage: successMessage,
      errorMessage: errorMessage,
      validationErrors: validationErrors,
      summary: summary,
    );
  }
}