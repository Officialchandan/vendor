import 'dart:convert';

import 'package:vendor/model/get_sub_category_response.dart';

class AddSubCategoryResponse {
  AddSubCategoryResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  SubCategoryModel? data;

  factory AddSubCategoryResponse.fromJson(String str) => AddSubCategoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddSubCategoryResponse.fromMap(Map<String, dynamic> json) => AddSubCategoryResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : SubCategoryModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : data!.toMap(),
      };
}
