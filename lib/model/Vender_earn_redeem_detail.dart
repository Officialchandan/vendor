// To parse this JSON data, do
//
//     final getvendorearnredeemdetail = getvendorearnredeemdetailFromMap(jsonString);

import 'dart:convert';

class Getvendorearnredeemdetail {
  Getvendorearnredeemdetail({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  VendorDataearnredeem? data;

  factory Getvendorearnredeemdetail.fromJson(String str) =>
      Getvendorearnredeemdetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Getvendorearnredeemdetail.fromMap(Map<String, dynamic> json) =>
      Getvendorearnredeemdetail(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : VendorDataearnredeem.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class VendorDataearnredeem {
  VendorDataearnredeem(
      {required this.totalRedeemption,
      required this.totalCoinGenration,
      required this.totalcostumer});

  var totalRedeemption;
  var totalCoinGenration;
  var totalcostumer;

  factory VendorDataearnredeem.fromJson(String str) =>
      VendorDataearnredeem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VendorDataearnredeem.fromMap(Map<String, dynamic> json) =>
      VendorDataearnredeem(
        totalRedeemption: json["total_redeemption"] == null
            ? null
            : json["total_redeemption"].toDouble(),
        totalCoinGenration: json["total_coin_genration"] == null
            ? null
            : json["total_coin_genration"].toDouble(),
        totalcostumer:
            json["total_customer"] == null ? null : json["total_customer"],
      );

  Map<String, dynamic> toMap() => {
        "total_redeemption": totalRedeemption == null ? null : totalRedeemption,
        "total_coin_genration":
            totalCoinGenration == null ? null : totalCoinGenration,
        "total_customer": totalcostumer == null ? null : totalcostumer,
      };
}
