
import 'dart:typed_data';

class AddStaffDTO{
  String name;
  String fatherName;
  String email;
  String phone;
  String address;
  String nidOrBirthCertificateNumber;
  String birthdate;
  String designation;
  String joiningDate;
  String basicSalary;
  Uint8List staffImage;
  Uint8List staffAttachment;

  AddStaffDTO({
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
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'fatherName': fatherName,
      'email': email,
      'phone': phone,
      'address': address,
      'nidOrBirthCertificateNumber': nidOrBirthCertificateNumber,
      'birthdate': birthdate,
      'designation': designation,
      'joiningDate': joiningDate,
      'basicSalary': basicSalary,
      'staffImage': staffImage,
      'staffAttachment': staffAttachment,
    };
  }
}