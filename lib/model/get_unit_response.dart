// To parse this JSON data, do
//
//     final getUnitResponse = getUnitResponseFromMap(jsonString);

import 'dart:convert';

class GetUnitResponse {
  GetUnitResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<UnitModel>? data;

  factory GetUnitResponse.fromJson(String str) => GetUnitResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetUnitResponse.fromMap(Map<String, dynamic> json) => GetUnitResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null ? [] : List<UnitModel>.from(json["data"].map((x) => UnitModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class UnitModel {
  UnitModel({
    required this.id,
    required this.categoryName,
    required this.unitName,
  });

  String id;
  String categoryName;
  String unitName;

  factory UnitModel.fromJson(String str) => UnitModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UnitModel.fromMap(Map<String, dynamic> json) => UnitModel(
        id: json["id"] == null ? "0" : json["id"],
        categoryName: json["category_name"] == null ? "" : json["category_name"],
        unitName: json["unit_name"] == null ? "" : json["unit_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "category_name": categoryName,
        "unit_name": unitName,
      };
}
