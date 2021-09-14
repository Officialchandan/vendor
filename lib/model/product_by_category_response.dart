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
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<ProductModel>.from(
                json["data"].map((x) => ProductModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class ProductModel {
  ProductModel({
    required this.id,
    required this.productId,
    required this.categoryId,
    required this.vendorId,
    required this.productName,
    required this.description,
    required this.productOptionVariantId,
    required this.purchasePrice,
    required this.mrp,
    required this.sellingPrice,
    required this.stock,
    required this.earningCoins,
    required this.redeemCoins,
    required this.unit,
    required this.productOption,
    required this.productImages,
  });

  int id;
  int productId;
  String categoryId;
  int vendorId;
  String productName;
  String description;
  String productOptionVariantId;
  String purchasePrice;
  int mrp;
  int sellingPrice;
  int stock;
  int earningCoins;
  int redeemCoins;
  int unit;
  List<ProductOption> productOption;
  List<String> productImages;

  bool check = false;
  int count = 1;

  factory ProductModel.fromJson(String str) =>
      ProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
        id: json["id"] == null ? "0" : json["id"],
        productId: json["product_id"] == null ? "0" : json["product_id"],
        categoryId:
            json["category_id"] == null ? "0" : json["category_id"].toString(),
        vendorId: json["vendor_id"] == null ? "0" : json["vendor_id"],
        productName: json["product_name"] == null ? "" : json["product_name"],
        description: json["description"] == null ? "" : json["description"],
        productOptionVariantId: json["product_option_variant_id"] == null
            ? ""
            : json["product_option_variant_id"],
        purchasePrice:
            json["purchase_price"] == null ? "" : json["purchase_price"],
        mrp: json["mrp"] == null ? "0" : json["mrp"],
        sellingPrice:
            json["selling_price"] == null ? "0" : json["selling_price"],
        stock: json["stock"] == null ? "0" : json["stock"],
        earningCoins:
            json["earning_coins"] == null ? "0" : json["earning_coins"],
        redeemCoins: json["redeem_coins"] == null ? "0" : json["redeem_coins"],
        unit: json["unit"] == null ? "0" : json["unit"],
        productOption: json["product_option"] == null
            ? []
            : List<ProductOption>.from(
                json["product_option"].map((x) => ProductOption.fromMap(x))),
        productImages: json["product_images"] == null
            ? [
                "https://www.google.com/imgres?imgurl=https%3A%2F%2Fi.stack.imgur.com%2Fy9DpT.jpg&imgrefurl=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F61244854%2Fadd-a-no-image-placeholder-on-elementor-pro-post-element-if-there-is-no-featured&tbnid=gORET_h3X-RiOM&vet=12ahUKEwiLj-6p9fPyAhWVOisKHaK1CsQQMygBegUIARDPAQ..i&docid=QPagImSLC_KOrM&w=900&h=497&q=image%20place%20holder%20image&ved=2ahUKEwiLj-6p9fPyAhWVOisKHaK1CsQQMygBegUIARDPAQ"
              ]
            : List<String>.from(json["product_images"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "product_id": productId == null ? null : productId,
        "category_id": categoryId == null ? null : categoryId,
        "vendor_id": vendorId == null ? null : vendorId,
        "product_name": productName == null ? null : productName,
        "description": description == null ? null : description,
        "product_option_variant_id":
            productOptionVariantId == null ? null : productOptionVariantId,
        "purchase_price": purchasePrice == null ? null : purchasePrice,
        "mrp": mrp == null ? null : mrp,
        "selling_price": sellingPrice == null ? null : sellingPrice,
        "stock": stock == null ? null : stock,
        "earning_coins": earningCoins == null ? null : earningCoins,
        "redeem_coins": redeemCoins == null ? null : redeemCoins,
        "unit": unit == null ? null : unit,
        "product_option": productOption == null
            ? null
            : List<dynamic>.from(productOption.map((x) => x.toMap())),
        "product_images": productImages == null
            ? null
            : List<dynamic>.from(productImages.map((x) => x)),
      };
}

class ProductOption {
  ProductOption({
    required this.productOptionId,
    required this.optionName,
    required this.value,
  });

  int productOptionId;
  String optionName;
  String value;

  factory ProductOption.fromJson(String str) =>
      ProductOption.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductOption.fromMap(Map<String, dynamic> json) => ProductOption(
        productOptionId:
            json["product_option_id"] == null ? "0" : json["product_option_id"],
        optionName: json["option_name"] == null ? "kala" : json["option_name"],
        value: json["value"] == null ? null : json["value"],
      );

  Map<String, dynamic> toMap() => {
        "product_option_id": productOptionId == null ? null : productOptionId,
        "option_name": optionName == null ? null : optionName,
        "value": value == null ? null : value,
      };
}
