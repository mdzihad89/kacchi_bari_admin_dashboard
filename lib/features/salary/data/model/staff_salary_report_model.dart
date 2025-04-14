
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
  final DateTime joiningDate;
  final DateTime? exitDate;
  final String staffName;
  final String staffDesignation;
  final String staffImage;
  final String basicSalary;
  final String icId;

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
    required this.joiningDate,
     this.exitDate,
    required this.staffName,
    required this.staffDesignation,
    required this.staffImage,
    required this.basicSalary,
    required this.icId,

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
      joiningDate: DateTime.parse(json['joiningDate'] as String).toLocal(),
      exitDate: json['exitDate'] != null ? DateTime.parse(json['exitDate'] as String).toLocal() : null,
      staffName: json['staffName'] as String,
      staffDesignation: json['staffDesignation'] as String,
      staffImage: json['staffImage'] as String,
      basicSalary: json['basicSalary'] as String,
      icId: json['icId'] as String,
    );
  }
}