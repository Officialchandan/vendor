// To parse this JSON data, do
//
//     final monthlySellAmountResponse = monthlySellAmountResponseFromMap(jsonString);

import 'dart:convert';

class MonthlySellAmountResponse {
  MonthlySellAmountResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  MonthlySellAmountData? data;

  factory MonthlySellAmountResponse.fromJson(String str) =>
      MonthlySellAmountResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MonthlySellAmountResponse.fromMap(Map<String, dynamic> json) =>
      MonthlySellAmountResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : MonthlySellAmountData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class MonthlySellAmountData {
  MonthlySellAmountData({
    required this.month,
    required this.saleAmount,
  });

  String month;
  String saleAmount;

  factory MonthlySellAmountData.fromJson(String str) =>
      MonthlySellAmountData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MonthlySellAmountData.fromMap(Map<String, dynamic> json) =>
      MonthlySellAmountData(
        month: json["Month"] == null ? "" : json["Month"].toString(),
        saleAmount:
            json["Sale_amount"] == null ? "" : json["Sale_amount"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "Month": month == null ? null : month,
        "Sale_amount": saleAmount == null ? null : saleAmount,
      };
}
