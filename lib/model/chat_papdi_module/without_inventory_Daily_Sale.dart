// To parse this JSON data, do
//
//     final withoutInventoryDailySaleResponse = withoutInventoryDailySaleResponseFromMap(jsonString);

import 'dart:convert';

class WithoutInventoryDailySaleResponse {
  WithoutInventoryDailySaleResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  WithoutInventoryDailySaleData? data;

  factory WithoutInventoryDailySaleResponse.fromJson(String str) =>
      WithoutInventoryDailySaleResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WithoutInventoryDailySaleResponse.fromMap(
          Map<String, dynamic> json) =>
      WithoutInventoryDailySaleResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : WithoutInventoryDailySaleData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class WithoutInventoryDailySaleData {
  WithoutInventoryDailySaleData({
    required this.today,
    required this.todaySaleAmount,
    required this.yesterday,
    required this.yesterdaySaleAmount,
  });

  String today;
  String todaySaleAmount;
  String yesterday;
  String yesterdaySaleAmount;

  factory WithoutInventoryDailySaleData.fromJson(String str) =>
      WithoutInventoryDailySaleData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WithoutInventoryDailySaleData.fromMap(Map<String, dynamic> json) =>
      WithoutInventoryDailySaleData(
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
        "today": today == null ? null : today,
        "today_sale_amount": todaySaleAmount == null ? null : todaySaleAmount,
        "yesterday": yesterday == null ? null : yesterday,
        "yesterday_sale_amount":
            yesterdaySaleAmount == null ? null : yesterdaySaleAmount,
      };
}
