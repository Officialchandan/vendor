// To parse this JSON data, do
//
//     final giftSchemeResponse = giftSchemeResponseFromMap(jsonString);

import 'dart:convert';

class GiftSchemeResponse {
  GiftSchemeResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<GiftSchemeData>? data;

  factory GiftSchemeResponse.fromJson(String str) =>
      GiftSchemeResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GiftSchemeResponse.fromMap(Map<String, dynamic> json) =>
      GiftSchemeResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<GiftSchemeData>.from(
                json["data"].map((x) => GiftSchemeData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class GiftSchemeData {
  GiftSchemeData({
    required this.id,
    required this.schemeName,
    required this.giftName,
    required this.giftImage,
    required this.description,
    required this.barcode,
    required this.qty,
    required this.cartTotal,
    required this.status,
  });

  int id;
  String schemeName;
  String giftName;
  String giftImage;
  String description;
  String barcode;
  String qty;
  String cartTotal;
  int status;
  int? gift = 0;

  factory GiftSchemeData.fromJson(String str) =>
      GiftSchemeData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GiftSchemeData.fromMap(Map<String, dynamic> json) => GiftSchemeData(
        id: json["id"] == null ? null : json["id"],
        schemeName:
            json["scheme_name"] == null ? "" : json["scheme_name"].toString(),
        giftName: json["gift_name"] == null ? "" : json["gift_name"].toString(),
        giftImage:
            json["gift_image"] == null ? "" : json["gift_image"].toString(),
        description:
            json["description"] == null ? "" : json["description"].toString(),
        barcode: json["barcode"] == null ? "" : json["barcode"].toString(),
        qty: json["qty"] == null ? "" : json["qty"].toString(),
        cartTotal:
            json["cart_total"] == null ? "" : json["cart_total"].toString(),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "scheme_name": schemeName == null ? null : schemeName,
        "gift_name": giftName == null ? null : giftName,
        "gift_image": giftImage == null ? null : giftImage,
        "description": description == null ? null : description,
        "barcode": barcode == null ? null : barcode,
        "qty": qty == null ? null : qty,
        "cart_total": cartTotal == null ? null : cartTotal,
        "status": status == null ? null : status,
      };
}
