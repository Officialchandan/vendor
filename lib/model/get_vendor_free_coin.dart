// To parse this JSON data, do
//
//     final getVendorFreeCoinResponse = getVendorFreeCoinResponseFromMap(jsonString);

import 'dart:convert';

class GetVendorFreeCoinResponse {
  GetVendorFreeCoinResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  GetVendorFreeCoinData? data;

  factory GetVendorFreeCoinResponse.fromJson(String str) => GetVendorFreeCoinResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetVendorFreeCoinResponse.fromMap(Map<String, dynamic> json) => GetVendorFreeCoinResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : GetVendorFreeCoinData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class GetVendorFreeCoinData {
  GetVendorFreeCoinData({
    required this.vendorId,
    required this.vendorName,
    required this.totalCoins,
    required this.availableCoins,
    required this.dateTime,
  });

  int vendorId;
  String vendorName;
  String totalCoins;
  String availableCoins;
  String dateTime;

  factory GetVendorFreeCoinData.fromJson(String str) => GetVendorFreeCoinData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetVendorFreeCoinData.fromMap(Map<String, dynamic> json) => GetVendorFreeCoinData(
        vendorId: json["vendor_id"] == null ? "" : json["vendor_id"],
        vendorName: json["vendor_name"] == null ? "" : json["vendor_name"],
        totalCoins: json["total_coins"] == null ? "" : json["total_coins"].toString(),
        availableCoins: json["available_coins"] == null ? "" : json["available_coins"].toString(),
        dateTime: json["date_time"] == null ? "" : json["date_time"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "vendor_id": vendorId == null ? null : vendorId,
        "vendor_name": vendorName == null ? null : vendorName,
        "total_coins": totalCoins == null ? null : totalCoins,
        "available_coins": availableCoins == null ? null : availableCoins,
        "date_time": dateTime == null ? null : dateTime.toString(),
      };
}
