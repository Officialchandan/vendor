import 'dart:convert';

class CommonResponse {
  CommonResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory CommonResponse.fromJson(String str) => CommonResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CommonResponse.fromMap(Map<String, dynamic> json) => CommonResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
      };
}
