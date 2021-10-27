// To parse this JSON data, do
//
//     final hourlySaleAmountResponse = hourlySaleAmountResponseFromMap(jsonString);

import 'dart:convert';

class HourlySaleAmountResponse {
  HourlySaleAmountResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  Map<String, String>? data;

  factory HourlySaleAmountResponse.fromJson(String str) => HourlySaleAmountResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HourlySaleAmountResponse.fromMap(Map<String, dynamic> json) => HourlySaleAmountResponse(
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
