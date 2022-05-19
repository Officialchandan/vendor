// To parse this JSON data, do
//
//     final getMyCustomerResponse = getMyCustomerResponseFromMap(jsonString);

import 'dart:convert';

class GetMyChatPapdiCustomerResponse {
  GetMyChatPapdiCustomerResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<Customer>? data;

  factory GetMyChatPapdiCustomerResponse.fromJson(String str) =>
      GetMyChatPapdiCustomerResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetMyChatPapdiCustomerResponse.fromMap(Map<String, dynamic> json) => GetMyChatPapdiCustomerResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : List<Customer>.from(json["data"].map((x) => Customer.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Customer {
  Customer({
    required this.billingId,
    required this.customerId,
    required this.customerName,
    required this.mobile,
    required this.qty,
    required this.date,
    required this.amountSpend,
    required this.billingDetails,
  });
  int billingId;
  int customerId;
  String customerName;
  String mobile;
  String amountSpend;
  String qty;
  DateTime date;
  List<BillingDetail> billingDetails;
  factory Customer.fromJson(String str) => Customer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Customer.fromMap(Map<String, dynamic> json) => Customer(
        billingId: json["billing_id"] == null ? 0 : json["billing_id"],
        customerId: json["customer_id"] == null ? 0 : json["customer_id"],
        customerName: json["customer_name"] == null ? "" : json["customer_name"].toString(),
        mobile: json["mobile"] == null ? "" : json["mobile"].toString(),
        qty: json["qty"] == null ? "" : json["qty"].toString(),
        amountSpend: json["amount_spend"] == null ? "0" : json["amount_spend"].toString(),
        date: json["date"] == null ? DateTime.now() : DateTime.parse(json["date"]),
        billingDetails: json["billing_details"] == null
            ? []
            : List<BillingDetail>.from(json["billing_details"].map((x) => BillingDetail.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "customer_name": customerName,
        "mobile": mobile,
        "qty": qty,
        "billing_details": billingDetails == null ? [] : List<dynamic>.from(billingDetails.map((x) => x.toMap())),
      };
}

class BillingDetail {
  BillingDetail({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.total,
    required this.amountPaid,
    required this.redeemCoins,
    required this.earningCoins,
  });

  String categoryId;
  String categoryName;
  String categoryImage;
  String total;
  String amountPaid;
  String redeemCoins;
  String earningCoins;

  factory BillingDetail.fromJson(String str) => BillingDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BillingDetail.fromMap(Map<String, dynamic> json) => BillingDetail(
        categoryId: json["category_id"] == null ? "" : json["category_id"].toString(),
        categoryName: json["category_name"] == null ? "" : json["category_name"].toString(),
        categoryImage: json["category_image"] == null ? "" : json["category_image"].toString(),
        total: json["total"] == null ? "" : json["total"].toString(),
        amountPaid: json["amount_paid"] == null ? "" : json["amount_paid"].toString(),
        redeemCoins: json["redeem_coins"] == null ? "" : json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"] == null ? "" : json["earning_coins"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "category_id": categoryId == null ? null : categoryId,
        "category_name": categoryName == null ? null : categoryName,
        "category_image": categoryImage == null ? null : categoryImage,
        "total": total == null ? null : total,
        "amount_paid": amountPaid == null ? null : amountPaid,
        "redeem_coins": redeemCoins == null ? null : redeemCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
      };
}
