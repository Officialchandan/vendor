// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromMap(jsonString);

import 'dart:convert';

class LoginResponse {
  LoginResponse({
    required this.success,
     this.vendorId,
     this.token,
     this.tokenType,
     required this.message,
  });

  bool success;
  int? vendorId;
  String? token;
  String? tokenType;

  String message;

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        success: json["success"] ?? false,
        vendorId: json["vendor_id"] ?? 0,
        token: json["token"] ?? "",
        tokenType: json["token_type"] ?? "",
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "vendor_id": vendorId,
        "token": token,
        "token_type": tokenType,
        "message": message,
      };
}
