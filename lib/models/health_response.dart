class HealthResponse {
  final bool success;
  final String message;

  const HealthResponse({
    required this.success,
    required this.message,
  });

  factory HealthResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return HealthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}