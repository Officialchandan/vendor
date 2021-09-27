import 'dart:convert';

class GetBrandsResponse {
  GetBrandsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<Brand>? data;

  factory GetBrandsResponse.fromJson(String str) => GetBrandsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetBrandsResponse.fromMap(Map<String, dynamic> json) => GetBrandsResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? [] : List<Brand>.from(json["data"].map((x) => Brand.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Brand {
  Brand({
    required this.id,
    required this.brandName,
  });

  int id;
  String brandName;

  factory Brand.fromJson(String str) => Brand.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Brand.fromMap(Map<String, dynamic> json) => Brand(
        id: json["id"] == null ? null : json["id"],
        brandName: json["brand_name"] == null ? null : json["brand_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "brand_name": brandName,
      };
}
