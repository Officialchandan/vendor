// To parse this JSON data, do
//
//     final withoutInventoryMonthlyWalkinResponse = withoutInventoryMonthlyWalkinResponseFromMap(jsonString);

import 'dart:convert';

class WithoutInventoryMonthlyWalkinResponse {
  WithoutInventoryMonthlyWalkinResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  WithoutInventoryMonthlyWalkinData? data;

  factory WithoutInventoryMonthlyWalkinResponse.fromJson(String str) =>
      WithoutInventoryMonthlyWalkinResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WithoutInventoryMonthlyWalkinResponse.fromMap(
          Map<String, dynamic> json) =>
      WithoutInventoryMonthlyWalkinResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : WithoutInventoryMonthlyWalkinData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class WithoutInventoryMonthlyWalkinData {
  WithoutInventoryMonthlyWalkinData({
    required this.month,
    required this.monthlyWalkIns,
  });

  String month;
  String monthlyWalkIns;

  factory WithoutInventoryMonthlyWalkinData.fromJson(String str) =>
      WithoutInventoryMonthlyWalkinData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WithoutInventoryMonthlyWalkinData.fromMap(
          Map<String, dynamic> json) =>
      WithoutInventoryMonthlyWalkinData(
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
