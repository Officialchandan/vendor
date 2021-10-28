// To parse this JSON data, do
//
//     final withoutInventoryHourlyEarningResponse = withoutInventoryHourlyEarningResponseFromMap(jsonString);

import 'dart:convert';

class WithoutInventoryHourlyEarningResponse {
  WithoutInventoryHourlyEarningResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  Map<String, String>? data;

  factory WithoutInventoryHourlyEarningResponse.fromJson(String str) =>
      WithoutInventoryHourlyEarningResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WithoutInventoryHourlyEarningResponse.fromMap(
          Map<String, dynamic> json) =>
      WithoutInventoryHourlyEarningResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : Map.from(json["data"])
                .map((k, v) => MapEntry<String, String>(k, v.toString())),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? ""
            : Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
