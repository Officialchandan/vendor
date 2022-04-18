// To parse this JSON data, do
//
//     final normalLadgerResponse = normalLadgerResponseFromMap(jsonString);

import 'dart:convert';

class NormalLedgerResponse {
  NormalLedgerResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.directBilling,
  });

  bool success;
  String message;
  List<OrderData> data;
  List<OrderData> directBilling;

  factory NormalLedgerResponse.fromJson(String str) => NormalLedgerResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NormalLedgerResponse.fromMap(Map<String, dynamic> json) => NormalLedgerResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null ? [] : List<OrderData>.from(json["data"].map((x) => OrderData.fromMap(x))),
        directBilling: json["direct_billing"] == null
            ? []
            : List<OrderData>.from(json["direct_billing"].map((x) => OrderData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toMap())),
        "direct_billing": directBilling == null ? null : List<dynamic>.from(directBilling.map((x) => x.toMap())),
      };
}

class OrderData {
  OrderData({
    required this.vendorId,
    required this.firstName,
    required this.mobile,
    required this.orderId,
    required this.orderTotal,
    required this.myprofitRevenue,
    required this.status,
    required this.dateTime,
    required this.isReturn,
    required this.totalearningcoins,
    required this.orderDetails,
    required this.billingDetails,
    required this.vendorGivenCoins,
    // required this.orderType,
  });

  String vendorId;

  String firstName;
  String mobile;
  String orderId;
  String orderTotal;
  String myprofitRevenue;
  int status;
  DateTime dateTime;
  int isReturn;
  String totalearningcoins;
  List<OrderDetail> orderDetails;
  List<BillingDetail> billingDetails;
  String vendorGivenCoins;
  int orderType = 0;

  factory OrderData.fromJson(String str) => OrderData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderData.fromMap(Map<String, dynamic> json) => OrderData(
        vendorId: json["vendor_id"] == null ? "" : json["vendor_id"].toString(),
        firstName: json["first_name"] == null ? "" : json["first_name"],
        mobile: json["mobile"] == null ? "" : json["mobile"],
        orderId: json["order_id"] == null ? "" : json["order_id"].toString(),
        vendorGivenCoins: json["vendor_given_coins"] == null ? "" : json["vendor_given_coins"].toString(),
        orderTotal: json["order_total"] == null ? "0" : json["order_total"].toString(),
        myprofitRevenue: json["myprofit_revenue"] == null ? "" : json["myprofit_revenue"].toString(),
        status: json["status"] == null ? -1 : json["status"],
        dateTime: json["date_time"] == null ? DateTime.now() : DateTime.parse(json["date_time"]),
        isReturn: json["is_return"] == null ? -1 : json["is_return"],
        totalearningcoins: json["total_earning_coins"] == null ? "" : json["total_earning_coins"].toString(),
        orderDetails: json["order_details"] == null
            ? []
            : List<OrderDetail>.from(json["order_details"].map((x) => OrderDetail.fromMap(x))),
        billingDetails: json["billing_details"] == null
            ? []
            : List<BillingDetail>.from(json["billing_details"].map((x) => BillingDetail.fromMap(x))),
        // orderType: json["order_id"] == null ? 0 : 1
      );

  Map<String, dynamic> toMap() => {
        "vendor_id": vendorId == null ? null : vendorId,
        "first_name": firstName == null ? null : firstName,
        "mobile": mobile == null ? null : mobile,
        "order_id": orderId == null ? null : orderId,
        "vendor_given_coins": vendorGivenCoins == null ? null : vendorGivenCoins,
        "order_total": orderTotal == null ? null : orderTotal,
        "myprofit_revenue": myprofitRevenue == null ? null : myprofitRevenue,
        "status": status == null ? null : status,
        "date_time": dateTime == null ? null : dateTime.toIso8601String(),
        "is_return": isReturn == null ? null : isReturn,
        "total_earning_coins": totalearningcoins == null ? null : totalearningcoins,
        "order_details": orderDetails == null ? null : List<dynamic>.from(orderDetails.map((x) => x.toMap())),
      };

  @override
  String toString() {
    return 'OrderData{vendorId: $vendorId, firstName: $firstName, mobile: $mobile, orderId: $orderId, orderTotal: $orderTotal, myprofitRevenue: $myprofitRevenue, status: $status, dateTime: $dateTime, isReturn: $isReturn, orderDetails: $orderDetails, billingDetails: $billingDetails, orderType: $orderType}';
  }
}

/*class DirectBilling {
  DirectBilling({
    required this.vendorId,
    required this.billingId,
    required this.firstName,
    required this.mobile,
    required this.orderTotal,
    required this.myprofitRevenue,
    required this.status,
    required this.isReturn,
    required this.dateTime,
    required this.billingDetails,
  });

  int vendorId;
  int billingId;
  String firstName;
  String mobile;
  int orderTotal;
  String myprofitRevenue;
  int status;
  int isReturn;
  DateTime dateTime;
  List<BillingDetail> billingDetails;

  factory DirectBilling.fromJson(String str) => DirectBilling.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DirectBilling.fromMap(Map<String, dynamic> json) => DirectBilling(
        vendorId: json["vendor_id"] == null ? 0 : json["vendor_id"],
        billingId: json["billing_id"] == null ? 0 : json["billing_id"],
        firstName: json["first_name"] == null ? "" : json["first_name"],
        mobile: json["mobile"] == null ? "" : json["mobile"],
        orderTotal: json["order_total"] == null ? 0 : json["order_total"],
        myprofitRevenue: json["myprofit_revenue"] == null ? "" : json["myprofit_revenue"],
        status: json["status"] == null ? -1 : json["status"],
        isReturn: json["is_return"] == null ? -1 : json["is_return"],
        dateTime: json["date_time"] == null ? DateTime.now() : DateTime.parse(json["date_time"]),
        billingDetails: json["billing_details"] == null
            ? []
            : List<BillingDetail>.from(json["billing_details"].map((x) => BillingDetail.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "vendor_id": vendorId == null ? null : vendorId,
        "billing_id": billingId == null ? null : billingId,
        "first_name": firstName == null ? null : firstName,
        "mobile": mobile == null ? null : mobile,
        "order_total": orderTotal == null ? null : orderTotal,
        "myprofit_revenue": myprofitRevenue == null ? null : myprofitRevenue,
        "status": status == null ? null : status,
        "is_return": isReturn == null ? null : isReturn,
        "date_time": dateTime == null ? null : dateTime.toIso8601String(),
        "billing_details": billingDetails == null ? null : List<dynamic>.from(billingDetails.map((x) => x.toMap())),
      };
}*/

class OrderDetail {
  OrderDetail({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.qty,
    required this.total,
    required this.amountPaid,
    required this.redeemCoins,
    required this.earningCoins,
    required this.myprofitRevenue,
    required this.isReturn,
  });

  int orderId;
  int productId;
  String productName;
  String productImage;
  String price;
  int qty;
  String total;
  String amountPaid;
  String redeemCoins;
  String earningCoins;
  String myprofitRevenue;
  int isReturn;

  factory OrderDetail.fromJson(String str) => OrderDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderDetail.fromMap(Map<String, dynamic> json) => OrderDetail(
        orderId: json["order_id"] == null ? 0 : json["order_id"],
        productId: json["product_id"] == null ? 0 : json["product_id"],
        productName: json["product_name"] == null ? "" : json["product_name"],
        productImage: json["product_image"] == null ? "" : json["product_image"],
        price: json["price"] == null ? "0" : json["price"],
        qty: json["qty"] == null ? 0 : json["qty"],
        total: json["total"] == null ? "0" : json["total"],
        amountPaid: json["amount_paid"] == null ? "0" : json["amount_paid"],
        redeemCoins: json["redeem_coins"] == null ? "0" : json["redeem_coins"],
        earningCoins: json["earning_coins"] == null ? "0" : json["earning_coins"],
        myprofitRevenue: json["myprofit_revenue"] == null ? "0" : json["myprofit_revenue"],
        isReturn: json["is_return"] == null ? -1 : json["is_return"],
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId == null ? null : orderId,
        "product_id": productId == null ? null : productId,
        "product_name": productName == null ? null : productName,
        "product_image": productImage == null ? null : productImage,
        "price": price == null ? null : price,
        "qty": qty == null ? null : qty,
        "total": total == null ? null : total,
        "amount_paid": amountPaid == null ? null : amountPaid,
        "redeem_coins": redeemCoins == null ? null : redeemCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
        "myprofit_revenue": myprofitRevenue == null ? null : myprofitRevenue,
        "is_return": isReturn == null ? null : isReturn,
      };
}

class BillingDetail {
  BillingDetail({
    required this.categoryId,
    required this.total,
    required this.categoryName,
    required this.categoryImage,
    required this.redeemCoins,
    required this.earningCoins,
    required this.amountPaid,
  });

  String categoryId;
  String total;
  String categoryName;
  String categoryImage;
  String redeemCoins;
  String earningCoins;
  String amountPaid;

  factory BillingDetail.fromJson(String str) => BillingDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BillingDetail.fromMap(Map<String, dynamic> json) => BillingDetail(
        categoryId: json["category_id"] == null ? "0" : json["category_id"],
        total: json["total"] == null ? "0" : json["total"].toString(),
        categoryName: json["category_name"] == null ? "" : json["category_name"].toString(),
        categoryImage: json["category_image"] == null ? "" : json["category_image"].toString(),
        redeemCoins: json["redeem_coins"] == null ? "0" : json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"] == null ? "0" : json["earning_coins"].toString(),
        amountPaid: json["amount_paid"] == null ? "0" : json["amount_paid"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "category_id": categoryId == null ? null : categoryId,
        "total": total == null ? null : total,
        "category_name": categoryName == null ? null : categoryName,
        "category_image": categoryImage == null ? null : categoryImage,
        "redeeme_coins": redeemCoins == null ? null : redeemCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
        "amount_paid": amountPaid == null ? null : amountPaid,
      };
}
