// To parse this JSON data, do
//
//     final getFreeCoinHistoryResponse = getFreeCoinHistoryResponseFromMap(jsonString);

import 'dart:convert';

class GetFreeCoinHistoryResponse {
  GetFreeCoinHistoryResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<GetFreeCoinHistoryData>? data;

  factory GetFreeCoinHistoryResponse.fromJson(String str) => GetFreeCoinHistoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetFreeCoinHistoryResponse.fromMap(Map<String, dynamic> json) => GetFreeCoinHistoryResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<GetFreeCoinHistoryData>.from(json["data"].map((x) => GetFreeCoinHistoryData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class GetFreeCoinHistoryData {
  GetFreeCoinHistoryData({
    required this.vendorId,
    required this.customerName,
    required this.orderId,
    required this.mobile,
    required this.coins,
    required this.dateTime,
    required this.orderDetails,
  });

  int vendorId;
  String customerName;
  int orderId;
  String mobile;
  String coins;
  String dateTime;
  List<OrderDetail> orderDetails;

  factory GetFreeCoinHistoryData.fromJson(String str) => GetFreeCoinHistoryData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetFreeCoinHistoryData.fromMap(Map<String, dynamic> json) => GetFreeCoinHistoryData(
        vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
        customerName: json["customer_name"] == null ? "" : json["customer_name"].toString(),
        orderId: json["order_id"] == null ? null : json["order_id"],
        mobile: json["mobile"] == null ? "" : json["mobile"].toString(),
        coins: json["coins"] == null ? "" : json["coins"].toString(),
        dateTime: json["date_time"] == null ? "" : json["date_time"].toString(),
        orderDetails: json["order_details"] == null
            ? []
            : List<OrderDetail>.from(json["order_details"].map((x) => OrderDetail.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "vendor_id": vendorId == null ? null : vendorId,
        "customer_name": customerName == null ? null : customerName,
        "order_id": orderId == null ? null : orderId,
        "mobile": mobile == null ? null : mobile,
        "coins": coins == null ? null : coins,
        "date_time": dateTime == null ? null : dateTime.toString(),
        "order_details": orderDetails == null ? null : List<dynamic>.from(orderDetails.map((x) => x.toMap())),
      };
}

class OrderDetail {
  OrderDetail({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.qty,
    required this.price,
    required this.total,
    required this.amountPaid,
    required this.redeemCoins,
    required this.earningCoins,
  });

  int orderId;
  int productId;
  String productName;
  int qty;
  String price;
  String total;
  String amountPaid;
  String redeemCoins;
  String earningCoins;

  factory OrderDetail.fromJson(String str) => OrderDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderDetail.fromMap(Map<String, dynamic> json) => OrderDetail(
        orderId: json["order_id"] == null ? null : json["order_id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        productName: json["product_name"] == null ? "" : json["product_name"].toString(),
        qty: json["qty"] == null ? null : json["qty"],
        price: json["price"] == null ? "" : json["price"].toString(),
        total: json["total"] == null ? "" : json["total"].toString(),
        amountPaid: json["amount_paid"] == null ? "" : json["amount_paid"].toString(),
        redeemCoins: json["redeem_coins"] == null ? "" : json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"] == null ? "" : json["earning_coins"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId == null ? null : orderId,
        "product_id": productId == null ? null : productId,
        "product_name": productName == null ? null : productName,
        "qty": qty == null ? null : qty,
        "price": price == null ? null : price,
        "total": total == null ? null : total,
        "amount_paid": amountPaid == null ? null : amountPaid,
        "redeem_coins": redeemCoins == null ? null : redeemCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
      };
}
