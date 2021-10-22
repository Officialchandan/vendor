// To parse this JSON data, do
//
//     final directBillingOtpResponse = directBillingOtpResponseFromMap(jsonString);

import 'dart:convert';

class DirectBillingResponse {
  DirectBillingResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  DirectBillingData? data;

  factory DirectBillingResponse.fromJson(String str) =>
      DirectBillingResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DirectBillingResponse.fromMap(Map<String, dynamic> json) =>
      DirectBillingResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : DirectBillingData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class DirectBillingData {
  DirectBillingData({
    required this.vendorId,
    required this.billId,
    required this.customerId,
    required this.mobile,
    required this.billAmount,
    required this.totalPay,
    required this.coinDeducted,
    required this.earningCoins,
  });

  int vendorId;
  int billId;
  int customerId;
  String mobile;
  String billAmount;
  String totalPay;
  String coinDeducted;
  String earningCoins;

  factory DirectBillingData.fromJson(String str) =>
      DirectBillingData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DirectBillingData.fromMap(Map<String, dynamic> json) =>
      DirectBillingData(
        vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
        billId: json["bill_id"] == null ? null : json["bill_id"],
        customerId: json["customer_id"] == null ? null : json["customer_id"],
        mobile: json["mobile"] == null ? "" : json["mobile"].toString(),
        billAmount:
            json["bill_amount"] == null ? "" : json["bill_amount"].toString(),
        totalPay: json["total_pay"] == null ? "" : json["total_pay"].toString(),
        coinDeducted: json["coin_deducted"] == null
            ? ""
            : json["coin_deducted"].toString(),
        earningCoins: json["earning_coins"] == null
            ? ""
            : json["earning_coins"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "vendor_id": vendorId == null ? null : vendorId,
        "bill_id": billId == null ? null : billId,
        "customer_id": customerId == null ? null : customerId,
        "mobile": mobile == null ? null : mobile,
        "bill_amount": billAmount == null ? null : billAmount,
        "total_pay": totalPay == null ? null : totalPay,
        "coin_deducted": coinDeducted == null ? null : coinDeducted,
        "earning_coins": earningCoins == null ? null : earningCoins,
      };
}
