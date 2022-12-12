// To parse this JSON data, do
//
//     final getDueAmountByDay = getDueAmountByDayFromMap(jsonString);

import 'dart:convert';

class GetDueAmountByDay {
  GetDueAmountByDay({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  DueData? data;

  factory GetDueAmountByDay.fromJson(String str) =>
      GetDueAmountByDay.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetDueAmountByDay.fromMap(Map<String, dynamic> json) =>
      GetDueAmountByDay(
        success: json["success"],
        message: json["message"],
        data: DueData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data!.toMap(),
      };
}

class DueData {
  DueData({
    this.todayDue,
    this.totalDue,
  });

  double? todayDue;
  double? totalDue;

  factory DueData.fromJson(String str) => DueData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DueData.fromMap(Map<String, dynamic> json) => DueData(
        todayDue: json["today_due"].toDouble(),
        totalDue: json["total_due"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "today_due": todayDue,
        "total_due": totalDue,
      };
}
