class GuestState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const GuestState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  GuestState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return GuestState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}