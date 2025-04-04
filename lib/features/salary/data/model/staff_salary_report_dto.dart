
 class StaffSalaryReportDTO{
   final String staffId;
   final String reportDate;

    const StaffSalaryReportDTO({
      required this.staffId,
      required this.reportDate,
    });
    Map<String, dynamic> toJson() {
      return {
        'staffId': staffId,
        'reportDate': reportDate,
      };
    }
 }