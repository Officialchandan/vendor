// To parse this JSON data, do
//
//     final monthlyEarningAmountResponse = monthlyEarningAmountResponseFromMap(jsonString);

import 'dart:convert';

class MonthlyEarningAmountResponse {
  MonthlyEarningAmountResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  MonthlyEarningAmountData? data;

  factory MonthlyEarningAmountResponse.fromJson(String str) =>
      MonthlyEarningAmountResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MonthlyEarningAmountResponse.fromMap(Map<String, dynamic> json) =>
      MonthlyEarningAmountResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : MonthlyEarningAmountData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class MonthlyEarningAmountData {
  MonthlyEarningAmountData({
    required this.month,
    required this.monthlyEarning,
  });

  String month;
  String monthlyEarning;

  factory MonthlyEarningAmountData.fromJson(String str) =>
      MonthlyEarningAmountData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MonthlyEarningAmountData.fromMap(Map<String, dynamic> json) =>
      MonthlyEarningAmountData(
        month: json["Month"] == null ? "" : json["Month"].toString(),
        monthlyEarning: json["monthly_earning"] == null
            ? ""
            : json["monthly_earning"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "Month": month == null ? null : month,
        "monthly_earning": monthlyEarning == null ? null : monthlyEarning,
      };
}
