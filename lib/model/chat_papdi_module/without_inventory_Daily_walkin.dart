// To parse this JSON data, do
//
//     final withoutInventoryDailyWalkinResponse = withoutInventoryDailyWalkinResponseFromMap(jsonString);

import 'dart:convert';

class WithoutInventoryDailyWalkinResponse {
  WithoutInventoryDailyWalkinResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  WithoutInventoryDailyWalkinData? data;

  factory WithoutInventoryDailyWalkinResponse.fromJson(String str) =>
      WithoutInventoryDailyWalkinResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WithoutInventoryDailyWalkinResponse.fromMap(
          Map<String, dynamic> json) =>
      WithoutInventoryDailyWalkinResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : WithoutInventoryDailyWalkinData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class WithoutInventoryDailyWalkinData {
  WithoutInventoryDailyWalkinData({
    required this.today,
    required this.todayWalkIns,
    required this.yesterday,
    required this.yesterdayWalkIns,
  });

  String today;
  String todayWalkIns;
  String yesterday;
  String yesterdayWalkIns;

  factory WithoutInventoryDailyWalkinData.fromJson(String str) =>
      WithoutInventoryDailyWalkinData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WithoutInventoryDailyWalkinData.fromMap(Map<String, dynamic> json) =>
      WithoutInventoryDailyWalkinData(
        today: json["today"] == null ? "" : json["today"].toString(),
        todayWalkIns: json["today_walkIns"] == null
            ? ""
            : json["today_walkIns"].toString(),
        yesterday:
            json["yesterday"] == null ? "" : json["yesterday"].toString(),
        yesterdayWalkIns: json["yesterday_walkIns"] == null
            ? ""
            : json["yesterday_walkIns"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "today": today == null ? null : today,
        "today_walkIns": todayWalkIns == null ? null : todayWalkIns,
        "yesterday": yesterday == null ? null : yesterday,
        "yesterday_walkIns": yesterdayWalkIns == null ? null : yesterdayWalkIns,
      };
}
