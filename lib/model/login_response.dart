// To parse this JSON data, do
//
//     final LoginResponse = LoginResponseFromMap(jsonString);

import 'dart:convert';

class LoginResponse {
  LoginResponse(
      {required this.success,
      this.vendorId,
      this.token,
      this.tokenType,
      required this.message,
      this.vendorStatus,
      this.vendorName,
      this.vendorMobile,
      this.ownerName,
      this.deviceToken,
      this.vendorCoins});

  bool success;
  int? vendorId;
  String? token;
  String? tokenType;
  String message;
  int? vendorStatus;
  String? vendorName;
  String? vendorMobile;
  String? ownerName;
  String? deviceToken;
  String? vendorCoins;

  factory LoginResponse.fromJson(String str) => LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        success: json["success"] == null ? null : json["success"],
        vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
        token: json["token"] == null ? null : json["token"],
        tokenType: json["token_type"] == null ? null : json["token_type"],
        message: json["message"] == null ? null : json["message"],
        vendorStatus: json["vendor_status"] == null ? null : json["vendor_status"],
        vendorName: json["vendor_name"] == null ? null : json["vendor_name"],
        vendorMobile: json["vendor_mobile"] == null ? null : json["vendor_mobile"],
        ownerName: json["owner_name"] == null ? null : json["owner_name"],
        deviceToken: json["device_token"] == null ? "" : json["device_token"].toString(),
        vendorCoins: json["vendor_coins"] == null ? "" : json["vendor_coins"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "vendor_id": vendorId == null ? null : vendorId,
        "token": token == null ? null : token,
        "token_type": tokenType == null ? null : tokenType,
        "message": message == null ? null : message,
        "vendor_status": vendorStatus == null ? null : vendorStatus,
        "vendor_name": vendorName == null ? null : vendorName,
        "vendor_mobile": vendorMobile == null ? null : vendorMobile,
        "owner_name": ownerName == null ? null : ownerName,
        "device_token": deviceToken == null ? null : deviceToken,
        "vendor_coins": vendorCoins == null ? null : vendorCoins,
      };
}
