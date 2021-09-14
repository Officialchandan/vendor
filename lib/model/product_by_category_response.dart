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
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null ? [] : List<ProductModel>.from(json["data"].map((x) => ProductModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class SubCategoryId {
  SubCategoryId({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory SubCategoryId.fromJson(String str) => SubCategoryId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubCategoryId.fromMap(Map<String, dynamic> json) => SubCategoryId(
        id: json["id"] == null ? "0" : json["id"].toString(),
        name: json["name"] == null ? "" : json["name"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}

// class ProductByCategoryResponse {
//   ProductByCategoryResponse({
//     required this.success,
//     required this.message,
//     this.data,
//   });
//
//   bool success;
//   String message;
//   List<ProductModel>? data;
//
//   factory ProductByCategoryResponse.fromJson(String str) => ProductByCategoryResponse.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory ProductByCategoryResponse.fromMap(Map<String, dynamic> json) => ProductByCategoryResponse(
//         success: json["success"] == null ? false : json["success"],
//         message: json["message"] == null ? "not found" : json["message"],
//         data: json["data"] == null ? [] : List<ProductModel>.from(json["data"].map((x) => ProductModel.fromMap(x))),
//       );
//
//   Map<String, dynamic> toMap() => {
//         "success": success,
//         "message": message,
//         "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
//       };
// }
//
// class ProductModel {
//   ProductModel({
//     required this.id,
//     this.productName,
//     this.sellingPrice,
//     this.mrp,
//     this.productImage,
//   });
//
//   String id;
//   String? productName;
//   String? sellingPrice;
//   String? mrp;
//   List<String>? productImage;
//
//   factory ProductModel.fromJson(String str) => ProductModel.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
//         id: json["id"] == null ? "0" : json["id"].toString(),
//         productName: json["product_name"] == null ? "" : json["product_name"],
//         sellingPrice: json["selling_price"] == null ? "0.0" : json["selling_price"].toString(),
//         mrp: json["mrp"] == null ? "0.0" : json["mrp"].toString(),
//         productImage: json["product_image"] == null ? [] : List<String>.from(json["product_image"].map((x) => x)),
//       );
//
//   Map<String, dynamic> toMap() => {
//         "id": id == null ? null : id,
//         "product_name": productName == null ? null : productName,
//         "selling_price": sellingPrice == null ? null : sellingPrice,
//         "mrp": mrp == null ? null : mrp,
//         "product_image": productImage == null ? null : List<dynamic>.from(productImage!.map((x) => x)),
//       };
// }
