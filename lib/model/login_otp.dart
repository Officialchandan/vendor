// To parse this JSON data, do
//
//     final monthlyWalkinAmountResponse = monthlyWalkinAmountResponseFromMap(jsonString);

import 'dart:convert';

class LoginOtpResponse {
  LoginOtpResponse({
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

  factory LoginOtpResponse.fromJson(String str) =>
      LoginOtpResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginOtpResponse.fromMap(Map<String, dynamic> json) =>
      LoginOtpResponse(
        success: json["success"],
        vendorId: json["vendor_id"],
        token: json["token"],
        tokenType: json["token_type"],
        message: json["message"],
        vendorStatus: json["vendor_status"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "vendor_id": vendorId,
        "token": token,
        "token_type": tokenType,
        "message": message,
        "vendor_status": vendorStatus,
      };
}
