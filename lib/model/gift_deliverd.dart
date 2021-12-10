// To parse this JSON data, do
//
//     final giftDeliverdResponse = giftDeliverdResponseFromMap(jsonString);

import 'dart:convert';

class GiftDeliverdResponse {
  GiftDeliverdResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory GiftDeliverdResponse.fromJson(String str) =>
      GiftDeliverdResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GiftDeliverdResponse.fromMap(Map<String, dynamic> json) =>
      GiftDeliverdResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
