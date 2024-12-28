import 'dart:convert';

LoginRequestDto loginRequestDtoFromJson(String str) => LoginRequestDto.fromJson(json.decode(str));

String loginRequestDtoToJson(LoginRequestDto data) => json.encode(data.toJson());

class  LoginRequestDto {
  String? email;
  String? password;

  LoginRequestDto({
    this.email,
    this.password,
  });

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) => LoginRequestDto(
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
  };
}
