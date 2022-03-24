import 'dart:convert';

class CustomerRedeemCoinHistory {
  CustomerRedeemCoinHistory({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<RedeemData> data;

  factory CustomerRedeemCoinHistory.fromJson(String str) =>
      CustomerRedeemCoinHistory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CustomerRedeemCoinHistory.fromMap(Map<String, dynamic> json) =>
      CustomerRedeemCoinHistory(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<RedeemData>.from(
                json["data"].map((x) => RedeemData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class RedeemData {
  RedeemData({
    required this.customerId,
    required this.vendorName,
    required this.orderId,
    required this.billingId,
    required this.spendCoins,
    required this.dateTime,
  });

  String customerId;
  String vendorName;
  String orderId;
  String billingId;
  String spendCoins;
  String dateTime;

  factory RedeemData.fromJson(String str) =>
      RedeemData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RedeemData.fromMap(Map<String, dynamic> json) => RedeemData(
        customerId:
            json["customer_id"] == null ? "" : json["customer_id"].toString(),
        vendorName:
            json["vendor_name"] == null ? "" : json["vendor_name"].toString(),
        orderId: json["order_id"] == null ? "" : json["order_id"].toString(),
        billingId:
            json["billing_id"] == null ? "" : json["billing_id"].toString(),
        spendCoins:
            json["spend_coins"] == null ? "" : json["spend_coins"].toString(),
        dateTime: json["date_time"] == null ? "" : json["date_time"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "customer_id": customerId == null ? null : customerId,
        "vendor_name": vendorName == null ? null : vendorName,
        "order_id": orderId,
        "billing_id": billingId == null ? null : billingId,
        "spend_coins": spendCoins == null ? null : spendCoins,
        "date_time": dateTime == null ? null : dateTime,
      };
}
