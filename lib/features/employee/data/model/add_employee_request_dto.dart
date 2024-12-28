import 'dart:io';
import 'dart:typed_data';

class AddEmployeeRequestDTO {
  String name;
  String email;
  String mobile;
  String password;
  String role;
  Uint8List? imageByte;

  AddEmployeeRequestDTO({
    required this.name,
    required this.email,
    required this.mobile,
    required this.password,
    required this.role,
    this.imageByte,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'password': password,
      'role': role,
      'imageByte': imageByte,
    };
  }
}
