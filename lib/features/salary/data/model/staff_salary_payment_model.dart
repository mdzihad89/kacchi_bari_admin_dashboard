
class StaffSalaryPaymentModel {
  final String id;
  final DateTime paymentDate;
  final int payAmount;
  final String staffId;
  StaffSalaryPaymentModel({
    required this.id,
    required this.paymentDate,
    required this.payAmount,
    required this.staffId,

  });

  factory StaffSalaryPaymentModel.fromJson(Map<String, dynamic> json) {
    return StaffSalaryPaymentModel(
      id: json['_id'] as String,
      paymentDate: DateTime.parse(json['paymentDate']).toLocal(),
      payAmount: json['payAmount'] as int,
      staffId: json['staffId'] as String,
    );
  }

}
