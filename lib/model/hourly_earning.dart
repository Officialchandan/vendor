// To parse this JSON data, do
//
//     final hourlyEarningAmountResponse = hourlyEarningAmountResponseFromMap(jsonString);

import 'dart:convert';

class HourlyEarningAmountResponse {
  HourlyEarningAmountResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  Map<String, String>? data;

  factory HourlyEarningAmountResponse.fromJson(String str) => HourlyEarningAmountResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HourlyEarningAmountResponse.fromMap(Map<String, dynamic> json) => HourlyEarningAmountResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Map.from(json["data"]).map((k, v) => MapEntry<String, String>(k, v.toString())),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
