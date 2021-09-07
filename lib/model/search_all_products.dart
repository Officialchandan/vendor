// To parse this JSON data, do
//
//     final getSearchAllProduct = getSearchAllProductFromMap(jsonString);

import 'dart:convert';

class GetSearchAllProduct {
    GetSearchAllProduct({
        required this.success,
        required this.message,
        this.data,
    });

    bool success;
    String message;
    List<GetSearchAllProductData>? data;

    factory GetSearchAllProduct.fromJson(String str) => GetSearchAllProduct.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetSearchAllProduct.fromMap(Map<String, dynamic> json) => GetSearchAllProduct(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : List<GetSearchAllProductData>.from(json["data"].map((x) => GetSearchAllProductData.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class GetSearchAllProductData {
    GetSearchAllProductData({
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

    factory GetSearchAllProductData.fromJson(String str) => GetSearchAllProductData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetSearchAllProductData.fromMap(Map<String, dynamic> json) => GetSearchAllProductData(
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
        "earning_coins": earningCoins == null ? null : earningCoins,
        "sub_category_id": subCategoryId == null ? null : List<dynamic>.from(subCategoryId.map((x) => x.toMap())),
        "product_images": productImages == null ? null : List<dynamic>.from(productImages.map((x) => x)),
    };
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
