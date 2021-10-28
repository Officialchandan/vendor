// To parse this JSON data, do
//
//     final withoutInventoryMonthlyEarningResponse = withoutInventoryMonthlyEarningResponseFromMap(jsonString);

import 'dart:convert';

class WithoutInventoryMonthlyEarningResponse {
  WithoutInventoryMonthlyEarningResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  WithoutInventoryMonthlyEarningData? data;

  factory WithoutInventoryMonthlyEarningResponse.fromJson(String str) =>
      WithoutInventoryMonthlyEarningResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WithoutInventoryMonthlyEarningResponse.fromMap(
          Map<String, dynamic> json) =>
      WithoutInventoryMonthlyEarningResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : WithoutInventoryMonthlyEarningData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class WithoutInventoryMonthlyEarningData {
  WithoutInventoryMonthlyEarningData({
    required this.month,
    required this.monthlyEarning,
  });

  String month;
  String monthlyEarning;

  factory WithoutInventoryMonthlyEarningData.fromJson(String str) =>
      WithoutInventoryMonthlyEarningData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WithoutInventoryMonthlyEarningData.fromMap(
          Map<String, dynamic> json) =>
      WithoutInventoryMonthlyEarningData(
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
