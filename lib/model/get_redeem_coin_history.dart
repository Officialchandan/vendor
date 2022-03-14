// To parse this JSON data, do
//
//     final getRedeemCoinHistoryResponse = getRedeemCoinHistoryResponseFromMap(jsonString);

import 'dart:convert';

class GetRedeemCoinHistoryResponse {
  GetRedeemCoinHistoryResponse({
    required this.success,
    required this.message,
    this.data,
    this.directBilling,
  });

  bool success;
  String message;
  List<GetRedeemCoinHistoryData>? data;
  List<GetRedeemCoinHistoryDirectBillingData>? directBilling;

  factory GetRedeemCoinHistoryResponse.fromJson(String str) => GetRedeemCoinHistoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetRedeemCoinHistoryResponse.fromMap(Map<String, dynamic> json) => GetRedeemCoinHistoryResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<GetRedeemCoinHistoryData>.from(json["data"].map((x) => GetRedeemCoinHistoryData.fromMap(x))),
        directBilling: json["direct_billing"] == null
            ? null
            : List<GetRedeemCoinHistoryDirectBillingData>.from(
                json["direct_billing"].map((x) => GetRedeemCoinHistoryDirectBillingData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "direct_billing": directBilling == null ? [] : List<dynamic>.from(directBilling!.map((x) => x.toMap())),
      };
}

class GetRedeemCoinHistoryData {
  GetRedeemCoinHistoryData({
    required this.orderId,
    required this.firstName,
    required this.mobile,
    required this.orderTotal,
    required this.dateTime,
    required this.orderDetails,
  });

  int orderId;
  String firstName;
  String mobile;
  String orderTotal;
  String dateTime;
  List<OrderDetail> orderDetails;

  factory GetRedeemCoinHistoryData.fromJson(String str) => GetRedeemCoinHistoryData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetRedeemCoinHistoryData.fromMap(Map<String, dynamic> json) => GetRedeemCoinHistoryData(
        orderId: json["order_id"] == null ? "" : json["order_id"],
        firstName: json["first_name"] == null ? "" : json["first_name"].toString(),
        mobile: json["mobile"] == null ? "" : json["mobile"].toString(),
        orderTotal: json["order_total"] == null ? "" : json["order_total"].toString(),
        dateTime: json["date_time"] == null ? "" : json["date_time"].toString(),
        orderDetails: json["order_details"] == null
            ? []
            : List<OrderDetail>.from(json["order_details"].map((x) => OrderDetail.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId == null ? null : orderId,
        "first_name": firstName == null ? null : firstName,
        "mobile": mobile == null ? null : mobile,
        "order_total": orderTotal == null ? null : orderTotal,
        "date_time": dateTime == null ? null : dateTime.toString(),
        "order_details": orderDetails == null ? null : List<dynamic>.from(orderDetails.map((x) => x.toMap())),
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

  int productId;
  String productName;
  String productImage;
  int qty;
  String price;
  String total;
  String amountPaid;
  String redeemCoins;
  String earningCoins;

  factory OrderDetail.fromJson(String str) => OrderDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderDetail.fromMap(Map<String, dynamic> json) => OrderDetail(
        productId: json["product_id"] == null ? null : json["product_id"],
        productName: json["product_name"] == null ? null : json["product_name"],
        productImage: json["product_image"] == null ? null : json["product_image"],
        qty: json["qty"] == null ? null : json["qty"],
        price: json["price"] == null ? null : json["price"],
        total: json["total"] == null ? null : json["total"],
        amountPaid: json["amount_paid"] == null ? null : json["amount_paid"],
        redeemCoins: json["redeem_coins"] == null ? null : json["redeem_coins"],
        earningCoins: json["earning_coins"] == null ? null : json["earning_coins"],
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

class GetRedeemCoinHistoryDirectBillingData {
  GetRedeemCoinHistoryDirectBillingData({
    required this.billingId,
    required this.firstName,
    required this.mobile,
    required this.billTotal,
    required this.redeemedCoins,
    required this.dateTime,
    required this.billingDetails,
  });

  int billingId;
  String firstName;
  String mobile;
  int billTotal;
  String redeemedCoins;
  DateTime dateTime;
  List<BillingDetail> billingDetails;

  factory GetRedeemCoinHistoryDirectBillingData.fromJson(String str) =>
      GetRedeemCoinHistoryDirectBillingData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetRedeemCoinHistoryDirectBillingData.fromMap(Map<String, dynamic> json) =>
      GetRedeemCoinHistoryDirectBillingData(
        billingId: json["billing_id"] == null ? "" : json["billing_id"],
        firstName: json["first_name"] == null ? "" : json["first_name"],
        mobile: json["mobile"] == null ? "" : json["mobile"],
        billTotal: json["bill_total"] == null ? "" : json["bill_total"],
        redeemedCoins: json["redeemed_coins"] == null ? "" : json["redeemed_coins"],
        dateTime: json["date_time"] == null ? "" : json["date_time"],
        billingDetails: json["billing_details"] == null
            ? []
            : List<BillingDetail>.from(json["billing_details"].map((x) => BillingDetail.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "billing_id": billingId == null ? null : billingId,
        "first_name": firstName == null ? null : firstName,
        "mobile": mobile == null ? null : mobile,
        "bill_total": billTotal == null ? null : billTotal,
        "redeemed_coins": redeemedCoins == null ? null : redeemedCoins,
        "date_time": dateTime == null ? null : dateTime.toIso8601String(),
        "billing_details": billingDetails == null ? null : List<dynamic>.from(billingDetails.map((x) => x.toMap())),
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

  factory BillingDetail.fromJson(String str) => BillingDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BillingDetail.fromMap(Map<String, dynamic> json) => BillingDetail(
        categoryId: json["category_id"] == null ? "" : json["category_id"].toString(),
        categoryName: json["category_name"] == null ? "" : json["category_name"].toString(),
        categoryImage: json["category_image"] == null ? "" : json["category_image"].toString(),
        amountPaid: json["amount_paid"] == null ? "" : json["amount_paid"].toString(),
        redeemedCoins: json["redeemed_coins"] == null ? "" : json["redeemed_coins"].toString(),
        earningCoins: json["earning_coins"] == null ? "" : json["earning_coins"].toString(),
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
