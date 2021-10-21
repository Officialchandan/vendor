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
    this.vendorStatus,
  });

  bool success;
  int? vendorId;
  String? token;
  String? tokenType;

  String message;
  int? vendorStatus;

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        success: json["success"] ?? false,
        vendorId: json["vendor_id"] ?? 0,
        token: json["token"] ?? "",
        tokenType: json["token_type"] ?? "",
        message: json["message"] ?? "",
        vendorStatus: json["vendor_status"] == null ? 0 : json["vendor_status"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "vendor_id": vendorId,
        "token": token,
        "token_type": tokenType,
        "message": message,
        "vendor_status": vendorStatus == null ? null : vendorStatus,
      };
}
