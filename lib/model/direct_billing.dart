// To parse this JSON data, do
//
//     final directBillingResponse = directBillingResponseFromMap(jsonString);

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
    required this.billId,
    required this.customerId,
    required this.mobile,
    required this.total,
    required this.earningCoins,
  });

  int billId;
  int customerId;
  String mobile;
  String total;
  double earningCoins;

  factory DirectBillingData.fromJson(String str) =>
      DirectBillingData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DirectBillingData.fromMap(Map<String, dynamic> json) =>
      DirectBillingData(
        billId: json["bill_id"] == null ? null : json["bill_id"],
        customerId: json["customer_id"] == null ? null : json["customer_id"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        total: json["total"] == null ? null : json["total"],
        earningCoins: json["earning_coins"] == null
            ? null
            : json["earning_coins"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "bill_id": billId == null ? null : billId,
        "customer_id": customerId == null ? null : customerId,
        "mobile": mobile == null ? null : mobile,
        "total": total == null ? null : total,
        "earning_coins": earningCoins == null ? null : earningCoins,
      };
}
