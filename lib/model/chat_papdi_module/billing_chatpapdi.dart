// To parse this JSON data, do
//
//     final chatPapdiResponse = chatPapdiResponseFromMap(jsonString);

import 'dart:convert';

class ChatPapdiResponse {
  ChatPapdiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  ChatPapdiData? data;

  factory ChatPapdiResponse.fromJson(String str) => ChatPapdiResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChatPapdiResponse.fromMap(Map<String, dynamic> json) => ChatPapdiResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : ChatPapdiData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class ChatPapdiData {
  ChatPapdiData({
    required this.vendorId,
    required this.billId,
    required this.customerId,
    required this.mobile,
    required this.billAmount,
    required this.totalPay,
    required this.coinDeducted,
    required this.earningCoins,
    required this.myProfitRevenue,
    required this.qrCodeStatus,
    required this.remainingOrdAmt,
    required this.freeGiftName,
    required this.vendorAvailableCoins,
  });

  String vendorId;
  String billId;
  String customerId;
  String mobile;
  String billAmount;
  String totalPay;
  String coinDeducted;
  String earningCoins;
  String myProfitRevenue;
  int qrCodeStatus;
  String remainingOrdAmt;
  String freeGiftName;
  String vendorAvailableCoins;

  factory ChatPapdiData.fromJson(String str) => ChatPapdiData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChatPapdiData.fromMap(Map<String, dynamic> json) => ChatPapdiData(
        vendorId: json["vendor_id"] == null ? "" : json["vendor_id"].toString(),
        billId: json["bill_id"] == null ? "" : json["bill_id"].toString(),
        customerId: json["customer_id"] == null ? "" : json["customer_id"].toString(),
        mobile: json["mobile"] == null ? "" : json["mobile"].toString(),
        billAmount: json["bill_amount"] == null ? "" : json["bill_amount"].toString(),
        totalPay: json["total_pay"] == null ? "" : json["total_pay"].toString(),
        coinDeducted: json["coin_deducted"] == null ? "" : json["coin_deducted"].toString(),
        earningCoins: json["earning_coins"] == null ? "" : json["earning_coins"].toString(),
        myProfitRevenue: json["myprofit_revenue"] == null ? "" : json["myprofit_revenue"].toString(),
        qrCodeStatus: json["qr_code_status"] == null ? null : json["qr_code_status"],
        remainingOrdAmt: json["remaining_ord_amt"] == null ? "0" : json["remaining_ord_amt"].toString(),
        freeGiftName: json["free_gift__name"] == null ? "" : json["free_gift__name"].toString(),
        vendorAvailableCoins: json["vendor_available_coins"] == null ? "" : json["vendor_available_coins"].toString(),
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
        "myprofit_revenue": myProfitRevenue == null ? null : myProfitRevenue,
        "qr_code_status": qrCodeStatus == null ? null : qrCodeStatus,
        "remaining_ord_amt": remainingOrdAmt == null ? null : remainingOrdAmt,
        "free_gift__name": freeGiftName == null ? null : freeGiftName,
        "vendor_available_coins": vendorAvailableCoins == null ? null : vendorAvailableCoins,
      };
}
