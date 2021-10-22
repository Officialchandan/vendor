import 'dart:convert';

import 'product_model.dart';

class GetCustomerProductResponse {
  GetCustomerProductResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<CustomerProduct>? data;

  factory GetCustomerProductResponse.fromJson(String str) => GetCustomerProductResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetCustomerProductResponse.fromMap(Map<String, dynamic> json) => GetCustomerProductResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null ? null : List<CustomerProduct>.from(json["data"].map((x) => CustomerProduct.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class CustomerProduct {
  CustomerProduct({
    required this.orderId,
    required this.productName,
    required this.qty,
    required this.price,
    required this.total,
    required this.redeemCoins,
    required this.earningCoins,
    required this.productImages,
  });

  String orderId;
  String productName;
  String qty;
  String price;
  String total;
  String redeemCoins;
  String earningCoins;
  List<ProductImage> productImages;

  factory CustomerProduct.fromJson(String str) => CustomerProduct.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CustomerProduct.fromMap(Map<String, dynamic> json) => CustomerProduct(
        orderId: json["order_id"] == null ? "" : json["order_id"].toString(),
        productName: json["product_name"] == null ? "" : json["product_name"].toString(),
        qty: json["qty"] == null ? "0" : json["qty"].toString(),
        price: json["price"] == null ? "0" : json["price"].toString(),
        total: json["total"] == null ? "0" : json["total"].toString(),
        redeemCoins: json["redeem_coins"] == null ? "0" : json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"] == null ? "0" : json["earning_coins"].toString(),
        productImages:
            json["product_images"] == null ? [] : List<ProductImage>.from(json["product_images"].map((x) => ProductImage.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId == null ? null : orderId,
        "product_name": productName == null ? null : productName,
        "qty": qty == null ? null : qty,
        "price": price == null ? null : price,
        "total": total == null ? null : total,
        "redeem_coins": redeemCoins == null ? null : redeemCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
      };
}
