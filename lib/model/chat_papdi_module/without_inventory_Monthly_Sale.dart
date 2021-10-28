// To parse this JSON data, do
//
//     final withoutInventoryMonthlySaleResponse = withoutInventoryMonthlySaleResponseFromMap(jsonString);

import 'dart:convert';

class WithoutInventoryMonthlySaleResponse {
  WithoutInventoryMonthlySaleResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  WithoutInventoryMonthlySaleData? data;

  factory WithoutInventoryMonthlySaleResponse.fromJson(String str) =>
      WithoutInventoryMonthlySaleResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WithoutInventoryMonthlySaleResponse.fromMap(
          Map<String, dynamic> json) =>
      WithoutInventoryMonthlySaleResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : WithoutInventoryMonthlySaleData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class WithoutInventoryMonthlySaleData {
  WithoutInventoryMonthlySaleData({
    required this.month,
    required this.saleAmount,
  });

  String month;
  int saleAmount;

  factory WithoutInventoryMonthlySaleData.fromJson(String str) =>
      WithoutInventoryMonthlySaleData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WithoutInventoryMonthlySaleData.fromMap(Map<String, dynamic> json) =>
      WithoutInventoryMonthlySaleData(
        month: json["Month"] == null ? null : json["Month"],
        saleAmount: json["Sale_amount"] == null ? null : json["Sale_amount"],
      );

  Map<String, dynamic> toMap() => {
        "Month": month == null ? null : month,
        "Sale_amount": saleAmount == null ? null : saleAmount,
      };
}
