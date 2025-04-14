

class StaffModel{
  String id;
  String name;
  String fatherName;
  String guardianNumber;
  String phone;
  String address;
  String nidOrBirthCertificateNumber;
  String birthdate;
  String designation;
  DateTime joiningDate;
  String basicSalary;
  String staffImage;
  String staffAttachment;
  List<DateTime>? leaveDays;
  DateTime? exitDate;
  bool status;
  String icId;

  StaffModel({
    required this.id,
    required this.name,
    required this.fatherName,
    required this.guardianNumber,
    required this.phone,
    required this.address,
    required this.nidOrBirthCertificateNumber,
    required this.birthdate,
    required this.designation,
    required this.joiningDate,
    required this.basicSalary,
    required this.staffImage,
    required this.staffAttachment,
     this.leaveDays ,
     this.exitDate,
    required this.status,

    required this.icId,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) => StaffModel(
    id: json["_id"],
    name: json["name"],
    fatherName: json["fatherName"],
    guardianNumber: json["guardianNumber"],
    phone: json["phone"],
    address: json["address"],
    nidOrBirthCertificateNumber: json["nidOrBirthCertificateNumber"],
    birthdate: json["birthdate"],
    designation: json["designation"],
    joiningDate: DateTime.parse(json["joiningDate"]).toLocal(),
    basicSalary: json["basicSalary"],
    staffImage: json["staffImage"],
    staffAttachment: json["staffAttachment"],
    leaveDays: json["leaveDays"] != null ?
    List<DateTime>.from(json["leaveDays"].map((x) => DateTime.parse(x).toLocal()).toList()).reversed.toList() : [],
    exitDate: json["exitDate"] != null ? DateTime.parse(json["exitDate"]).toLocal() : null,
    status: json["status"],
    icId: json["icId"],
  );
}