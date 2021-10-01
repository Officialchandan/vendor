// To parse this JSON data, do
//
//     final VerifyEarningCoinsOtpResponse = VerifyEarningCoinsOtpResponseFromMap(jsonString);

import 'dart:convert';

class VerifyEarningCoinsOtpResponse {
  VerifyEarningCoinsOtpResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  VerifyEarningCoinsOtpData? data;

  factory VerifyEarningCoinsOtpResponse.fromJson(String str) =>
      VerifyEarningCoinsOtpResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VerifyEarningCoinsOtpResponse.fromMap(Map<String, dynamic> json) =>
      VerifyEarningCoinsOtpResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : VerifyEarningCoinsOtpData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class VerifyEarningCoinsOtpData {
  VerifyEarningCoinsOtpData({
    required this.orderId,
    required this.customerId,
    required this.mobile,
    required this.vendorId,
    required this.redeemCoins,
    required this.earningCoins,
    required this.walletBalance,
    required this.orderDate,
  });

  String orderId;
  String customerId;
  String mobile;
  String vendorId;
  String redeemCoins;
  String earningCoins;
  double walletBalance;
  DateTime orderDate;

  factory VerifyEarningCoinsOtpData.fromJson(String str) =>
      VerifyEarningCoinsOtpData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VerifyEarningCoinsOtpData.fromMap(Map<String, dynamic> json) =>
      VerifyEarningCoinsOtpData(
        orderId: json["order_id"] == null ? null : json["order_id"],
        customerId: json["customer_id"] == null ? null : json["customer_id"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        vendorId: json["vendor_id"].toString(),
        redeemCoins: json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"].toString(),
        walletBalance: json["wallet_balance"] == null
            ? null
            : json["wallet_balance"].toDouble(),
        orderDate: DateTime.parse(json["order_date"]),
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId == null ? null : orderId,
        "customer_id": customerId == null ? null : customerId,
        "mobile": mobile == null ? null : mobile,
        "vendor_id": vendorId == null ? null : vendorId,
        "redeem_coins": redeemCoins == null ? null : redeemCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
        "wallet_balance": walletBalance == null ? null : walletBalance,
        "order_date": orderDate == null ? null : orderDate.toIso8601String(),
      };
}
