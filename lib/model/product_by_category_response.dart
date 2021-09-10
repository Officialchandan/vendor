import 'dart:convert';

class ProductByCategoryResponse {
  ProductByCategoryResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<ProductModel>? data;

  factory ProductByCategoryResponse.fromJson(String str) =>
      ProductByCategoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductByCategoryResponse.fromMap(Map<String, dynamic> json) =>
      ProductByCategoryResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null
            ? []
            : List<ProductModel>.from(
                json["data"].map((x) => ProductModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

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
    required this.colorName,
    required this.colorCode,
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
  String colorName;
  String colorCode;
  String size;
  String earningCoins;
  List<String> productImage;
  String image;
  List<SubCategoryId> subCategoryId;
  bool check = false;
  int count = 1;

  factory ProductModel.fromJson(String str) =>
      ProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
        id: json["id"] == null ? "0" : json["id"].toString(),
        vendorId:
            json["vendor_id"] == null ? "0" : json["vendor_id"].toString(),
        categoryId:
            json["category_id"] == null ? "0" : json["category_id"].toString(),
        productName:
            json["product_name"] == null ? "" : json["product_name"].toString(),
        description:
            json["description"] == null ? "" : json["description"].toString(),
        image: json["image"] == null
            ? "https://www.google.com/search?q=image+shoes&rlz=1C5CHFA_enIN909IN909&tbm=isch&source=iu&ictx=1&fir=1eAXsIOMhITEWM%252C82uK0WP-tI6vyM%252C_&vet=1&usg=AI4_-kTdzHtyQO2J-wxtKsHa1Styi4sReQ&sa=X&ved=2ahUKEwiH4oGi-fHyAhXCXSsKHUKUAagQ9QF6BAgWEAE#imgrc=1eAXsIOMhITEWM"
            : json["image"].toString(),
        purchasePrice: json["purchase_price"] == null
            ? "0"
            : json["purchase_price"].toString(),
        mrp: json["mrp"] == null ? "" : json["mrp"].toString(),
        sellingPrice: json["selling_price"] == null
            ? "0"
            : json["selling_price"].toString(),
        stock: json["stock"] == null ? "0" : json["stock"].toString(),
        unit: json["unit"] == null ? "0" : json["unit"].toString(),
        colorName: json["color_name"] == null ? "Black" : json["color_name"],
        colorCode: json["color_code"] == null ? "#000000" : json["color_code"],
        size: json["size"] == null ? "" : json["size"].toString(),
        earningCoins: json["earning_coins"] == null
            ? ""
            : json["earning_coins"].toString(),
        productImage: json["product_images"] == null
            ? []
            : List<String>.from(json["product_images"].map((x) => x)),
        subCategoryId: json["sub_category_id"] == null
            ? []
            : List<SubCategoryId>.from(
                json["sub_category_id"].map((x) => SubCategoryId.fromMap(x))),
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
        "color_name": colorName == null ? null : colorName,
        "color_code": colorCode == null ? null : colorCode,
        "size": size == null ? null : size,
        "image": image == null ? null : image,
        "earning_coins": earningCoins == null ? null : earningCoins,
        "product_image": productImage == null
            ? "null"
            : List<dynamic>.from(productImage.map((x) => x)),
        "sub_category_id": subCategoryId == null
            ? null
            : List<dynamic>.from(subCategoryId.map((x) => x.toMap())),
      };
}

class SubCategoryId {
  SubCategoryId({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory SubCategoryId.fromJson(String str) =>
      SubCategoryId.fromMap(json.decode(str));

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
