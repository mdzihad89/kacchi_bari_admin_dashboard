import 'dart:typed_data';

class BranchAddRequestDTO{
  String name;
  Uint8List imageByte;
  String managerId;
  String managerName;
  String address;
  int table;


  BranchAddRequestDTO({
    required this.name,
    required this.managerName,
    required this.managerId,
    required this.table,
    required this.address,
    required this.imageByte,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'managerId': managerId,
      'managerName': managerName,
      'table': table,
      'address': address,
      'imageByte': imageByte,
    };
  }
}