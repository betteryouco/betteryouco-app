import '../../../models/assessment_history_model.dart';
import '../../../models/instrument_trend_response.dart';
import '../../../models/stress_assessment_dashboard_response.dart';
import '../../../models/stress_assessment_response.dart';

class AssessmentState {
  final bool isLoading;

  final bool isSuccess;

  final String? errorMessage;

  /// True when the last request failed with 401 — the locally-cached
  /// session is no longer valid server-side (expired, or revoked by a
  /// backend reset), as opposed to a normal validation/network failure.
  final bool sessionExpired;

  final Map<String, dynamic>? validationErrors;
  final AssessmentDashboardResponse? dashboard;
  final AssessmentResponse? response;
  final AssessmentHistoryResponse? history;

  // Separate loading flag — the instrument-trend chart loads
  // independently of the dashboard/submit flows above, and sharing
  // isLoading with them risked one call's completion prematurely
  // hiding the HUD while the other was still in flight.
  final bool isLoadingTrend;
  final InstrumentTrendResponse? instrumentTrend;

  const AssessmentState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.sessionExpired = false,
    this.validationErrors,
    this.dashboard,
    this.response,
    this.history,
    this.isLoadingTrend = false,
    this.instrumentTrend,
  });

  AssessmentState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool? sessionExpired,
    Map<String, dynamic>? validationErrors,
    AssessmentResponse? response,
    AssessmentDashboardResponse? dashboard,
    AssessmentHistoryResponse? history,
    bool? isLoadingTrend,
    InstrumentTrendResponse? instrumentTrend,
  }) {
    return AssessmentState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      sessionExpired: sessionExpired ?? false,
      validationErrors: validationErrors,
      response: response ?? this.response,
      dashboard: dashboard ?? this.dashboard,
      history: history ?? this.history,
      isLoadingTrend: isLoadingTrend ?? this.isLoadingTrend,
      instrumentTrend: instrumentTrend ?? this.instrumentTrend,
    );
  }

  factory AssessmentState.initial() {
    return const AssessmentState();
  }
}
