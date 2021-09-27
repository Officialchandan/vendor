// To parse this JSON data, do
//
//     final getPurchasedProductResponse = getPurchasedProductResponseFromMap(jsonString);

import 'dart:convert';

class GetPurchasedProductResponse {
  GetPurchasedProductResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<PurchaseProductModel>? data;

  factory GetPurchasedProductResponse.fromJson(String str) => GetPurchasedProductResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetPurchasedProductResponse.fromMap(Map<String, dynamic> json) => GetPurchasedProductResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null ? [] : List<PurchaseProductModel>.from(json["data"].map((x) => PurchaseProductModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class PurchaseProductModel {
  PurchaseProductModel({
    required this.productId,
    required this.vendorId,
    required this.customerId,
    required this.productName,
    required this.qty,
    required this.price,
    required this.total,
    required this.redeemCoins,
    required this.earningCoins,
  });

  String productId;
  String vendorId;
  String customerId;
  String productName;
  int qty;
  String price;
  String total;
  String redeemCoins;
  String earningCoins;

  factory PurchaseProductModel.fromJson(String str) => PurchaseProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PurchaseProductModel.fromMap(Map<String, dynamic> json) => PurchaseProductModel(
        productId: json["product_id"] == null ? "0" : json["product_id"].toString(),
        vendorId: json["vendor_id"] == null ? "0" : json["vendor_id"].toString(),
        customerId: json["customer_id"] == null ? "0" : json["customer_id"].toString(),
        productName: json["product_name"] == null ? "" : json["product_name"].toString(),
        qty: json["qty"] == null ? 0 : json["qty"],
        price: json["price"] == null ? "" : json["price"].toString(),
        total: json["total"] == null ? "" : json["total"].toString(),
        redeemCoins: json["redeem_coins"] == null ? "" : json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"] == null ? "" : json["earning_coins"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "product_id": productId == null ? null : productId,
        "vendor_id": vendorId == null ? null : vendorId,
        "customer_id": customerId == null ? null : customerId,
        "product_name": productName == null ? null : productName,
        "qty": qty == null ? null : qty,
        "price": price == null ? null : price,
        "total": total == null ? null : total,
        "redeem_coins": redeemCoins == null ? null : redeemCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
      };
}
