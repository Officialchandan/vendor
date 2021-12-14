// To parse this JSON data, do
//
//     final getCustomerNumberResponse = getCustomerNumberResponseFromMap(jsonString);

import 'dart:convert';

class CustomerNumberResponse {
  CustomerNumberResponse({
    required this.success,
    required this.message,
    this.cust_reg_status,
    this.data,
  });

  bool success;
  String message;
  int? cust_reg_status;
  CustomerNumberResponseData? data;

  factory CustomerNumberResponse.fromJson(String str) =>
      CustomerNumberResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CustomerNumberResponse.fromMap(Map<String, dynamic> json) =>
      CustomerNumberResponse(
        success: json["success"],
        message: json["message"],
        cust_reg_status:
            json["cust_reg_status"] == null ? 0 : json["cust_reg_status"],
        data: json["data"] == null
            ? null
            : CustomerNumberResponseData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "cust_reg_status": cust_reg_status == null ? null : cust_reg_status,
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

  factory CustomerNumberResponseData.fromJson(String str) =>
      CustomerNumberResponseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CustomerNumberResponseData.fromMap(Map<String, dynamic> json) =>
      CustomerNumberResponseData(
        id: json["id"] == null ? 0 : json["id"],
        walletBalance:
            json["wallet_balance"] == null ? "" : json["wallet_balance"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "wallet_balance": walletBalance,
      };
}
