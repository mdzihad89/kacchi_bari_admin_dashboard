
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


List<EmployeeModel> employeeList = [
  EmployeeModel(
    id: "1",
    name: "John Doe",
    email: "john.doe@example.com",
    image: "https://example.com/images/john_doe.png",
    mobile: "+1234567890",
    branchId: "101",
    role: "Manager",
    isBlocked: false,
  ),
  EmployeeModel(
    id: "2",
    name: "Jane Smith",
    email: "jane.smith@example.com",
    image: "https://example.com/images/jane_smith.png",
    mobile: "+9876543210",
    branchId: "102",
    role: "Cashier",
    isBlocked: false,
  ),
  EmployeeModel(
    id: "3",
    name: "Alice Johnson",
    email: "alice.johnson@example.com",
    image: "https://example.com/images/alice_johnson.png",
    mobile: "+1122334455",
    branchId: "103",
    role: "Chef",
    isBlocked: true,
  ),
  EmployeeModel(
    id: "4",
    name: "Bob Brown",
    email: "bob.brown@example.com",
    image: "https://example.com/images/bob_brown.png",
    mobile: "+5566778899",
    branchId: "104",
    role: "Waiter",
    isBlocked: false,
  ),
];
