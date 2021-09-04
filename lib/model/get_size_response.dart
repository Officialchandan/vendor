// To parse this JSON data, do
//
//     final getSizeResponse = getSizeResponseFromMap(jsonString);

import 'dart:convert';

class GetSizeResponse {
  GetSizeResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<ProductSizeModel>? data;

  factory GetSizeResponse.fromJson(String str) => GetSizeResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetSizeResponse.fromMap(Map<String, dynamic> json) => GetSizeResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null ? [] : List<ProductSizeModel>.from(json["data"].map((x) => ProductSizeModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class ProductSizeModel {
  ProductSizeModel({
    required this.id,
    required this.categoryName,
    required this.sizeName,
  });

  String id;
  String categoryName;
  String sizeName;

  factory ProductSizeModel.fromJson(String str) => ProductSizeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductSizeModel.fromMap(Map<String, dynamic> json) => ProductSizeModel(
        id: json["id"] == null ? "0" : json["id"].toString(),
        categoryName: json["category_name"] == null ? "" : json["category_name"].toString(),
        sizeName: json["size_name"] == null ? "" : json["size_name"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "category_name": categoryName == null ? null : categoryName,
        "size_name": sizeName == null ? null : sizeName,
      };
}
