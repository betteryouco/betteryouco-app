import '../../models/enrollment_model.dart';
import '../../models/payment_model.dart';

class PurchaseState {
  final bool isLoading;
  final String? errorMessage;
  final PaymentModel? currentPayment;
  final List<EnrollmentModel> enrollments;

  const PurchaseState({
    this.isLoading = false,
    this.errorMessage,
    this.currentPayment,
    this.enrollments = const [],
  });

  factory PurchaseState.initial() {
    return const PurchaseState();
  }

  PurchaseState copyWith({
    bool? isLoading,
    String? errorMessage,
    PaymentModel? currentPayment,
    List<EnrollmentModel>? enrollments,
  }) {
    return PurchaseState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentPayment: currentPayment ?? this.currentPayment,
      enrollments: enrollments ?? this.enrollments,
    );
  }
}
