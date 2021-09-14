// To parse this JSON data, do
//
//     final getVendorCategoryById = getVendorCategoryByIdFromMap(jsonString);

import 'dart:convert';

class GetVendorCategoryById {
  GetVendorCategoryById({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<GetVendorCategoryByIdData>? data;

  factory GetVendorCategoryById.fromJson(String str) =>
      GetVendorCategoryById.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetVendorCategoryById.fromMap(Map<String, dynamic> json) =>
      GetVendorCategoryById(
        success: json["success"],
        message: json["message"],
        data: List<GetVendorCategoryByIdData>.from(
            json["data"].map((x) => GetVendorCategoryByIdData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class GetVendorCategoryByIdData {
  GetVendorCategoryByIdData({
    required this.categoryId,
    required this.categoryName,
    required this.image,
  });

  String categoryId;
  String categoryName;
  String image;

  factory GetVendorCategoryByIdData.fromJson(String str) =>
      GetVendorCategoryByIdData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetVendorCategoryByIdData.fromMap(Map<String, dynamic> json) =>
      GetVendorCategoryByIdData(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        image: json["image"],
      );

  Map<String, dynamic> toMap() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "image": image,
      };
}
