
import 'dart:convert';

EmployeeModel employeeModelFromJson(String str) => EmployeeModel.fromJson(json.decode(str));
String employeeModelToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeModel {
  final String id;
  final String name;
  final String email;
  final String image;
  final String mobile;
  final dynamic branchId;
  final String role;
  final bool isBlocked;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.mobile,
    required this.branchId,
    required this.role,
    required this.isBlocked,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    image: json["image"],
    mobile: json["mobile"],
    branchId: json["branchId"],
    role: json["role"],
    isBlocked: json["isBlocked"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "image": image,
    "mobile": mobile,
    "branchId": branchId,
    "role": role,
    "isBlocked": isBlocked,
  };
}

