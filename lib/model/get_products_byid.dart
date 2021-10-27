// To parse this JSON data, do
//
//     final getProductById = getProductByIdFromMap(jsonString);

import 'dart:convert';

class GetProductById {
  GetProductById({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<GetProductByIdData>? data;

  factory GetProductById.fromJson(String str) => GetProductById.fromMap(json.decode(str));

  factory GetProductById.fromMap(Map<String, dynamic> json) => GetProductById(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : List<GetProductByIdData>.from(json["data"].map((x) => GetProductByIdData.fromMap(x))),
      );
}

class GetProductByIdData {
  GetProductByIdData({
    required this.id,
    required this.vendorId,
    required this.categoryId,
    required this.productName,
    required this.description,
    required this.purchasePrice,
    required this.mrp,
    required this.sellingPrice,
    required this.stock,
    required this.unit,
    required this.color,
    required this.size,
    required this.earningCoins,
    required this.subCategoryId,
    required this.productImages,
  });

  int id;
  int vendorId;
  int categoryId;
  String productName;
  String description;
  int purchasePrice;
  int mrp;
  int sellingPrice;
  int stock;
  int unit;
  String color;
  String size;
  int earningCoins;
  List<SubCategoryId> subCategoryId;
  List<String> productImages;

  factory GetProductByIdData.fromJson(String str) => GetProductByIdData.fromMap(json.decode(str));

  factory GetProductByIdData.fromMap(Map<String, dynamic> json) => GetProductByIdData(
        id: json["id"] == null ? null : json["id"],
        vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        productName: json["product_name"] == null ? null : json["product_name"],
        description: json["description"] == null ? null : json["description"],
        purchasePrice: json["purchase_price"] == null ? null : json["purchase_price"],
        mrp: json["mrp"] == null ? null : json["mrp"],
        sellingPrice: json["selling_price"] == null ? null : json["selling_price"],
        stock: json["stock"] == null ? null : json["stock"],
        unit: json["unit"] == null ? null : json["unit"],
        color: json["color"] == null ? null : json["color"],
        size: json["size"] == null ? null : json["size"],
        earningCoins: json["earning_coins"] == null ? null : json["earning_coins"],
        subCategoryId: json["sub_category_id"],
        productImages: json["product_images"],
      );
}

class SubCategoryId {
  SubCategoryId({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory SubCategoryId.fromJson(String str) => SubCategoryId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubCategoryId.fromMap(Map<String, dynamic> json) => SubCategoryId(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
