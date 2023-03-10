// To parse this JSON data, do
//
//     final getMyCustomerResponse = getMyCustomerResponseFromMap(jsonString);

import 'dart:convert';

class GetMyCustomerResponse {
  GetMyCustomerResponse({
    required this.success,
    required this.message,
    this.data,
    this.directBilling,
  });

  bool success;
  String message;
  List<Customer>? data;
  List<Customer>? directBilling;

  factory GetMyCustomerResponse.fromJson(String str) => GetMyCustomerResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetMyCustomerResponse.fromMap(Map<String, dynamic> json) => GetMyCustomerResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? [] : List<Customer>.from(json["data"].map((x) => Customer.fromMap(x))),
        directBilling: json["direct_billing"] == null
            ? []
            : List<Customer>.from(json["direct_billing"].map((x) => Customer.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "direct_billing": directBilling == null ? null : List<dynamic>.from(directBilling!.map((x) => x.toMap())),
      };
}

class Customer {
  Customer({
    required this.customerId,
    required this.customerName,
    required this.mobile,
    required this.qty,
    required this.date,
  });

  String customerId;
  String customerName;
  String mobile;

  String qty;
  DateTime date;

  factory Customer.fromJson(String str) => Customer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Customer.fromMap(Map<String, dynamic> json) => Customer(
        customerId: json["customer_id"] == null ? "" : json["customer_id"].toString(),
        customerName: json["customer_name"] == null ? "" : json["customer_name"].toString(),
        mobile: json["mobile"] == null ? "" : json["mobile"].toString(),
        qty: json["qty"] == null ? "" : json["qty"].toString(),
        date: json["date"] == null ? DateTime.now() : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toMap() => {
        "customer_id": customerId,
        "customer_name": customerName,
        "mobile": mobile,
        "qty": qty,
      };
}
