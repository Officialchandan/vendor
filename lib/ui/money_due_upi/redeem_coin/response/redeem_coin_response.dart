import 'dart:convert';

class UpiRedeemCoinResponse {
  UpiRedeemCoinResponse({
    required this.success,
    required this.message,
    required this.normalBilling,
    required this.directBilling,
  });

  bool success;
  String message;
  List<CoinDetail> normalBilling;
  List<CoinDetail> directBilling;

  factory UpiRedeemCoinResponse.fromJson(String str) =>
      UpiRedeemCoinResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpiRedeemCoinResponse.fromMap(Map<String, dynamic> json) =>
      UpiRedeemCoinResponse(
        success: json["success"] == null ? "" : json["success"],
        message: json["message"] == null ? "" : json["message"],
        normalBilling: json["data"] == null
            ? []
            : List<CoinDetail>.from(
                json["data"].map((x) => CoinDetail.fromMap(x))),
        directBilling: json["direct_billing"] == null
            ? []
            : List<CoinDetail>.from(
                json["direct_billing"].map((x) => CoinDetail.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? "" : success,
        "message": message == null ? "" : message,
        "data": normalBilling == null
            ? []
            : List<dynamic>.from(normalBilling.map((x) => x.toMap())),
        "direct_billing": directBilling == null
            ? []
            : List<dynamic>.from(directBilling.map((x) => x.toMap())),
      };
}

class CoinDetail {
  CoinDetail(
      {required this.orderId,
      required this.firstName,
      required this.mobile,
      required this.orderTotal,
      required this.dateTime,
      required this.orderDetails,
      required this.billingDetails});

  String orderId;
  String firstName;
  String mobile;
  String orderTotal;
  String dateTime;
  String image = "";
  String productName = "";
  int billingType = 0;
  List<OrderDetail> orderDetails;
  List<BillingDetail> billingDetails;

  factory CoinDetail.fromJson(String str) =>
      CoinDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CoinDetail.fromMap(Map<String, dynamic> json) => CoinDetail(
        orderId: json["order_id"] == null ? "" : json["order_id"].toString(),
        firstName:
            json["first_name"] == null ? "" : json["first_name"].toString(),
        mobile: json["mobile"] == null ? "" : json["mobile"].toString(),
        orderTotal:
            json["order_total"] == null ? "" : json["order_total"].toString(),
        dateTime: json["date_time"] == null ? "" : json["date_time"].toString(),
        orderDetails: json["order_details"] == null
            ? []
            : List<OrderDetail>.from(
                json["order_details"].map((x) => OrderDetail.fromMap(x))),
        billingDetails: json["billing_details"] == null
            ? []
            : List<BillingDetail>.from(
                json["billing_details"].map((x) => BillingDetail.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId == null ? null : orderId,
        "first_name": firstName == null ? null : firstName,
        "mobile": mobile == null ? null : mobile,
        "order_total": orderTotal == null ? null : orderTotal,
        "date_time": dateTime == null ? null : dateTime,
        "order_details": orderDetails == null
            ? null
            : List<dynamic>.from(orderDetails.map((x) => x.toMap())),
      };
}

class OrderDetail {
  OrderDetail({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.qty,
    required this.price,
    required this.total,
    required this.amountPaid,
    required this.redeemCoins,
    required this.earningCoins,
  });

  String productId;
  String productName;
  String productImage;
  String qty;
  String price;
  String total;
  String amountPaid;
  String redeemCoins;
  String earningCoins;

  factory OrderDetail.fromJson(String str) =>
      OrderDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderDetail.fromMap(Map<String, dynamic> json) => OrderDetail(
        productId:
            json["product_id"] == null ? "" : json["product_id"].toString(),
        productName:
            json["product_name"] == null ? "" : json["product_name"].toString(),
        productImage: json["product_image"] == null
            ? ""
            : json["product_image"].toString(),
        qty: json["qty"] == null ? "" : json["qty"].toString(),
        price: json["price"] == null ? "" : json["price"].toString(),
        total: json["total"] == null ? "" : json["total"].toString(),
        amountPaid:
            json["amount_paid"] == null ? "" : json["amount_paid"].toString(),
        redeemCoins:
            json["redeem_coins"] == null ? "" : json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"] == null
            ? ""
            : json["earning_coins"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "product_id": productId == null ? null : productId,
        "product_name": productName == null ? null : productName,
        "product_image": productImage == null ? null : productImage,
        "qty": qty == null ? null : qty,
        "price": price == null ? null : price,
        "total": total == null ? null : total,
        "amount_paid": amountPaid == null ? null : amountPaid,
        "redeem_coins": redeemCoins == null ? null : redeemCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
      };
}

class BillingDetail {
  BillingDetail({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.amountPaid,
    required this.redeemedCoins,
    required this.earningCoins,
  });

  String categoryId;
  String categoryName;
  String categoryImage;
  String amountPaid;
  String redeemedCoins;
  String earningCoins;

  factory BillingDetail.fromJson(String str) =>
      BillingDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BillingDetail.fromMap(Map<String, dynamic> json) => BillingDetail(
        categoryId:
            json["category_id"] == null ? "" : json["category_id"].toString(),
        categoryName: json["category_name"] == null
            ? ""
            : json["category_name"].toString(),
        categoryImage: json["category_image"] == null
            ? ""
            : json["category_image"].toString(),
        amountPaid:
            json["amount_paid"] == null ? "" : json["amount_paid"].toString(),
        redeemedCoins: json["redeemed_coins"] == null
            ? ""
            : json["redeemed_coins"].toString(),
        earningCoins: json["earning_coins"] == null
            ? ""
            : json["earning_coins"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "category_id": categoryId == null ? null : categoryId,
        "category_name": categoryName == null ? null : categoryName,
        "category_image": categoryImage == null ? null : categoryImage,
        "amount_paid": amountPaid == null ? null : amountPaid,
        "redeemed_coins": redeemedCoins == null ? null : redeemedCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
      };
}
