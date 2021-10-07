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
    required this.key1,
    required this.value1,
    required this.key2,
    required this.value2,
    required this.key3,
    required this.value3,
  });

  String key1;
  String value1;
  String key2;
  String value2;
  String key3;
  String value3;

  factory HourlySellAmountData.fromJson(String str) =>
      HourlySellAmountData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HourlySellAmountData.fromMap(Map<String, dynamic> json) =>
      HourlySellAmountData(
        key1: json["key1"] == null ? "" : json["key1"].toString(),
        value1: json["value1"] == null ? "" : json["value1"].toString(),
        key2: json["key2"] == null ? "" : json["key2"].toString(),
        value2: json["value2"] == null ? "" : json["value2"].toString(),
        key3: json["key3"] == null ? "" : json["key3"].toString(),
        value3: json["value3"] == null ? "" : json["value3"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "key1": key1 == null ? null : key1,
        "value1": value1 == null ? null : value1,
        "key2": key2 == null ? null : key2,
        "value2": value2 == null ? null : value2,
        "key3": key3 == null ? null : key3,
        "value3": value3 == null ? null : value3,
      };
}
