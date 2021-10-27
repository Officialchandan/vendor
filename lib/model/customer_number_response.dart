// To parse this JSON data, do
//
//     final getCustomerNumberResponse = getCustomerNumberResponseFromMap(jsonString);

import 'dart:convert';

class CustomerNumberResponse {
  CustomerNumberResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  CustomerNumberResponseData? data;

  factory CustomerNumberResponse.fromJson(String str) => CustomerNumberResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CustomerNumberResponse.fromMap(Map<String, dynamic> json) => CustomerNumberResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : CustomerNumberResponseData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data!.toMap(),
      };
}

class CustomerNumberResponseData {
  CustomerNumberResponseData({
    required this.id,
    required this.walletBalance,
  });

  int id;
  String walletBalance;

  factory CustomerNumberResponseData.fromJson(String str) => CustomerNumberResponseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CustomerNumberResponseData.fromMap(Map<String, dynamic> json) => CustomerNumberResponseData(
        id: json["id"] == null ? 0 : json["id"],
        walletBalance: json["wallet_balance"] == null ? "" : json["wallet_balance"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "wallet_balance": walletBalance,
      };
}
