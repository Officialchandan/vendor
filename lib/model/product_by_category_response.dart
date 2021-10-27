import 'dart:convert';

import 'package:vendor/model/product_model.dart';

class ProductByCategoryResponse {
  ProductByCategoryResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<ProductModel>? data;

  factory ProductByCategoryResponse.fromJson(String str) => ProductByCategoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductByCategoryResponse.fromMap(Map<String, dynamic> json) => ProductByCategoryResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : List<ProductModel>.from(json["data"].map((x) => ProductModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success  ,
        "message": message ,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}
