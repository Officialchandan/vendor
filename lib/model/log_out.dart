// To parse this JSON data, do
//
//     final hourlySellAmountResponse = hourlySellAmountResponseFromMap(jsonString);

import 'dart:convert';

class LogOutResponse {
  LogOutResponse({
    required this.success,
    this.data,
  });

  bool success;
  LogOutData? data;

  factory LogOutResponse.fromJson(String str) => LogOutResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LogOutResponse.fromMap(Map<String, dynamic> json) => LogOutResponse(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : LogOutData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "data": data == null ? null : data!.toMap(),
      };
}

class LogOutData {
  LogOutData({
    required this.message,
  });

  String message;

  factory LogOutData.fromJson(String str) => LogOutData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LogOutData.fromMap(Map<String, dynamic> json) => LogOutData(
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "message": message,
      };
}
