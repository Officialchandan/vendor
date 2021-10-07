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
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class DailySellAmountData {
  DailySellAmountData({
    required this.today,
    required this.todaySaleAmount,
    required this.yesterday,
    required this.yesterdaySaleAmount,
  });

  String today;
  String todaySaleAmount;
  String yesterday;
  String yesterdaySaleAmount;

  factory DailySellAmountData.fromJson(String str) =>
      DailySellAmountData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DailySellAmountData.fromMap(Map<String, dynamic> json) =>
      DailySellAmountData(
        today: json["today"] == null ? "" : json["today"].toString(),
        todaySaleAmount: json["today_sale_amount"] == null
            ? ""
            : json["today_sale_amount"].toString(),
        yesterday:
            json["yesterday"] == null ? "" : json["yesterday"].toString(),
        yesterdaySaleAmount: json["yesterday_sale_amount"] == null
            ? ""
            : json["yesterday_sale_amount"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "today": today,
        "today_sale_amount": todaySaleAmount == null ? null : todaySaleAmount,
        "yesterday": yesterday,
        "yesterday_sale_amount":
            yesterdaySaleAmount == null ? null : yesterdaySaleAmount,
      };
}
