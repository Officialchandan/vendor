import 'dart:convert';

class GetCategoriesResponse {
  GetCategoriesResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<CategoryModel>? data;

  factory GetCategoriesResponse.fromJson(String str) =>
      GetCategoriesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetCategoriesResponse.fromMap(Map<String, dynamic> json) =>
      GetCategoriesResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<CategoryModel>.from(
                json["data"].map((x) => CategoryModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.commission,
    this.categoryName,
    this.image,
  });

  String id;
  String? categoryName;
  String? image;
  String commission;
  bool? isChecked = false;
  bool? onTileTap = false;

  factory CategoryModel.fromJson(String str) =>
      CategoryModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
        id: json["category_id"] == null ? 0 : json["category_id"],
        categoryName:
            json["category_name"] == null ? "" : json["category_name"],
        image: json["image"] == null ? "" : json["image"],
        commission: json["commission"] == null ? "" : json["commission"],
      );

  Map<String, dynamic> toMap() => {
        "category_id": id,
        "category_name": categoryName,
        "image": image,
        "commission": commission
      };
}
