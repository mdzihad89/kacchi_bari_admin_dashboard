

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  final String name;
  final String image;
  final bool status;
  final String id;

  CategoryModel({
    required this.name,
    required this.image,
    required this.status,
    required this.id,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    name: json["name"],
    image: json["image"],
    status: json["status"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
    "status": status,
    "_id": id,
  };
}
