import 'dart:convert';

class ProductModel {
  ProductModel({
    required this.id,
    required this.productId,
    required this.categoryName,
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

  String id;
  String productId;
  String categoryId;
  String categoryName;
  String vendorId;
  String productName;
  String description;
  String productOptionVariantId;
  String purchasePrice;
  String mrp;
  String sellingPrice;
  int stock;
  String earningCoins;
  String redeemCoins;
  String unit;
  List<ProductOption> productOption;
  List<ProductImage> productImages;

  bool check = false;
  bool billingcheck = false;
  int count = 1;

  factory ProductModel.fromJson(String str) =>
      ProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
        id: json["id"] == null ? "0" : json["id"].toString(),
        productId: json["product_id"] == null ? "0" : json["product_id"].toString(),
        categoryId: json["category_id"] == null ? "0" : json["category_id"].toString(),
        vendorId: json["vendor_id"] == null ? "0" : json["vendor_id"].toString(),
        productName: json["product_name"] == null ? "" : json["product_name"].toString(),
        description: json["description"] == null ? "" : json["description"].toString(),
        productOptionVariantId: json["product_option_variant_id"] == null ? "" : json["product_option_variant_id"].toString(),
        purchasePrice: json["purchase_price"] == null ? "" : json["purchase_price"].toString(),
        mrp: json["mrp"] == null ? "0" : json["mrp"].toString(),
        sellingPrice: json["selling_price"] == null
            ? "0"
            : json["selling_price"].toString(),
        stock: json["stock"] == null ? 0 : json["stock"],
        earningCoins: json["earning_coins"] == null
            ? "0"
            : json["earning_coins"].toString(),
        redeemCoins: json["redeem_coins"] == null
            ? "0"
            : json["redeem_coins"].toString(),
        unit: json["unit"] == null ? "0" : json["unit"].toString(),
        productOption: json["product_option"] == null
            ? []
            : List<ProductOption>.from(
                json["product_option"].map((x) => ProductOption.fromMap(x))),
        productImages: json["product_images"] == null
            ? []
            : List<ProductImage>.from(
                json["product_images"].map((x) => ProductImage.fromMap(x))),
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
        "product_option": productOption == null ? null : List<dynamic>.from(productOption.map((x) => x.toMap())),
        "product_images": productImages == null ? null : List<dynamic>.from(productImages.map((x) => x)),
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

  @override
  String toString() {
    return 'ProductOption{productOptionId: $productOptionId, optionName: $optionName, value: $value}';
  }
}

class ProductImage {
  ProductImage({
    this.id = "",
    this.variantId = "",
    this.productImage = "",
  });

  String id;
  String variantId;
  String productImage;

  factory ProductImage.fromJson(String str) => ProductImage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductImage.fromMap(Map<String, dynamic> json) => ProductImage(
        id: json["id"] == null ? "" : json["id"].toString(),
        variantId: json["variant_id"] == null ? "" : json["variant_id"].toString(),
        productImage: json["product_image"] == null ? "" : json["product_image"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "variant_id": variantId == null ? null : variantId,
        "product_image": productImage == null ? null : productImage,
      };
}
