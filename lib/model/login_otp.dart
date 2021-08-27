import 'dart:convert';

class LoginOtpResponse {
  LoginOtpResponse({
    required this.success,
    required this.message,
    this.status,
  });

  bool success;
  String message;
  String? status;

  factory LoginOtpResponse.fromJson(String str) =>
      LoginOtpResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginOtpResponse.fromMap(Map<String, dynamic> json) =>
      LoginOtpResponse(
        success: json["success"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "status": status,
      };
}
