// To parse this JSON data, do
//
//     final monthlyWalkinAmountResponse = monthlyWalkinAmountResponseFromMap(jsonString);

import 'dart:convert';

class MonthlyWalkinAmountResponse {
  MonthlyWalkinAmountResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  MonthlyWalkinAmountData? data;

  factory MonthlyWalkinAmountResponse.fromJson(String str) =>
      MonthlyWalkinAmountResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MonthlyWalkinAmountResponse.fromMap(Map<String, dynamic> json) =>
      MonthlyWalkinAmountResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : MonthlyWalkinAmountData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class MonthlyWalkinAmountData {
  MonthlyWalkinAmountData({
    required this.month,
    required this.monthlyWalkIns,
  });

  String month;
  String monthlyWalkIns;

  factory MonthlyWalkinAmountData.fromJson(String str) =>
      MonthlyWalkinAmountData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MonthlyWalkinAmountData.fromMap(Map<String, dynamic> json) =>
      MonthlyWalkinAmountData(
        month: json["month"] == null ? "" : json["month"].toString(),
        monthlyWalkIns: json["monthly_walkIns"] == null
            ? ""
            : json["monthly_walkIns"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "month": month == null ? null : month,
        "monthly_walkIns": monthlyWalkIns == null ? null : monthlyWalkIns,
      };
}
