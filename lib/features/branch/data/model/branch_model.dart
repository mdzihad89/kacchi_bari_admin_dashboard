import 'dart:convert';

BranchModel branchModelFromJson(String str) => BranchModel.fromJson(json.decode(str));

String branchModelToJson(BranchModel data) => json.encode(data.toJson());

class BranchModel {
  final String name;
  final String image;
  final bool status;
  final String managerId;
  final String managerName;
  final String address;
  final int table;
  final  String branchPhoneNumber;
  final String id;

  BranchModel({
    required this.name,
    required this.image,
    required this.status,
    required this.address,
    required this.managerName,
    required this.managerId,
    required this.table,
    required this.branchPhoneNumber,
    required this.id,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
    name: json["name"],
    image: json["image"],
    status: json["status"],
    table: json["table"],
    address: json["address"],
    managerId: json["managerId"],
    managerName: json["managerName"],
    branchPhoneNumber: json["branchPhoneNumber"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
    "status": status,
    "address": address,
    "managerId": managerId,
    "managerName": managerName,
    "table": table,
    "branchPhoneNumber": branchPhoneNumber,
    "_id": id,
  };
}
