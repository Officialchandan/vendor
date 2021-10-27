// To parse this JSON data, do
//
//     final chatPapdiResponse = chatPapdiResponseFromMap(jsonString);

import 'dart:convert';

class ChatPapdiOtpResponse {
  ChatPapdiOtpResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory ChatPapdiOtpResponse.fromJson(String str) =>
      ChatPapdiOtpResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChatPapdiOtpResponse.fromMap(Map<String, dynamic> json) =>
      ChatPapdiOtpResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
