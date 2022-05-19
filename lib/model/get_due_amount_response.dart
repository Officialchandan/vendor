// // To parse this JSON data, do
// //
// //     final getDueAmountResponse = getDueAmountResponseFromMap(jsonString);
//
// import 'dart:convert';
//
// class GetDueAmountResponse {
//   GetDueAmountResponse({
//     required this.success,
//     required this.message,
//     required this.totalDue,
//     required this.data,
//   });
//
//   bool success;
//   String message;
//   List<TotalDue> totalDue;
//   List<CategoryDueAmount> data;
//
//   factory GetDueAmountResponse.fromJson(String str) => GetDueAmountResponse.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory GetDueAmountResponse.fromMap(Map<String, dynamic> json) => GetDueAmountResponse(
//         success: json["success"] == null ? false : json["success"],
//         message: json["message"] == null ? "" : json["message"],
//         totalDue:
//             json["total_due"] == null ? [] : List<TotalDue>.from(json["total_due"].map((x) => TotalDue.fromMap(x))),
//         data: json["data"] == null
//             ? []
//             : List<CategoryDueAmount>.from(json["data"].map((x) => CategoryDueAmount.fromMap(x))),
//       );
//
//   Map<String, dynamic> toMap() => {
//         "success": success,
//         "message": message,
//         "total_due": totalDue,
//       };
// }
//
// class TotalDue {
//   TotalDue({
//     required this.paymentId,
//     required this.myprofitRevenue,
//   });
//
//   String paymentId;
//   String myprofitRevenue;
//
//   factory TotalDue.fromJson(String str) => TotalDue.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory TotalDue.fromMap(Map<String, dynamic> json) => TotalDue(
//         paymentId: json["payment_id"] == null ? "0" : json["payment_id"].toString(),
//         myprofitRevenue: json["myprofit_revenue"] == null ? "0" : json["myprofit_revenue"].toString(),
//       );
//
//   Map<String, dynamic> toMap() => {
//         "payment_id": paymentId == null ? null : paymentId,
//         "myprofit_revenue": myprofitRevenue == null ? null : myprofitRevenue.toString(),
//       };
// }
//
// class CategoryDueAmount {
//   CategoryDueAmount({
//     required this.categoryId,
//     required this.categoryName,
//     required this.image,
//     required this.myprofitRevenue,
//   });
//
//   int categoryId;
//   String categoryName;
//   String image;
//   String myprofitRevenue;
//
//   factory CategoryDueAmount.fromJson(String str) => CategoryDueAmount.fromMap(json.decode(str));
//
//   factory CategoryDueAmount.fromMap(Map<String, dynamic> json) => CategoryDueAmount(
//         categoryId: json["category_id"] == null ? null : json["category_id"],
//         categoryName: json["category_name"] == null ? null : json["category_name"],
//         image: json["image"] == null ? null : json["image"],
//         myprofitRevenue: json["myprofit_revenue"] == null ? null : json["myprofit_revenue"],
//       );
// }

import 'dart:convert';

class GetDueAmountResponse {
  GetDueAmountResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  GetDueAmountData? data;

  factory GetDueAmountResponse.fromJson(String str) => GetDueAmountResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetDueAmountResponse.fromMap(Map<String, dynamic> json) => GetDueAmountResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : GetDueAmountData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class GetDueAmountData {
  GetDueAmountData({
    required this.vendorMyprofitPaymentId,
    required this.myprofitVendorPaymentId,
    required this.myProfitVendorDue,
    required this.vendorMyProfitDue,
  });

  String vendorMyprofitPaymentId;
  String myprofitVendorPaymentId;
  String myProfitVendorDue;
  String vendorMyProfitDue;

  factory GetDueAmountData.fromJson(String str) => GetDueAmountData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetDueAmountData.fromMap(Map<String, dynamic> json) => GetDueAmountData(
        vendorMyprofitPaymentId:
            json["vendor_myprofit_payment_id"] == null ? "" : json["vendor_myprofit_payment_id"].toString(),
        myprofitVendorPaymentId:
            json["myprofit_vendor_payment_id"] == null ? "" : json["myprofit_vendor_payment_id"].toString(),
        myProfitVendorDue: json["myProfit_vendor_due"] == null ? "" : json["myProfit_vendor_due"].toString(),
        vendorMyProfitDue: json["vendor_myProfit_due"] == null ? "" : json["vendor_myProfit_due"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "vendor_myprofit_payment_id": vendorMyprofitPaymentId == null ? null : vendorMyprofitPaymentId,
        "myprofit_vendor_payment_id": myprofitVendorPaymentId == null ? null : myprofitVendorPaymentId,
        "myProfit_vendor_due": myProfitVendorDue == null ? null : myProfitVendorDue,
        "vendor_myProfit_due": vendorMyProfitDue == null ? null : vendorMyProfitDue,
      };
}
