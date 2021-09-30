// To parse this JSON data, do
//
//     final addSuggestedProductResponse = addSuggestedProductResponseFromMap(jsonString);

import 'dart:convert';

class AddSuggestedProductResponse {
  AddSuggestedProductResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  Data? data;

  factory AddSuggestedProductResponse.fromJson(String str) => AddSuggestedProductResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddSuggestedProductResponse.fromMap(Map<String, dynamic> json) => AddSuggestedProductResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class Data {
  Data({
    this.productId,
    this.vendorId,
    this.variantId,
  });

  String? productId;
  String? vendorId;
  List<String>? variantId;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        productId: json["product_id"] == null ? "0" : json["product_id"].toString(),
        vendorId: json["vendor_id"] == null ? "0" : json["vendor_id"].toString(),
        variantId: json["variant_id"] == null ? [] : List<String>.from(json["variant_id"].map((x) => x.toString())),
      );

  Map<String, dynamic> toMap() => {
        "product_id": productId == null ? null : productId,
        "vendor_id": vendorId == null ? null : vendorId,
        "variant_id": variantId == null ? null : List<dynamic>.from(variantId!.map((x) => x)),
      };
}
