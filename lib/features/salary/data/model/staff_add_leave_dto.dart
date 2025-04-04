class AddLeaveDto{
  String staffId;
  List<String> leaveDays;

  AddLeaveDto({
    required this.staffId,
    required this.leaveDays,
  });
  Map<String, dynamic> toJson() {
    return {
      'staffId': staffId,
      'leaveDays': leaveDays,
    };
  }
}