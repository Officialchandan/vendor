// To parse this JSON data, do
//
//     final qrcodeResponse = qrcodeResponseFromMap(jsonString);

import 'dart:convert';

class QrcodeResponse {
  QrcodeResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory QrcodeResponse.fromJson(String str) =>
      QrcodeResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QrcodeResponse.fromMap(Map<String, dynamic> json) => QrcodeResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? "" : json["message"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
