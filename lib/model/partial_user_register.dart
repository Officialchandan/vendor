// To parse this JSON data, do
//
//     final partialUserRegisterResponse = partialUserRegisterResponseFromMap(jsonString);

import 'dart:convert';

class PartialUserRegisterResponse {
  PartialUserRegisterResponse({
    required this.success,
    required this.message,
    this.status,
  });

  bool success;
  String message;
  int? status;

  factory PartialUserRegisterResponse.fromJson(String str) =>
      PartialUserRegisterResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PartialUserRegisterResponse.fromMap(Map<String, dynamic> json) =>
      PartialUserRegisterResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? "" : json["message"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "status": status == null ? null : status,
      };
}
