// To parse this JSON data, do
//
//     final upiHistroyOrdersLedgerResponse = upiHistroyOrdersLedgerResponseFromMap(jsonString);

import 'dart:convert';

class UpiHistroyOrdersLedgerResponse {
  UpiHistroyOrdersLedgerResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<UpiHistroyOrdersLedgerData>? data;

  factory UpiHistroyOrdersLedgerResponse.fromJson(String str) =>
      UpiHistroyOrdersLedgerResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpiHistroyOrdersLedgerResponse.fromMap(Map<String, dynamic> json) => UpiHistroyOrdersLedgerResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<UpiHistroyOrdersLedgerData>.from(json["data"].map((x) => UpiHistroyOrdersLedgerData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class UpiHistroyOrdersLedgerData {
  UpiHistroyOrdersLedgerData({
    required this.orderId,
    required this.categoryId,
    required this.productName,
    required this.productImage,
    required this.total,
    required this.amountPaid,
    required this.redeemCoins,
    required this.earningCoins,
    required this.commissionPercentage,
    required this.vendorMyProfit,
    required this.myProfitVendor,
    required this.isReturn,
    required this.date,
  });

  int orderId;
  int categoryId;
  String productName;
  String productImage;
  String total;
  String amountPaid;
  String redeemCoins;
  String earningCoins;
  String commissionPercentage;
  String vendorMyProfit;
  String myProfitVendor;
  int isReturn;
  DateTime date;

  factory UpiHistroyOrdersLedgerData.fromJson(String str) => UpiHistroyOrdersLedgerData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpiHistroyOrdersLedgerData.fromMap(Map<String, dynamic> json) => UpiHistroyOrdersLedgerData(
        orderId: json["order_id"] == null ? null : json["order_id"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        productName: json["product_name"] == null ? "" : json["product_name"].toString(),
        productImage: json["product_image"] == null ? "" : json["product_image"].toString(),
        total: json["total"] == null ? "" : json["total"].toString(),
        amountPaid: json["amount_paid"] == null ? "" : json["amount_paid"].toString(),
        redeemCoins: json["redeem_coins"] == null ? "" : json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"] == null ? "" : json["earning_coins"].toString(),
        commissionPercentage: json["commission_percentage"] == null ? "" : json["commission_percentage"].toString(),
        vendorMyProfit: json["vendor_myProfit"] == null ? "" : json["vendor_myProfit"].toString(),
        myProfitVendor: json["myProfit_vendor"] == null ? "" : json["myProfit_vendor"].toString(),
        isReturn: json["is_return"] == null ? "" : json["is_return"],
        date: json["date"] == null ? DateTime.now() : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId == null ? null : orderId,
        "category_id": categoryId == null ? null : categoryId,
        "product_name": productName == null ? null : productName,
        "product_image": productImage == null ? null : productImage,
        "total": total == null ? null : total,
        "amount_paid": amountPaid == null ? null : amountPaid,
        "redeem_coins": redeemCoins == null ? null : redeemCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
        "commission_percentage": commissionPercentage == null ? null : commissionPercentage,
        "vendor_myProfit": vendorMyProfit == null ? null : vendorMyProfit,
        "myProfit_vendor": myProfitVendor == null ? null : myProfitVendor,
        "is_return": isReturn == null ? null : isReturn,
        "date": date == null ? null : date.toIso8601String(),
      };
}
