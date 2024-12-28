
import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));
String productModelToJson(List<ProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class ProductModel {
  String id;
  String name;
  String image;
  bool status;
  String slug;
  int price;
  String categoryId;
  String categoryName;
  String type;
  List<Variation> variations;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.slug,
    required this.price,
    required this.categoryId,
    required this.categoryName,
    required this.type,
    required this.variations,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["_id"],
    name: json["name"],
    image: json["image"],
    status: json["status"],
    slug: json["slug"],
    price: json["price"],
    categoryId: json["categoryId"],
    categoryName: json["categoryName"],
    type: json["type"],
    variations: List<Variation>.from(json["variations"].map((x) => Variation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "image": image,
    "status": status,
    "slug": slug,
    "price": price,
    "categoryId": categoryId,
    "categoryName": categoryName,
    "type": type,
    "variations": List<dynamic>.from(variations.map((x) => x.toJson())),
  };
}

class Variation {
  int personCount;
  int price;
  String id;

  Variation({
    required this.personCount,
    required this.price,
    required this.id,
  });

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
    personCount: json["personCount"],
    price: json["price"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "personCount": personCount,
    "price": price,
    "_id": id,
  };
}
