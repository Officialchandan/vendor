import 'dart:convert';

import 'product_model.dart';

class GetCustomerProductResponse {
  GetCustomerProductResponse({
    required this.success,
    required this.message,
    this.data,
    this.directBilling,
  });

  bool success;
  String message;
  List<CommnModel>? data;
  List<CommnModel>? directBilling;

  factory GetCustomerProductResponse.fromJson(String str) => GetCustomerProductResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetCustomerProductResponse.fromMap(Map<String, dynamic> json) => GetCustomerProductResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null ? [] : List<CommnModel>.from(json["data"].map((x) => CommnModel.fromMap(x))),
        directBilling: json["direct_billing"] == null
            ? []
            : List<CommnModel>.from(json["direct_billing"].map((x) => CommnModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
        "direct_billing": directBilling == null ? null : List<dynamic>.from(directBilling!.map((x) => x.toMap())),
      };
}

class CustomerProduct {
  CustomerProduct({
    required this.orderId,
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.qty,
    required this.price,
    required this.total,
    required this.amountPaid,
    required this.redeemCoins,
    required this.earningCoins,
    required this.date,
    required this.commissionValue,
    required this.productImages,
  });

  String orderId;
  int productId;
  int categoryId;

  String productName;
  String qty;
  String price;
  String total;
  String amountPaid;
  String redeemCoins;
  String earningCoins;
  String date;
  String commissionValue;

  List<ProductImage> productImages;

  factory CustomerProduct.fromJson(String str) => CustomerProduct.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CustomerProduct.fromMap(Map<String, dynamic> json) => CustomerProduct(
        orderId: json["order_id"] == null ? "" : json["order_id"].toString(),
        productId: json["product_id"] == null ? 0 : json["product_id"],
        categoryId: json["category_id"] == null ? 0 : json["category_id"],
        productName: json["product_name"] == null ? "" : json["product_name"].toString(),
        qty: json["qty"] == null ? "0" : json["qty"].toString(),
        price: json["price"] == null ? "0" : json["price"].toString(),
        total: json["total"] == null ? "0" : json["total"].toString(),
        amountPaid: json["amount_paid"] == null ? "0" : json["amount_paid"].toString(),
        redeemCoins: json["redeem_coins"] == null ? "0" : json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"] == null ? "0" : json["earning_coins"].toString(),
        date: json["date"] == null ? "" : json["date"].toString(),
        commissionValue: json["commission_value"] == null ? "" : json["commission_value"].toString(),
        productImages: json["product_images"] == null
            ? []
            : List<ProductImage>.from(json["product_images"].map((x) => ProductImage.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId,
        "product_name": productName,
        "qty": qty,
        "price": price,
        "total": total,
        "redeem_coins": redeemCoins,
        "earning_coins": earningCoins,
      };
}

class DirectBilling {
  DirectBilling(
      {required this.billingId,
      required this.categoryId,
      required this.categoryName,
      required this.categoryImage,
      required this.total,
      required this.amountPaid,
      required this.redeemCoins,
      required this.earningCoins,
      required this.date,
      required this.commissionValue});

  int billingId;
  String categoryId;
  String categoryName;
  String categoryImage;
  String total;
  String amountPaid;
  String redeemCoins;
  String earningCoins;
  String date;
  String commissionValue;
  factory DirectBilling.fromJson(String str) => DirectBilling.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DirectBilling.fromMap(Map<String, dynamic> json) => DirectBilling(
        billingId: json["billing_id"] == null ? 0 : json["billing_id"],
        categoryId: json["category_id"] == null ? "0" : json["category_id"].toString(),
        categoryName: json["category_name"] == null ? "0" : json["category_name"].toString(),
        categoryImage: json["category_image"] == null ? "" : json["category_image"].toString(),
        total: json["total"] == null ? "" : json["total"].toString(),
        amountPaid: json["amount_paid"] == null ? "" : json["amount_paid"].toString(),
        redeemCoins: json["redeem_coins"] == null ? "" : json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"] == null ? "" : json["earning_coins"].toString(),
        date: json["date"] == null ? "" : json["date"].toString(),
        commissionValue: json["commission_value"] == null ? "" : json["commission_value"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "billing_id": billingId == null ? null : billingId,
        "category_id": categoryId == null ? null : categoryId,
        "category_name": categoryName == null ? null : categoryName,
        "category_image": categoryImage == null ? null : categoryImage,
        "total": total == null ? null : total,
        "amount_paid": amountPaid == null ? null : amountPaid,
        "redeem_coins": redeemCoins == null ? null : redeemCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
        "date": date == null ? null : date,
      };
}

class CommnModel {
  CommnModel({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.qty,
    required this.price,
    required this.total,
    required this.amountPaid,
    required this.redeemCoins,
    required this.earningCoins,
    required this.date,
    required this.productImages,
    required this.billingId,
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.commissionValue,
  });
  String orderId;
  int productId;
  String productName;
  String qty;
  String price;
  String total;
  String amountPaid;
  String redeemCoins;
  String earningCoins;
  String date;
  int billingId;
  String categoryId;
  String categoryName;
  String categoryImage;
  List<ProductImage> productImages;
  int orderType = 0;
  String commissionValue;
  factory CommnModel.fromJson(String str) => CommnModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CommnModel.fromMap(Map<String, dynamic> json) => CommnModel(
        billingId: json["billing_id"] == null ? 0 : json["billing_id"],
        categoryId: json["category_id"] == null ? "0" : json["category_id"].toString(),
        categoryName: json["category_name"] == null ? "0" : json["category_name"].toString(),
        categoryImage: json["category_image"] == null ? "0" : json["category_image"].toString(),
        orderId: json["order_id"] == null ? "" : json["order_id"].toString(),
        productId: json["product_id"] == null ? 0 : json["product_id"],
        productName: json["product_name"] == null ? "" : json["product_name"].toString(),
        qty: json["qty"] == null ? "0" : json["qty"].toString(),
        price: json["price"] == null ? "0" : json["price"].toString(),
        total: json["total"] == null ? "0" : json["total"].toString(),
        amountPaid: json["amount_paid"] == null ? "0" : json["amount_paid"].toString(),
        redeemCoins: json["redeem_coins"] == null ? "0" : json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"] == null ? "0" : json["earning_coins"].toString(),
        date: json["date"] == null ? "" : json["date"].toString(),
        productImages: json["product_images"] == null
            ? []
            : List<ProductImage>.from(json["product_images"].map((x) => ProductImage.fromMap(x))),
        commissionValue: json["commission_value"] == null ? "" : json["commission_value"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "billing_id": billingId == null ? null : billingId,
        "order_id": orderId,
        "product_name": productName,
        "qty": qty,
        "price": price,
        "total": total,
        "redeem_coins": redeemCoins,
        "earning_coins": earningCoins,
      };
}
