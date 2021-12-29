import 'dart:convert';

class NotificationStatusResponse {
  NotificationStatusResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory NotificationStatusResponse.fromJson(String str) =>
      NotificationStatusResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationStatusResponse.fromMap(Map<String, dynamic> json) =>
      NotificationStatusResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
