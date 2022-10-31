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

  factory BillingProductResponse.fromJson(String str) => BillingProductResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BillingProductResponse.fromMap(Map<String, dynamic> json) => BillingProductResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : BillingProductData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
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
    required this.myprofitrevenue,
    required this.orderDate,
    required this.qrCodeStatus,
    required this.remainingOrdAmt,
    required this.freeGiftName,
    required this.vendorAvailableCoins,
  });

  int orderId;
  int customerId;
  String mobile;
  int otp;
  String vendorId;
  String totalPay;
  String redeemCoins;
  String earningCoins;
  String myprofitrevenue;
  String orderDate;
  int qrCodeStatus;
  String remainingOrdAmt;
  String freeGiftName;
  String vendorAvailableCoins;

  factory BillingProductData.fromJson(String str) => BillingProductData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BillingProductData.fromMap(Map<String, dynamic> json) => BillingProductData(
        orderId: json["order_id"] == null ? null : json["order_id"],
        customerId: json["customer_id"] == null ? null : json["customer_id"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        otp: json["otp"] == null ? null : json["otp"],
        vendorId: json["vendor_id"].toString(),
        totalPay: json["total_pay"].toString(),
        redeemCoins: json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"].toString(),
        myprofitrevenue: json["myprofit_revenue"] == null ? "" : json["myprofit_revenue"].toString(),
        orderDate: json["order_date"] == null ? "" : json["order_date"].toString(),
        qrCodeStatus: json["qr_code_status"] == null ? -1 : json["qr_code_status"],
        remainingOrdAmt: json["remaining_ord_amt"] == null ? "0" : json["remaining_ord_amt"].toString(),
        freeGiftName: json["free_gift__name"] == null ? "" : json["free_gift__name"].toString(),
        vendorAvailableCoins: json["vendor_available_coins"] == null ? "" : json["vendor_available_coins"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId,
        "customer_id": customerId,
        "mobile": mobile,
        "otp": otp,
        "vendor_id": vendorId,
        "total_pay": totalPay,
        "redeem_coins": redeemCoins,
        "earning_coins": earningCoins,
        "myprofit_revenue": myprofitrevenue,
        "order_date": orderDate,
        "qr_code_status": qrCodeStatus == null ? null : qrCodeStatus,
        "remaining_ord_amt": remainingOrdAmt == null ? null : remainingOrdAmt,
        "free_gift__name": freeGiftName == null ? null : freeGiftName,
        "vendor_available_coins": vendorAvailableCoins == null ? null : vendorAvailableCoins,
      };
}
