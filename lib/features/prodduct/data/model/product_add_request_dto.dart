
import 'dart:typed_data';

import 'package:kacchi_bari_admin_dashboard/features/prodduct/data/model/package_variation.dart';

class ProductItemDTO {
  final String name;
  final Uint8List imageByte;
  final String type;
  final int price;
  final List<PackageVariation>? variations;
  final String categoryId;
  final String categoryName;


  ProductItemDTO({
    required this.name,
     required this.imageByte,
    required this.type,
    required this.price,
     this.variations,
    required this.categoryId,
    required this.categoryName,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageByte': imageByte,
      'type': type,
      'price': price,
      'variations': variations?.map((e) => e.toJson()).toList(),
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }
}


