// To parse this JSON data, do
//
//     final withoutInventoryDailyEarningResponse = withoutInventoryDailyEarningResponseFromMap(jsonString);

import 'dart:convert';

class WithoutInventoryDailyEarningResponse {
  WithoutInventoryDailyEarningResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  WithoutInventoryDailyEarningData? data;

  factory WithoutInventoryDailyEarningResponse.fromJson(String str) =>
      WithoutInventoryDailyEarningResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WithoutInventoryDailyEarningResponse.fromMap(
          Map<String, dynamic> json) =>
      WithoutInventoryDailyEarningResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : WithoutInventoryDailyEarningData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class WithoutInventoryDailyEarningData {
  WithoutInventoryDailyEarningData({
    required this.today,
    required this.todayEarning,
    required this.yesterday,
    required this.yesterdayEarning,
  });

  String today;
  String todayEarning;
  String yesterday;
  String yesterdayEarning;

  factory WithoutInventoryDailyEarningData.fromJson(String str) =>
      WithoutInventoryDailyEarningData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WithoutInventoryDailyEarningData.fromMap(Map<String, dynamic> json) =>
      WithoutInventoryDailyEarningData(
        today: json["today"] == null ? "" : json["today"].toString(),
        todayEarning: json["today_earning"] == null
            ? ""
            : json["today_earning"].toString(),
        yesterday:
            json["yesterday"] == null ? "" : json["yesterday"].toString(),
        yesterdayEarning: json["yesterday_earning"] == null
            ? ""
            : json["yesterday_earning"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "today": today == null ? null : today,
        "today_earning": todayEarning == null ? null : todayEarning,
        "yesterday": yesterday == null ? null : yesterday,
        "yesterday_earning": yesterdayEarning == null ? null : yesterdayEarning,
      };
}
