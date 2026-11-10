import '../core/auth/guest_session_manager.dart';
import '../core/auth/session_manager.dart';

class StressAssessmentRequest {
  final int assessmentDefinitionId;
  final Map<String, int> answers;
  final String source;
  final String? guestSessionToken;

  const StressAssessmentRequest({
    required this.assessmentDefinitionId,
    required this.answers,
    required this.source,
    this.guestSessionToken,
  });

  /// Factory method that automatically builds the request
  /// based on the current authentication state.
  static Future<StressAssessmentRequest> create({
    required Map<String, int> answers,
    int assessmentDefinitionId = 1,
  }) async {
    final isLoggedIn = await SessionManager.instance.hasToken();

    return StressAssessmentRequest(
      assessmentDefinitionId: assessmentDefinitionId,
      answers: answers,
      source: isLoggedIn ? "client_app" : "guest_app",
      guestSessionToken: isLoggedIn
          ? null
          : await GuestSessionManager.instance.getToken(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      "assessment_definition_id": assessmentDefinitionId,
      "answers": answers,
      "source": source,
    };

    if (guestSessionToken != null) {
      json["guest_session_token"] = guestSessionToken;
    }

    return json;
  }

  StressAssessmentRequest copyWith({
    int? assessmentDefinitionId,
    Map<String, int>? answers,
    String? source,
    String? guestSessionToken,
  }) {
    return StressAssessmentRequest(
      assessmentDefinitionId:
          assessmentDefinitionId ?? this.assessmentDefinitionId,
      answers: answers ?? this.answers,
      source: source ?? this.source,
      guestSessionToken: guestSessionToken ?? this.guestSessionToken,
    );
  }
}
