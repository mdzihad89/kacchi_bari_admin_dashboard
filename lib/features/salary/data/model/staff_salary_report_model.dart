
class StaffSalaryReportModel{
  final String staffId;
  final int workedDays;
  final String perDaySalary;
  final String payableAmount;
  final String totalPaid;
  final String netAmount;
  final String status;
  final DateTime reportDate;
  final int  totalDays;
  final int  leaveDays;
  const StaffSalaryReportModel({
    required this.staffId,
    required this.workedDays,
    required this.perDaySalary,
    required this.payableAmount,
    required this.totalPaid,
    required this.netAmount,
    required this.status,
    required this.reportDate,
    required this.totalDays,
    required this.leaveDays,
  });
  factory StaffSalaryReportModel.fromJson(Map<String, dynamic> json) {
    return StaffSalaryReportModel(
      staffId: json['staffId'] as String,
      workedDays: json['workedDays'] as int,
      perDaySalary: json['perDaySalary'] as String,
      payableAmount: json['payableAmount'] as String,
      totalPaid: json['totalPaid'] as String,
       netAmount: json['netAmount'] as String,
      status: json['status'] as String,
      reportDate:  DateTime.parse(json['reportDate'] as String).toLocal(),
      totalDays: json['totalDays'] as int,
      leaveDays: json['leaveDays'] as int,
    );
  }


}