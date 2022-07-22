// To parse this JSON data, do
//
//     final upiHistroyOrdersResponse = upiHistroyOrdersResponseFromMap(jsonString);

import 'dart:convert';

class UpiHistroyOrdersResponse {
  UpiHistroyOrdersResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<UpiHistroyOrdersData>? data;

  factory UpiHistroyOrdersResponse.fromJson(String str) => UpiHistroyOrdersResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpiHistroyOrdersResponse.fromMap(Map<String, dynamic> json) => UpiHistroyOrdersResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<UpiHistroyOrdersData>.from(json["data"].map((x) => UpiHistroyOrdersData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class UpiHistroyOrdersData {
  UpiHistroyOrdersData({
    required this.billingId,
    required this.orderId,
    required this.orderTotal,
    required this.vendorMyProfit,
    required this.bankTxnId,
    required this.date,
    required this.mobile,
    required this.isReturn,
    required this.myProfitVendor,
  });

  int billingId;
  int orderId;
  String orderTotal;
  String vendorMyProfit;
  String bankTxnId;
  DateTime date;
  String mobile;
  int isReturn;
  String myProfitVendor;

  factory UpiHistroyOrdersData.fromJson(String str) => UpiHistroyOrdersData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpiHistroyOrdersData.fromMap(Map<String, dynamic> json) => UpiHistroyOrdersData(
        billingId: json["billing_id"] == null ? DateTime.now().hashCode : json["billing_id"],
        orderId: json["order_id"] == null ? DateTime.now().hashCode : json["order_id"],
        orderTotal: json["order_total"].toString(),
        vendorMyProfit: json["vendor_myProfit"] == null ? "" : json["vendor_myProfit"].toString(),
        bankTxnId: json["bank_txn_id"] == null ? "" : json["bank_txn_id"].toString(),
        date: json["date"] == null ? DateTime.now() : DateTime.parse(json["date"]),
        mobile: json["mobile"] == null ? "" : json["mobile"].toString(),
        isReturn: json["is_return"] == null ? 0 : json["is_return"],
        myProfitVendor: json["myProfit_vendor"] == null ? "" : json["myProfit_vendor"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "billing_id": billingId == null ? null : billingId,
        "order_id": orderId == null ? null : orderId,
        "order_total": orderTotal,
        "vendor_myProfit": vendorMyProfit == null ? null : vendorMyProfit,
        "bank_txn_id": bankTxnId == null ? null : bankTxnId,
        "date": date == null ? null : date,
        "mobile": mobile == null ? null : mobile,
        "is_return": isReturn == null ? null : isReturn,
        "myProfit_vendor": myProfitVendor == null ? null : myProfitVendor,
      };
}
