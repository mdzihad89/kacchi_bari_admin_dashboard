

class StaffModel{
  String id;
  String name;
  String fatherName;
  String email;
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

  StaffModel({
    required this.id,
    required this.name,
    required this.fatherName,
    required this.email,
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
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) => StaffModel(
    id: json["_id"],
    name: json["name"],
    fatherName: json["fatherName"],
    email: json["email"],
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
  );
}