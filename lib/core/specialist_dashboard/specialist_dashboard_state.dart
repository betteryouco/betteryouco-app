import '../../models/specialist_dashboard_model.dart';

class SpecialistDashboardState {
  final bool isLoading;
  final String? errorMessage;
  final SpecialistDashboardModel? dashboard;

  const SpecialistDashboardState({
    this.isLoading = false,
    this.errorMessage,
    this.dashboard,
  });

  factory SpecialistDashboardState.initial() {
    return const SpecialistDashboardState();
  }

  SpecialistDashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    SpecialistDashboardModel? dashboard,
  }) {
    return SpecialistDashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      dashboard: dashboard ?? this.dashboard,
    );
  }
}
