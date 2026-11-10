import '../../models/client_detail_model.dart';
import '../../models/client_model.dart';
import '../../models/health_summary_model.dart';
import '../../models/stress_assessment_dashboard_response.dart';

class ClientState {
  final bool isLoadingList;
  final bool isLoadingDetail;
  final String? errorMessage;

  final List<ClientListItem> activeClients;
  final List<ClientListItem> completedClients;
  final List<ClientListItem> atRiskClients;

  final ClientDetailModel? clientDetail;
  final AssessmentDashboardResponse? clientAssessments;
  final HealthSummaryModel? clientVitals;

  const ClientState({
    this.isLoadingList = false,
    this.isLoadingDetail = false,
    this.errorMessage,
    this.activeClients = const [],
    this.completedClients = const [],
    this.atRiskClients = const [],
    this.clientDetail,
    this.clientAssessments,
    this.clientVitals,
  });

  factory ClientState.initial() {
    return const ClientState();
  }

  ClientState copyWith({
    bool? isLoadingList,
    bool? isLoadingDetail,
    String? errorMessage,
    List<ClientListItem>? activeClients,
    List<ClientListItem>? completedClients,
    List<ClientListItem>? atRiskClients,
    ClientDetailModel? clientDetail,
    AssessmentDashboardResponse? clientAssessments,
    HealthSummaryModel? clientVitals,
  }) {
    return ClientState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      errorMessage: errorMessage,
      activeClients: activeClients ?? this.activeClients,
      completedClients: completedClients ?? this.completedClients,
      atRiskClients: atRiskClients ?? this.atRiskClients,
      clientDetail: clientDetail ?? this.clientDetail,
      clientAssessments: clientAssessments ?? this.clientAssessments,
      clientVitals: clientVitals ?? this.clientVitals,
    );
  }
}
