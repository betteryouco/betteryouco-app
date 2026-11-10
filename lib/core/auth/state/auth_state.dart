class AuthState {
  final bool isLoading;

  final bool isSuccess;

  final String? errorMessage;

  final Map<String, dynamic>? validationErrors;

  final String? token;

  const AuthState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.validationErrors,
    this.token,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    Map<String, dynamic>? validationErrors,
    String? token,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      validationErrors: validationErrors,
      token: token ?? this.token,
    );
  }

  factory AuthState.initial() {
    return const AuthState();
  }
}