// To parse this JSON data, do
//
//     final dailyEarningAmountResponse = dailyEarningAmountResponseFromMap(jsonString);

import 'dart:convert';

class DailyEarningAmountResponse {
  DailyEarningAmountResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  DailyEarningAmountData? data;

  factory DailyEarningAmountResponse.fromJson(String str) =>
      DailyEarningAmountResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DailyEarningAmountResponse.fromMap(Map<String, dynamic> json) =>
      DailyEarningAmountResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : DailyEarningAmountData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class DailyEarningAmountData {
  DailyEarningAmountData({
    required this.today,
    required this.dailyEarning,
  });

  String today;
  String dailyEarning;

  factory DailyEarningAmountData.fromJson(String str) =>
      DailyEarningAmountData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DailyEarningAmountData.fromMap(Map<String, dynamic> json) =>
      DailyEarningAmountData(
        today: json["today"] == null ? "" : json["today"].toString(),
        dailyEarning: json["daily_earning"] == null
            ? ""
            : json["daily_earning"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "today": today == null ? null : today,
        "daily_earning": dailyEarning == null ? null : dailyEarning,
      };
}
