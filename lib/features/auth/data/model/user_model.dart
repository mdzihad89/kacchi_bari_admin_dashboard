import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String id;
  final String name;
  final String email;
  final String image;
  final String mobile;
  final String role;
  final bool isBlocked;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.mobile,
    required this.role,
    required this.isBlocked,
    this.token,
  });


  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"] ?? '',
    name: json["name"] ?? '',
    email: json["email"] ?? '',
    image: json["image"] ?? '',
    mobile: json["mobile"] ?? "",
    role: json["role"] ?? '',
    isBlocked: json["isBlocked"] ?? false,
    token: json["token"],
  );


  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "image": image,
    "mobile": mobile,
    "role": role,
    "isBlocked": isBlocked,
    "token": token,
  };
}
