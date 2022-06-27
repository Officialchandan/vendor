import 'dart:convert';

class SaleReturnOtp {
  SaleReturnOtp({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory SaleReturnOtp.fromJson(String str) => SaleReturnOtp.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SaleReturnOtp.fromMap(Map<String, dynamic> json) => SaleReturnOtp(
        success: json["success"] == null ? "" : json["success"],
        message: json["message"] == null ? "" : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
