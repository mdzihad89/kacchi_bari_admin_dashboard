import 'dart:typed_data';

class AddCategoryRequestDto {
  String name;
  Uint8List imageByte;

  AddCategoryRequestDto({
    required this.name,
    required this.imageByte,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageByte': imageByte,
    };
  }
}