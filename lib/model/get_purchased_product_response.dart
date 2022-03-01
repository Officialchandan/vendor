// To parse this JSON data, do
//
//     final getPurchasedProductResponse = getPurchasedProductResponseFromMap(jsonString);

import 'dart:convert';

class GetPurchasedProductResponse {
  GetPurchasedProductResponse({
    required this.success,
    required this.message,
    this.data,
    this.directBilling,
  });

  bool success;
  String message;
  List<PurchaseProductModel>? data;
  List<DirectBilling>? directBilling;

  factory GetPurchasedProductResponse.fromJson(String str) =>
      GetPurchasedProductResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetPurchasedProductResponse.fromMap(Map<String, dynamic> json) =>
      GetPurchasedProductResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null
            ? []
            : List<PurchaseProductModel>.from(
                json["data"].map((x) => PurchaseProductModel.fromMap(x))),
        directBilling: json["direct_billing"] == null
            ? null
            : List<DirectBilling>.from(
                json["direct_billing"].map((x) => DirectBilling.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
        "direct_billing": directBilling == null
            ? null
            : List<dynamic>.from(directBilling!.map((x) => x.toMap())),
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
    required this.dateTime,
    required this.orderId,
    required this.productImages,
  }) {
    returnQty = qty;
  }

  String productId;
  String vendorId;
  String customerId;
  String productName;
  int qty;
  String price;
  String total;
  String redeemCoins;
  String earningCoins;
  String dateTime;
  String orderId;
  List<String> productImages;

  bool checked = false;
  int returnQty = 1;

  factory PurchaseProductModel.fromJson(String str) =>
      PurchaseProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PurchaseProductModel.fromMap(Map<String, dynamic> json) =>
      PurchaseProductModel(
        orderId: json["order_id"] == null ? "" : json["order_id"].toString(),
        productId:
            json["product_id"] == null ? "0" : json["product_id"].toString(),
        vendorId:
            json["vendor_id"] == null ? "0" : json["vendor_id"].toString(),
        customerId:
            json["customer_id"] == null ? "0" : json["customer_id"].toString(),
        productName:
            json["product_name"] == null ? "" : json["product_name"].toString(),
        qty: json["qty"] == null ? 0 : json["qty"],
        price: json["price"] == null ? "" : json["price"].toString(),
        total: json["total"] == null ? "" : json["total"].toString(),
        redeemCoins:
            json["redeem_coins"] == null ? "" : json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"] == null
            ? ""
            : json["earning_coins"].toString(),
        productImages: json["product_images"] == null
            ? []
            : List<String>.from(json["product_images"].map((x) => x)),
        dateTime: json["date_time"] == null ? "" : json["date_time"],
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
        "date_time": dateTime == null ? null : dateTime,
        "order_id": orderId == null ? null : orderId,
        "product_images": productImages == null
            ? null
            : List<dynamic>.from(productImages.map((x) => x)),
      };
}

class DirectBilling {
  DirectBilling({
    required this.orderId,
    required this.vendorId,
    required this.categoryId,
    required this.mobile,
    required this.totalPay,
    required this.redeemedCoins,
    required this.amount,
    required this.dateTime,
    required this.categoryName,
  });

  int orderId;
  int vendorId;
  String categoryId;
  String mobile;
  String totalPay;
  String redeemedCoins;
  String amount;
  String dateTime;
  String categoryName;

  factory DirectBilling.fromJson(String str) =>
      DirectBilling.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DirectBilling.fromMap(Map<String, dynamic> json) => DirectBilling(
        orderId: json["order_id"] == null ? 0 : json["order_id"],
        vendorId: json["vendor_id"] == null ? "" : json["vendor_id"],
        categoryId:
            json["category_id"] == null ? "" : json["category_id"].toString(),
        mobile: json["mobile"] == null ? "" : json["mobile"].toString(),
        totalPay: json["total_pay"] == null ? "" : json["total_pay"].toString(),
        redeemedCoins: json["redeemed_coins"] == null
            ? ""
            : json["redeemed_coins"].toString(),
        dateTime: json["date_time"] == null ? "" : json["date_time"],
        amount: json["amount"] == null ? "" : json["amount"].toString(),
        categoryName:
            json["category_name"] == null ? "" : json["category_name"],
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId == null ? null : orderId,
        "vendor_id": vendorId == null ? null : vendorId,
        "category_id": categoryId == null ? null : categoryId,
        "mobile": mobile == null ? null : mobile,
        "total_pay": totalPay == null ? null : totalPay,
        "redeemed_coins": redeemedCoins == null ? null : redeemedCoins,
        "amount": amount == null ? null : amount,
        "date_time": dateTime == null ? null : dateTime,
        "category_name": categoryName == null ? null : categoryName
      };
}

class SaleReturnProducts {
  SaleReturnProducts({
    required this.orderId,
    required this.productId,
    required this.vendorId,
    required this.customerId,
    required this.productName,
    required this.qty,
    required this.price,
    required this.total,
    required this.mobile,
    required this.redeemCoins,
    required this.earningCoins,
    required this.dateTime,
    required this.categoryName,
    required this.productImages,
  }) {
    returnQty = qty;
  }
  String orderId;
  String productId;
  String vendorId;
  String customerId;
  String productName;
  int qty;
  String mobile;
  String price;
  String total;
  String redeemCoins;
  String earningCoins;
  String productImages;
  String dateTime;
  String categoryName;
  int returnQty = 1;
  bool checked = false;
}
