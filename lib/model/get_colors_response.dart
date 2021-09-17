import 'dart:convert';

class GetColorsResponse {
  GetColorsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<ColorModel>? data;

  factory GetColorsResponse.fromJson(String str) => GetColorsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetColorsResponse.fromMap(Map<String, dynamic> json) => GetColorsResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null ? [] : List<ColorModel>.from(json["data"].map((x) => ColorModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class ColorModel {
  ColorModel({
    required this.id,
    required this.colorName,
    required this.colorCode,
  });

  String id;
  String colorName;
  String colorCode;

  factory ColorModel.fromJson(String str) => ColorModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ColorModel.fromMap(Map<String, dynamic> json) => ColorModel(
        id: json["id"] == null ? "0" : json["id"].toString(),
        colorName: json["color_name"] == null ? "White" : json["color_name"],
        colorCode: json["color_code"] == null ? "#FFFFFF" : json["color_code"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "color_name": colorName,
        "color_code": colorCode,
      };
}
