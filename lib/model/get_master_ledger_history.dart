// To parse this JSON data, do
//
//     final GetNormalLedgerHistoryResponse = GetNormalLedgerHistoryResponseFromMap(jsonString);

import 'dart:convert';

class GetNormalLedgerHistoryResponse {
  GetNormalLedgerHistoryResponse({
    required this.success,
    required this.message,
    this.data,
    this.directBilling,
  });

  bool success;
  String message;
  List<GetNormalLedgerHistoryData>? data;
  List<GetNormalLedgerHistoryDirectBilling>? directBilling;

  factory GetNormalLedgerHistoryResponse.fromJson(String str) =>
      GetNormalLedgerHistoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetNormalLedgerHistoryResponse.fromMap(Map<String, dynamic> json) => GetNormalLedgerHistoryResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<GetNormalLedgerHistoryData>.from(json["data"].map((x) => GetNormalLedgerHistoryData.fromMap(x))),
        directBilling: json["direct_billing"] == null
            ? []
            : List<GetNormalLedgerHistoryDirectBilling>.from(
                json["direct_billing"].map((x) => GetNormalLedgerHistoryDirectBilling.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
        "direct_billing": directBilling == null ? null : List<dynamic>.from(directBilling!.map((x) => x.toMap())),
      };
}

class GetNormalLedgerHistoryData {
  GetNormalLedgerHistoryData({
    required this.vendorId,
    required this.firstName,
    required this.mobile,
    required this.orderId,
    required this.billingId,
    required this.orderTotal,
    required this.isReturn,
    required this.myprofitRevenue,
    required this.status,
    required this.dateTime,
    required this.orderDetails,
  });

  int vendorId;
  String firstName;
  String mobile;
  String orderId;
  String billingId;
  String orderTotal;
  int isReturn;
  String myprofitRevenue;
  int status;
  String dateTime;
  List<OrderDetail> orderDetails;

  factory GetNormalLedgerHistoryData.fromJson(String str) => GetNormalLedgerHistoryData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetNormalLedgerHistoryData.fromMap(Map<String, dynamic> json) => GetNormalLedgerHistoryData(
        vendorId: json["vendor_id"] == null ? 0 : json["vendor_id"],
        firstName: json["first_name"] == null ? "" : json["first_name"],
        mobile: json["mobile"] == null ? "" : json["mobile"].toString(),
        orderId: json["order_id"] == null ? "" : json["order_id"].toString(),
        billingId: json["billing_id"].toString(),
        orderTotal: json["order_total"] == null ? "" : json["order_total"].toString(),
        isReturn: json["is_return"] == null ? -1 : json["is_return"],
        myprofitRevenue: json["myprofit_revenue"] == null ? "" : json["myprofit_revenue"].toString(),
        status: json["status"] == null ? -1 : json["status"],
        dateTime: json["date_time"] == null ? "" : json["date_time"].toString(),
        orderDetails: json["order_details"] == null
            ? []
            : List<OrderDetail>.from(json["order_details"].map((x) => OrderDetail.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "vendor_id": vendorId == null ? null : vendorId,
        "first_name": firstName == null ? null : firstName,
        "mobile": mobile == null ? null : mobile,
        "order_id": orderId == null ? null : orderId,
        "billing_id": billingId,
        "order_total": orderTotal == null ? null : orderTotal,
        "is_return": isReturn == null ? null : isReturn,
        "myprofit_revenue": myprofitRevenue == null ? null : myprofitRevenue,
        "status": status == null ? null : status,
        "date_time": dateTime == null ? null : dateTime.toString(),
        "order_details": orderDetails == null ? null : List<dynamic>.from(orderDetails.map((x) => x.toMap())),
      };
}

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
        productName: json["product_name"] == null ? "" : json["product_name"].toString(),
        productImage: json["product_image"] == null ? null : json["product_image"],
        price: json["price"] == null ? "" : json["price"].toString(),
        qty: json["qty"] == null ? 0 : json["qty"],
        total: json["total"] == null ? "" : json["total"].toString(),
        amountPaid: json["amount_paid"] == null ? "" : json["amount_paid"].toString(),
        redeemCoins: json["redeem_coins"] == null ? "" : json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"] == null ? "" : json["earning_coins"].toString(),
        myprofitRevenue: json["myprofit_revenue"] == null ? "" : json["myprofit_revenue"].toString(),
        isReturn: json["is_return"] == null ? 0 : json["is_return"],
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

class GetNormalLedgerHistoryDirectBilling {
  GetNormalLedgerHistoryDirectBilling({
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
  String orderTotal;
  String myprofitRevenue;
  int status;
  int isReturn;
  String dateTime;
  List<BillingDetail> billingDetails;

  factory GetNormalLedgerHistoryDirectBilling.fromJson(String str) =>
      GetNormalLedgerHistoryDirectBilling.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetNormalLedgerHistoryDirectBilling.fromMap(Map<String, dynamic> json) => GetNormalLedgerHistoryDirectBilling(
        vendorId: json["vendor_id"] == null ? 0 : json["vendor_id"],
        billingId: json["billing_id"] == null ? 0 : json["billing_id"],
        firstName: json["first_name"] == null ? "" : json["first_name"],
        mobile: json["mobile"] == null ? "" : json["mobile"].toString(),
        orderTotal: json["order_total"] == null ? "" : json["order_total"].toString(),
        myprofitRevenue: json["myprofit_revenue"] == null ? "" : json["myprofit_revenue"].toString(),
        status: json["status"] == null ? 0 : json["status"],
        isReturn: json["is_return"] == null ? 0 : json["is_return"],
        dateTime: json["date_time"] == null ? "" : json["date_time"].toString(),
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
        "date_time": dateTime == null ? null : dateTime.toString(),
        "billing_details": billingDetails == null ? null : List<dynamic>.from(billingDetails.map((x) => x.toMap())),
      };
}

class BillingDetail {
  BillingDetail({
    required this.billingId,
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.redeemCoins,
    required this.earningCoins,
    required this.amountPaid,
  });

  int billingId;
  String categoryId;
  String categoryName;
  String categoryImage;
  String redeemCoins;
  String earningCoins;
  String amountPaid;
  factory BillingDetail.fromJson(String str) => BillingDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BillingDetail.fromMap(Map<String, dynamic> json) => BillingDetail(
        billingId: json["billing_id"] == null ? 0 : json["billing_id"],
        categoryId: json["category_id"] == null ? "" : json["category_id"].toString(),
        categoryName: json["category_name"] == null ? "" : json["category_name"].toString(),
        categoryImage: json["category_image"] == null ? null : json["category_image"],
        redeemCoins: json["redeem_coins"] == null ? "" : json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"] == null ? "" : json["earning_coins"].toString(),
        amountPaid: json["amount_paid"] == null ? "" : json["amount_paid"],
      );

  Map<String, dynamic> toMap() => {
        "billing_id": billingId == null ? null : billingId,
        "category_id": categoryId == null ? null : categoryId,
        "category_name": categoryName == null ? null : categoryName,
        "category_image": categoryImage == null ? null : categoryImage,
        "redeem_coins": redeemCoins == null ? null : redeemCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
        "amount_paid": amountPaid == null ? null : amountPaid,
      };
}

class CommonLedgerHistory {
  CommonLedgerHistory({
    required this.vendorId,
    required this.firstName,
    required this.mobile,
    this.orderId,
    required this.billingId,
    required this.orderTotal,
    required this.myprofitRevenue,
    required this.status,
    required this.dateTime,
    this.orderDetails,
    required this.isReturn,
    this.billingDetails,
  });
  String vendorId;
  String firstName;
  String mobile;
  String? orderId;
  String billingId;
  String orderTotal;
  String myprofitRevenue;
  String status;
  String dateTime;
  String isReturn;
  List<CommonData>? orderDetails;
  List<CommonData>? billingDetails;
  int billingType = 0;
}

class CommonData {
  CommonData({
    required this.orderId,
    required this.billingId,
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.productImage,
    required this.productId,
    required this.productName,
    required this.price,
    required this.qty,
    required this.total,
    required this.amountPaid,
    required this.redeemCoins,
    required this.earningCoins,
    required this.myprofitRevenue,
    required this.isReturn,
  });
  String orderId;
  String billingId;
  String categoryId;
  String categoryName;
  String categoryImage;
  String productImage;
  String productId;
  String productName;
  String price;
  String qty;
  String total;
  String amountPaid;
  String redeemCoins;
  String earningCoins;
  String myprofitRevenue;
  String isReturn;
}
