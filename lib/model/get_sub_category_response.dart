// To parse this JSON data, do
//
//     final getSubCategoryResponse = getSubCategoryResponseFromMap(jsonString);

import 'dart:convert';

class GetSubCategoryResponse {
  GetSubCategoryResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<SubCategoryModel>? data;

  factory GetSubCategoryResponse.fromJson(String str) => GetSubCategoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetSubCategoryResponse.fromMap(Map<String, dynamic> json) => GetSubCategoryResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null ? [] : List<SubCategoryModel>.from(json["data"].map((x) => SubCategoryModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class SubCategoryModel {
  SubCategoryModel({
    required this.id,
    required this.categoryId,
    required this.subCatId,
    required this.subCatName,
    required this.description,
  });

  String id;
  String subCatId;
  String categoryId;
  String subCatName;
  String description;

  factory SubCategoryModel.fromJson(String str) => SubCategoryModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubCategoryModel.fromMap(Map<String, dynamic> json) => SubCategoryModel(
        id: json["id"] == null ? "0" : json["id"].toString(),
        categoryId: json["category_id"] == null ? "0" : json["category_id"].toString(),
        subCatName: json["sub_cat_name"] == null ? "" : json["sub_cat_name"],
        description: json["description"] == null ? "" : json["description"],
        subCatId: json["sub_cat_id"] == null ? "0" : json["sub_cat_id"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "category_id": categoryId,
        "sub_cat_id": subCatId,
        "sub_cat_name": subCatName,
        "description": description,
      };
}
