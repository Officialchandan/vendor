import 'dart:convert';

class SaleReturnResponse {
  SaleReturnResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  SaleReturnData? data;

  factory SaleReturnResponse.fromJson(String str) =>
      SaleReturnResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SaleReturnResponse.fromMap(Map<String, dynamic> json) =>
      SaleReturnResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data:
            json["data"] == null ? null : SaleReturnData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class SaleReturnData {
  SaleReturnData({
    required this.vendorId,
    required this.orderId,
    required this.customerId,
    required this.productId,
    required this.mobile,
    required this.qty,
    required this.reason,
    required this.amountPaid,
    required this.earnCoins,
    required this.redeemCoins,
    required this.walletBalance,
  });

  String vendorId;
  String orderId;
  int customerId;
  String productId;
  String mobile;
  String qty;
  String reason;
  String earnCoins;
  String amountPaid;
  String redeemCoins;
  String walletBalance;

  factory SaleReturnData.fromJson(String str) =>
      SaleReturnData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SaleReturnData.fromMap(Map<String, dynamic> json) => SaleReturnData(
        vendorId: json["vendor_id"] == null ? "" : json["vendor_id"].toString(),
        orderId: json["order_id"] == null ? "" : json["order_id"].toString(),
        customerId: json["customer_id"] == null ? 0 : json["customer_id"],
        productId:
            json["product_id"] == null ? "" : json["product_id"].toString(),
        mobile: json["mobile"] == null ? "" : json["mobile"].toString(),
        qty: json["qty"] == null ? "" : json["qty"].toString(),
        reason: json["reason"] == null ? "" : json["reason"].toString(),
        amountPaid:
            json["amount_paid"] == null ? "" : json["amount_paid"].toString(),
        earnCoins: json["earning_coins"] == null
            ? ""
            : json["earning_coins"].toString(),
        walletBalance: json["wallet_balance"] == null
            ? ""
            : json["wallet_balance"].toString(),
        redeemCoins:
            json["redeem_coins"] == null ? "" : json["redeem_coins"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "vendor_id": vendorId == null ? null : vendorId,
        "order_id": orderId == null ? null : orderId,
        "customer_id": customerId == null ? null : customerId,
        "product_id": productId == null ? null : productId,
        "mobile": mobile == null ? null : mobile,
        "qty": qty == null ? null : qty,
        "reason": reason == null ? null : reason,
        "wallet_balance": walletBalance == null ? null : walletBalance,
        "earning_coins": earnCoins == null ? null : walletBalance,
        "amount_paid": amountPaid == null ? null : walletBalance,
        "redeem_coins": redeemCoins == null ? null : redeemCoins,
      };
}
