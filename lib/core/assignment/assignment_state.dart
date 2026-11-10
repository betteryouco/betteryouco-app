import '../../models/assignment_request_model.dart';

class AssignmentState {
  final bool isLoading;
  final String? errorMessage;
  final List<AssignmentRequestModel> pendingRequests;

  const AssignmentState({
    this.isLoading = false,
    this.errorMessage,
    this.pendingRequests = const [],
  });

  factory AssignmentState.initial() {
    return const AssignmentState();
  }

  AssignmentState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<AssignmentRequestModel>? pendingRequests,
  }) {
    return AssignmentState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      pendingRequests: pendingRequests ?? this.pendingRequests,
    );
  }
}
