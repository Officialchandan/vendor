// To parse this JSON data, do
//
//     final upiTansferResponse = upiTansferResponseFromMap(jsonString);

import 'dart:convert';

class UpiTansferResponse {
  UpiTansferResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<UpiTansferData>? data;

  factory UpiTansferResponse.fromJson(String str) => UpiTansferResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpiTansferResponse.fromMap(Map<String, dynamic> json) => UpiTansferResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data:
            json["data"] == null ? null : List<UpiTansferData>.from(json["data"].map((x) => UpiTansferData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class UpiTansferData {
  UpiTansferData({
    required this.id,
    required this.orderId,
    required this.txnAmount,
    required this.paymentMode,
    required this.status,
    required this.responseMsg,
    required this.resultStatus,
    required this.txnDate,
  });

  int id;
  String orderId;
  double txnAmount;
  String paymentMode;
  int status;
  String responseMsg;
  String resultStatus;
  String txnDate;

  factory UpiTansferData.fromJson(String str) => UpiTansferData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpiTansferData.fromMap(Map<String, dynamic> json) => UpiTansferData(
        id: json["id"] == null ? 0 : json["id"],
        orderId: json["order_id"] == null ? "" : json["order_id"].toString(),
        txnAmount: json["txn_amount"] == null ? 0.0 : json["txn_amount"].toDouble(),
        paymentMode: json["payment_mode"] == null ? "" : json["payment_mode"].toString(),
        status: json["status"] == null ? 0 : json["status"],
        responseMsg: json["response_msg"] == null ? "" : json["response_msg"].toString(),
        resultStatus: json["result_status"] == null ? "" : json["result_status"].toString(),
        txnDate: json["txn_date"] == null ? "" : json["txn_date"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "order_id": orderId == null ? null : orderId,
        "txn_amount": txnAmount == null ? null : txnAmount,
        "payment_mode": paymentMode == null ? null : paymentMode,
        "status": status == null ? null : status,
        "response_msg": responseMsg == null ? null : responseMsg,
        "result_status": resultStatus == null ? null : resultStatus,
        "txn_date": txnDate == null ? null : txnDate,
      };
}
