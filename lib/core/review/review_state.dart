import '../../models/review_model.dart';

class ReviewState {
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final List<ReviewModel> reviews;

  const ReviewState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.reviews = const [],
  });

  factory ReviewState.initial() {
    return const ReviewState();
  }

  ReviewState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    List<ReviewModel>? reviews,
  }) {
    return ReviewState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      reviews: reviews ?? this.reviews,
    );
  }
}
