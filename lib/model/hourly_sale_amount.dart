// To parse this JSON data, do
//
//     final hourlySellAmountResponse = hourlySellAmountResponseFromMap(jsonString);

import 'dart:convert';

class HourlySellAmountResponse {
  HourlySellAmountResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  HourlySellAmountData? data;

  factory HourlySellAmountResponse.fromJson(String str) =>
      HourlySellAmountResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HourlySellAmountResponse.fromMap(Map<String, dynamic> json) =>
      HourlySellAmountResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : HourlySellAmountData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class HourlySellAmountData {
  HourlySellAmountData({
    required this.saleAmount,
  });

  List<SaleAmount> saleAmount;

  factory HourlySellAmountData.fromJson(String str) =>
      HourlySellAmountData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HourlySellAmountData.fromMap(Map<String, dynamic> json) =>
      HourlySellAmountData(
        saleAmount: List<SaleAmount>.from(
            json["Sale_amount"].map((x) => SaleAmount.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "Sale_amount": saleAmount == null
            ? null
            : List<dynamic>.from(saleAmount.map((x) => x.toMap())),
      };
}

class SaleAmount {
  SaleAmount({
    required this.hourCreatedAt,
    required this.sumTotal,
  });

  String hourCreatedAt;
  String sumTotal;

  factory SaleAmount.fromJson(String str) =>
      SaleAmount.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SaleAmount.fromMap(Map<String, dynamic> json) => SaleAmount(
        hourCreatedAt: json["hour(created_at)"] == null
            ? ""
            : json["hour(created_at)"].toString(),
        sumTotal:
            json["sum(total)"] == null ? "" : json["sum(total)"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "hour(created_at)": hourCreatedAt == null ? null : hourCreatedAt,
        "sum(total)": sumTotal == null ? null : sumTotal,
      };
}
