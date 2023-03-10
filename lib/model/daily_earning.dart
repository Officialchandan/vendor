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
        "success": success,
        "message": message,
        "data": data == null ? null : data!.toMap(),
      };
}

class DailyEarningAmountData {
  DailyEarningAmountData({
    required this.date,
    required this.todayEarning,
  });

  String date;
  String todayEarning;

  factory DailyEarningAmountData.fromJson(String str) =>
      DailyEarningAmountData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DailyEarningAmountData.fromMap(Map<String, dynamic> json) =>
      DailyEarningAmountData(
        date: json["date"] == null ? "" : json["date"].toString(),
        todayEarning: json["today_earning"] == null
            ? ""
            : json["today_earning"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "date": date == null ? null : date,
        "today_earning": todayEarning == null ? null : todayEarning,
      };
}
