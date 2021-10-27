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

  factory ChatPapdiResponse.fromJson(String str) =>
      ChatPapdiResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChatPapdiResponse.fromMap(Map<String, dynamic> json) =>
      ChatPapdiResponse(
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
  });

  String vendorId;
  int billId;
  int customerId;
  String mobile;
  String billAmount;
  String totalPay;
  String coinDeducted;
  String earningCoins;

  factory ChatPapdiData.fromJson(String str) =>
      ChatPapdiData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChatPapdiData.fromMap(Map<String, dynamic> json) => ChatPapdiData(
        vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
        billId: json["bill_id"] == null ? null : json["bill_id"],
        customerId: json["customer_id"] == null ? null : json["customer_id"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        billAmount: json["bill_amount"] == null ? null : json["bill_amount"],
        totalPay: json["total_pay"] == null ? null : json["total_pay"],
        coinDeducted:
            json["coin_deducted"] == null ? null : json["coin_deducted"],
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
