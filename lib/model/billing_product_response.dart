// To parse this JSON BillingProductData, do
//
//     final billingProductResponse = billingProductResponseFromMap(jsonString);

import 'dart:convert';

class BillingProductResponse {
  BillingProductResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  BillingProductData? data;

  factory BillingProductResponse.fromJson(String str) =>
      BillingProductResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BillingProductResponse.fromMap(Map<String, dynamic> json) =>
      BillingProductResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : BillingProductData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class BillingProductData {
  BillingProductData({
    required this.orderId,
    required this.customerId,
    required this.mobile,
    required this.otp,
    required this.vendorId,
    required this.totalPay,
    required this.redeemCoins,
    required this.earningCoins,
  });

  int orderId;
  int customerId;
  String mobile;
  int otp;
  String vendorId;
  String totalPay;
  String redeemCoins;
  String earningCoins;

  factory BillingProductData.fromJson(String str) =>
      BillingProductData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BillingProductData.fromMap(Map<String, dynamic> json) =>
      BillingProductData(
        orderId: json["order_id"] == null ? null : json["order_id"],
        customerId: json["customer_id"] == null ? null : json["customer_id"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        otp: json["otp"] == null ? null : json["otp"],
        vendorId: json["vendor_id"].toString(),
        totalPay: json["total_pay"].toString(),
        redeemCoins: json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId == null ? null : orderId,
        "customer_id": customerId == null ? null : customerId,
        "mobile": mobile == null ? null : mobile,
        "otp": otp == null ? null : otp,
        "vendor_id": vendorId == null ? null : vendorId,
        "total_pay": totalPay == null ? null : totalPay,
        "redeem_coins": redeemCoins == null ? null : redeemCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
      };
}
