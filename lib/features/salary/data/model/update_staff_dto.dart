import 'dart:typed_data';

class UpdateStaffDTO{
  String staffId;
  String name;
  String fatherName;
  String guardianNumber;
  String phone;
  String address;
  String nidOrBirthCertificateNumber;
  String birthdate;
  String designation;
  String basicSalary;
  Uint8List? staffImage;
  Uint8List? staffAttachment;

  UpdateStaffDTO({
    required this.staffId,
    required this.name,
    required this.fatherName,
    required this.guardianNumber,
    required this.phone,
    required this.address,
    required this.nidOrBirthCertificateNumber,
    required this.birthdate,
    required this.designation,
    required this.basicSalary,
     this.staffImage,
     this.staffAttachment,
  });



  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'staffId': staffId,
      'name': name,
      'fatherName': fatherName,
      'guardianNumber': guardianNumber,
      'phone': phone,
      'address': address,
      'nidOrBirthCertificateNumber': nidOrBirthCertificateNumber,
      'birthdate': birthdate,
      'designation': designation,
      'basicSalary': basicSalary,
    };

    if (staffImage != null) {
      map['staffImage'] = staffImage;
    }

    if (staffAttachment != null) {
      map['staffAttachment'] = staffAttachment;
    }

    return map;
  }
}