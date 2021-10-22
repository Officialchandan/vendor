// To parse this JSON data, do
//
//     final getDueAmountResponse = getDueAmountResponseFromMap(jsonString);

import 'dart:convert';

class GetDueAmountResponse {
  GetDueAmountResponse({
    required this.success,
    required this.message,
    required this.totalDue,
  });

  bool success;
  String message;
  String totalDue;

  factory GetDueAmountResponse.fromJson(String str) => GetDueAmountResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetDueAmountResponse.fromMap(Map<String, dynamic> json) => GetDueAmountResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        totalDue: json["total_due"] == null ? "0" : json["total_due"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "total_due": totalDue == null ? null : totalDue,
      };
}
