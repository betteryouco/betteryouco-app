import 'enrollment_model.dart';

class PaymentModel {
  final int id;
  final int enrollmentId;
  final EnrollmentModel? enrollment;
  final double amount;
  final String? currency;
  final double? expertShareAmount;
  final double? betterYouShareAmount;
  final String status;
  final String? gatewayTxnId;

  const PaymentModel({
    required this.id,
    required this.enrollmentId,
    this.enrollment,
    required this.amount,
    this.currency,
    this.expertShareAmount,
    this.betterYouShareAmount,
    required this.status,
    this.gatewayTxnId,
  });

  bool get isPaid => status == 'paid';

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      enrollmentId: json['enrollment_id'],
      enrollment: json['enrollment'] != null
          ? EnrollmentModel.fromJson(json['enrollment'])
          : null,
      amount: double.tryParse('${json['amount']}') ?? 0,
      currency: json['currency'],
      expertShareAmount: json['expert_share_amount'] != null
          ? double.tryParse('${json['expert_share_amount']}')
          : null,
      betterYouShareAmount: json['betteryou_share_amount'] != null
          ? double.tryParse('${json['betteryou_share_amount']}')
          : null,
      status: json['status'] ?? 'pending',
      gatewayTxnId: json['gateway_txn_id'],
    );
  }
}
