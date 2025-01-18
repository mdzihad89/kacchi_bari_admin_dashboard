import 'dart:typed_data';

class BranchAddRequestDTO{
  String name;
  Uint8List imageByte;
  String managerId;
  String managerName;
  String address;
  String branchPhoneNumber;
  String branchBinNumber;
  int table;


  BranchAddRequestDTO({
    required this.name,
    required this.managerName,
    required this.managerId,
    required this.table,
    required this.address,
    required this.imageByte,
    required this.branchPhoneNumber,
    required this.branchBinNumber,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'managerId': managerId,
      'managerName': managerName,
      'table': table,
      'address': address,
      'imageByte': imageByte,
      'branchPhoneNumber': branchPhoneNumber,
      'branchBinNumber': branchBinNumber,
    };
  }
}