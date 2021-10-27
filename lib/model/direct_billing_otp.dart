// To parse this JSON data, do
//
//     final directBillingOtpResponse = directBillingOtpResponseFromMap(jsonString);

import 'dart:convert';

class DirectBillingOtpResponse {
  DirectBillingOtpResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory DirectBillingOtpResponse.fromJson(String str) => DirectBillingOtpResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DirectBillingOtpResponse.fromMap(Map<String, dynamic> json) => DirectBillingOtpResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
      };
}
