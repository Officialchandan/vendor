// To parse this JSON data, do
//
//     final dailySellAmountResponse = dailySellAmountResponseFromMap(jsonString);

import 'dart:convert';

class DailySellAmountResponse {
  DailySellAmountResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  DailySellAmountData? data;

  factory DailySellAmountResponse.fromJson(String str) =>
      DailySellAmountResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DailySellAmountResponse.fromMap(Map<String, dynamic> json) =>
      DailySellAmountResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : DailySellAmountData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : data!.toMap(),
      };
}

class DailySellAmountData {
  DailySellAmountData({
    required this.date,
    required this.todaySaleAmount,
  });

  String date;
  String todaySaleAmount;

  factory DailySellAmountData.fromJson(String str) =>
      DailySellAmountData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DailySellAmountData.fromMap(Map<String, dynamic> json) =>
      DailySellAmountData(
        date: json["date"] == null ? "" : json["date"].toString(),
        todaySaleAmount: json["today_sale_amount"] == null
            ? ""
            : json["today_sale_amount"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "date": date == null ? null : date,
        "today_sale_amount": todaySaleAmount == null ? null : todaySaleAmount,
      };
}
