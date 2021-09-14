// To parse this JSON data, do
//
//     final addProductResponse = addProductResponseFromMap(jsonString);

import 'dart:convert';

class AddProductResponse {
  AddProductResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  ResponseData? data;

  factory AddProductResponse.fromJson(String str) => AddProductResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddProductResponse.fromMap(Map<String, dynamic> json) => AddProductResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null ? null : ResponseData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : data!.toMap(),
      };
}

class ResponseData {
  ResponseData({
    required this.productId,
    required this.vendorId,
    required this.variantId,
  });

  String productId;
  String vendorId;
  List<String> variantId;

  factory ResponseData.fromJson(String str) => ResponseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponseData.fromMap(Map<String, dynamic> json) => ResponseData(
        productId: json["product_id"] == null ? "" : json["product_id"].toString(),
        vendorId: json["vendor_id"] == null ? "" : json["vendor_id"].toString(),
        variantId: json["variant_id"] == null ? [] : List<String>.from(json["variant_id"].map((x) => x.toString())),
      );

  Map<String, dynamic> toMap() => {
        "product_id": productId,
        "vendor_id": vendorId,
        "variant_id": List<String>.from(variantId.map((x) => x.toString())),
      };
}
