// To parse this JSON data, do
//
//     final dailyWalkinAmountResponse = dailyWalkinAmountResponseFromMap(jsonString);

import 'dart:convert';

class DailyWalkinAmountResponse {
  DailyWalkinAmountResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  DailyWalkinAmountData? data;

  factory DailyWalkinAmountResponse.fromJson(String str) =>
      DailyWalkinAmountResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DailyWalkinAmountResponse.fromMap(Map<String, dynamic> json) =>
      DailyWalkinAmountResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : DailyWalkinAmountData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class DailyWalkinAmountData {
  DailyWalkinAmountData({
    required this.today,
    required this.dailyWalkIns,
  });

  String today;
  String dailyWalkIns;

  factory DailyWalkinAmountData.fromJson(String str) =>
      DailyWalkinAmountData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DailyWalkinAmountData.fromMap(Map<String, dynamic> json) =>
      DailyWalkinAmountData(
        today: json["today"] == null ? "" : json["today"].toString(),
        dailyWalkIns: json["daily_walkIns"] == null
            ? ""
            : json["daily_walkIns"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "today": today == null ? null : today,
        "daily_walkIns": dailyWalkIns == null ? null : dailyWalkIns,
      };
}
