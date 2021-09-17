import 'dart:convert';

class ProductVariantResponse {
  ProductVariantResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<VariantType>? data;

  factory ProductVariantResponse.fromJson(String str) => ProductVariantResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductVariantResponse.fromMap(Map<String, dynamic> json) => ProductVariantResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null ? [] : List<VariantType>.from(json["data"].map((x) => VariantType.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class VariantType {
  VariantType({
    required this.id,
    required this.variantName,
    required this.categoryName,
  });

  String id;
  String variantName;
  String categoryName;
  bool checked = false;

  factory VariantType.fromJson(String str) => VariantType.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VariantType.fromMap(Map<String, dynamic> json) => VariantType(
        id: json["id"] == null ? "0" : json["id"].toString(),
        variantName: json["option_name"] == null ? "" : json["option_name"],
        categoryName: json["category_name"] == null ? "" : json["category_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "variant_name": variantName,
        "category_name": categoryName,
      };
}
