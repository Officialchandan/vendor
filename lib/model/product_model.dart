import 'dart:convert';

import 'package:vendor/model/product_by_category_response.dart';

class ProductModel {
  ProductModel({
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
    required this.productImage,
    required this.image,
    required this.subCategoryId,
  });

  String id;
  String vendorId;
  String categoryId;
  String productName;
  String description;
  String purchasePrice;
  String mrp;
  String sellingPrice;
  String stock;
  String unit;
  String color;
  String size;
  String earningCoins;
  List<String> productImage;
  String image;
  List<SubCategoryId> subCategoryId;

  factory ProductModel.fromJson(String str) => ProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
        id: json["id"] == null ? "0" : json["id"].toString(),
        vendorId: json["vendor_id"] == null ? "0" : json["vendor_id"].toString(),
        categoryId: json["category_id"] == null ? "0" : json["category_id"].toString(),
        productName: json["product_name"] == null ? "" : json["product_name"].toString(),
        description: json["description"] == null ? "" : json["description"].toString(),
        image: json["image"] == null ? "" : json["image"].toString(),
        purchasePrice: json["purchase_price"] == null ? "0" : json["purchase_price"].toString(),
        mrp: json["mrp"] == null ? "" : json["mrp"].toString(),
        sellingPrice: json["selling_price"] == null ? "0" : json["selling_price"].toString(),
        stock: json["stock"] == null ? "0" : json["stock"].toString(),
        unit: json["unit"] == null ? "0" : json["unit"].toString(),
        color: json["color"] == null ? "" : json["color"].toString(),
        size: json["size"] == null ? "" : json["size"].toString(),
        earningCoins: json["earning_coins"] == null ? "" : json["earning_coins"].toString(),
        productImage: json["product_images"] == null ? [] : List<String>.from(json["product_images"].map((x) => x)),
        subCategoryId: json["sub_category_id"] == null
            ? []
            : List<SubCategoryId>.from(json["sub_category_id"].map((x) => SubCategoryId.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "vendor_id": vendorId == null ? null : vendorId,
        "category_id": categoryId == null ? null : categoryId,
        "product_name": productName == null ? null : productName,
        "description": description == null ? null : description,
        "purchase_price": purchasePrice == null ? null : purchasePrice,
        "mrp": mrp == null ? null : mrp,
        "selling_price": sellingPrice == null ? null : sellingPrice,
        "stock": stock == null ? null : stock,
        "unit": unit == null ? null : unit,
        "color": color == null ? null : color,
        "size": size == null ? null : size,
        "image": image == null ? null : image,
        "earning_coins": earningCoins == null ? null : earningCoins,
        "product_image": productImage == null ? null : List<dynamic>.from(productImage.map((x) => x)),
        "sub_category_id": subCategoryId == null ? null : List<dynamic>.from(subCategoryId.map((x) => x.toMap())),
      };
}
