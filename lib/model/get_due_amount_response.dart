// To parse this JSON data, do
//
//     final getDueAmountResponse = getDueAmountResponseFromMap(jsonString);

import 'dart:convert';

class GetDueAmountResponse {
  GetDueAmountResponse({
    required this.success,
    required this.message,
    required this.totalDue,
    required this.data,
  });

  bool success;
  String message;
  List<TotalDue> totalDue;
  List<CategoryDueAmount> data;

  factory GetDueAmountResponse.fromJson(String str) => GetDueAmountResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetDueAmountResponse.fromMap(Map<String, dynamic> json) => GetDueAmountResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        totalDue:
            json["total_due"] == null ? [] : List<TotalDue>.from(json["total_due"].map((x) => TotalDue.fromMap(x))),
        data: json["data"] == null
            ? []
            : List<CategoryDueAmount>.from(json["data"].map((x) => CategoryDueAmount.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "total_due": totalDue,
      };
}

class TotalDue {
  TotalDue({
    required this.paymentId,
    required this.myprofitRevenue,
  });

  String paymentId;
  String myprofitRevenue;

  factory TotalDue.fromJson(String str) => TotalDue.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TotalDue.fromMap(Map<String, dynamic> json) => TotalDue(
        paymentId: json["payment_id"] == null ? "0" : json["payment_id"],
        myprofitRevenue: json["myprofit_revenue"] == null ? "0" : json["myprofit_revenue"],
      );

  Map<String, dynamic> toMap() => {
        "payment_id": paymentId == null ? null : paymentId,
        "myprofit_revenue": myprofitRevenue == null ? null : myprofitRevenue,
      };
}

class CategoryDueAmount {
  CategoryDueAmount({
    required this.categoryId,
    required this.categoryName,
    required this.image,
    required this.myprofitRevenue,
  });

  int categoryId;
  String categoryName;
  String image;
  String myprofitRevenue;

  factory CategoryDueAmount.fromJson(String str) => CategoryDueAmount.fromMap(json.decode(str));

  factory CategoryDueAmount.fromMap(Map<String, dynamic> json) => CategoryDueAmount(
        categoryId: json["category_id"] == null ? null : json["category_id"],
        categoryName: json["category_name"] == null ? null : json["category_name"],
        image: json["image"] == null ? null : json["image"],
        myprofitRevenue: json["myprofit_revenue"] == null ? null : json["myprofit_revenue"],
      );
}
