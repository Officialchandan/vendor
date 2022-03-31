// To parse this JSON data, do
//
//     final intiatePaymnetResponse = intiatePaymnetResponseFromMap(jsonString);

import 'dart:convert';

class IntiatePaymnetResponse {
  IntiatePaymnetResponse({
    required this.success,
    required this.message,
    required this.signature,
    required this.txnToken,
    required this.mid,
    required this.orderId,
    required this.callbackUrl,
  });

  bool success;
  String message;
  String signature;
  String txnToken;
  String mid;
  String orderId;
  String callbackUrl;

  factory IntiatePaymnetResponse.fromJson(String str) => IntiatePaymnetResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory IntiatePaymnetResponse.fromMap(Map<String, dynamic> json) => IntiatePaymnetResponse(
        success: json["success"] == null ? 0 : json["success"],
        message: json["message"] == null ? "" : json["message"].toString(),
        signature: json["signature"] == null ? "" : json["signature"].toString(),
        txnToken: json["txnToken"] == null ? "" : json["txnToken"].toString(),
        mid: json["mid"] == null ? "" : json["mid"].toString(),
        orderId: json["orderId"] == null ? "" : json["orderId"].toString(),
        callbackUrl: json["callbackUrl"] == null ? null : json["callbackUrl"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "signature": signature == null ? null : signature,
        "txnToken": txnToken == null ? null : txnToken,
        "mid": mid == null ? null : mid,
        "orderId": orderId == null ? null : orderId,
        "callbackUrl": callbackUrl == null ? null : callbackUrl,
      };
}
