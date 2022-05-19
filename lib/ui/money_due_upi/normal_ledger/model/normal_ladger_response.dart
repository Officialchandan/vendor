// To parse this JSON data, do
//
//     final normalLadgerResponse = normalLadgerResponseFromMap(jsonString);

import 'dart:convert';

class NormalLedgerResponse {
  NormalLedgerResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.directBilling,
  });

  bool success;
  String message;
  List<OrderData> data;
  List<OrderData> directBilling;

  factory NormalLedgerResponse.fromJson(String str) => NormalLedgerResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NormalLedgerResponse.fromMap(Map<String, dynamic> json) => NormalLedgerResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null ? [] : List<OrderData>.from(json["data"].map((x) => OrderData.fromMap(x))),
        directBilling: json["direct_billing"] == null
            ? []
            : List<OrderData>.from(json["direct_billing"].map((x) => OrderData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toMap())),
        "direct_billing": directBilling == null ? null : List<dynamic>.from(directBilling.map((x) => x.toMap())),
      };
}

class OrderData {
  OrderData({
    required this.vendorId,
    required this.firstName,
    required this.mobile,
    required this.orderId,
    required this.orderTotal,
    required this.myprofitRevenue,
    required this.status,
    required this.paymentOrderId,
    required this.dateTime,
    required this.isReturn,
    required this.orderDetails,
    required this.paymentDetails,
    required this.billingDetails,
    required this.totalearningcoins,
    required this.vendorGivenCoins,
    // required this.orderType,
  });

  String vendorId;
  String firstName;
  String mobile;
  String orderId;
  String orderTotal;
  String myprofitRevenue;
  int status;
  String paymentOrderId;
  DateTime dateTime;

  int isReturn;
  String totalearningcoins;
  List<PaymentDetail> paymentDetails;
  List<OrderDetail> orderDetails;
  List<BillingDetail> billingDetails;
  String vendorGivenCoins;
  int orderType = 0;

  factory OrderData.fromJson(String str) => OrderData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderData.fromMap(Map<String, dynamic> json) => OrderData(
        vendorId: json["vendor_id"] == null ? "" : json["vendor_id"].toString(),
        firstName: json["first_name"] == null ? "" : json["first_name"],
        mobile: json["mobile"] == null ? "" : json["mobile"],
        orderId: json["order_id"] == null ? "" : json["order_id"].toString(),
        vendorGivenCoins: json["vendor_given_coins"] == null ? "" : json["vendor_given_coins"].toString(),
        orderTotal: json["order_total"] == null ? "0" : json["order_total"].toString(),
        myprofitRevenue: json["myprofit_revenue"] == null ? "" : json["myprofit_revenue"].toString(),
        status: json["status"] == null ? -1 : json["status"],
        paymentOrderId: json["payment_order_id"] == null ? "0" : json["payment_order_id"].toString(),

        dateTime: json["date_time"] == null ? DateTime.now() : DateTime.parse(json["date_time"]),

        isReturn: json["is_return"] == null ? -1 : json["is_return"],
        totalearningcoins: json["total_earning_coins"] == null ? "" : json["total_earning_coins"].toString(),
        paymentDetails: json["payment_details"] == null
            ? []
            : List<PaymentDetail>.from(json["payment_details"].map((x) => PaymentDetail.fromMap(x))),

        orderDetails: json["order_details"] == null
            ? []
            : List<OrderDetail>.from(json["order_details"].map((x) => OrderDetail.fromMap(x))),
        billingDetails: json["billing_details"] == null
            ? []
            : List<BillingDetail>.from(json["billing_details"].map((x) => BillingDetail.fromMap(x))),
        // orderType: json["order_id"] == null ? 0 : 1
      );

  Map<String, dynamic> toMap() => {
        "vendor_id": vendorId == null ? null : vendorId,
        "first_name": firstName == null ? null : firstName,
        "mobile": mobile == null ? null : mobile,
        "order_id": orderId == null ? null : orderId,
        "vendor_given_coins": vendorGivenCoins == null ? null : vendorGivenCoins,
        "order_total": orderTotal == null ? null : orderTotal,
        "myprofit_revenue": myprofitRevenue == null ? null : myprofitRevenue,
        "status": status == null ? null : status,
        "payment_order_id": paymentOrderId == null ? null : paymentOrderId,
        "date_time": dateTime == null ? null : dateTime.toIso8601String(),
        "payment_details": paymentDetails == null ? null : List<dynamic>.from(paymentDetails.map((x) => x.toMap())),
        "is_return": isReturn == null ? null : isReturn,
        "total_earning_coins": totalearningcoins == null ? null : totalearningcoins,
        "order_details": orderDetails == null ? null : List<dynamic>.from(orderDetails.map((x) => x.toMap())),
      };

  @override
  String toString() {
    return 'OrderData{vendorId: $vendorId, firstName: $firstName, '
        'mobile: $mobile, orderId: $orderId, orderTotal: $orderTotal,'
        ' myprofitRevenue: $myprofitRevenue, status: $status, dateTime: $dateTime,'
        ' isReturn: $isReturn, orderDetails: $orderDetails, '
        'billingDetails: $billingDetails, orderType: $orderType,payment_details:$paymentDetails}';
  }
}

/*class DirectBilling {
  DirectBilling({
    required this.vendorId,
    required this.billingId,
    required this.firstName,
    required this.mobile,
    required this.orderTotal,
    required this.myprofitRevenue,
    required this.status,
    required this.isReturn,
    required this.dateTime,
    required this.billingDetails,
  });

  int vendorId;
  int billingId;
  String firstName;
  String mobile;
  int orderTotal;
  String myprofitRevenue;
  int status;
  int isReturn;
  DateTime dateTime;
  List<BillingDetail> billingDetails;

  factory DirectBilling.fromJson(String str) => DirectBilling.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DirectBilling.fromMap(Map<String, dynamic> json) => DirectBilling(
        vendorId: json["vendor_id"] == null ? 0 : json["vendor_id"],
        billingId: json["billing_id"] == null ? 0 : json["billing_id"],
        firstName: json["first_name"] == null ? "" : json["first_name"],
        mobile: json["mobile"] == null ? "" : json["mobile"],
        orderTotal: json["order_total"] == null ? 0 : json["order_total"],
        myprofitRevenue: json["myprofit_revenue"] == null ? "" : json["myprofit_revenue"],
        status: json["status"] == null ? -1 : json["status"],
        isReturn: json["is_return"] == null ? -1 : json["is_return"],
        dateTime: json["date_time"] == null ? DateTime.now() : DateTime.parse(json["date_time"]),
        billingDetails: json["billing_details"] == null
            ? []
            : List<BillingDetail>.from(json["billing_details"].map((x) => BillingDetail.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "vendor_id": vendorId == null ? null : vendorId,
        "billing_id": billingId == null ? null : billingId,
        "first_name": firstName == null ? null : firstName,
        "mobile": mobile == null ? null : mobile,
        "order_total": orderTotal == null ? null : orderTotal,
        "myprofit_revenue": myprofitRevenue == null ? null : myprofitRevenue,
        "status": status == null ? null : status,
        "is_return": isReturn == null ? null : isReturn,
        "date_time": dateTime == null ? null : dateTime.toIso8601String(),
        "billing_details": billingDetails == null ? null : List<dynamic>.from(billingDetails.map((x) => x.toMap())),
      };
}*/

class OrderDetail {
  OrderDetail(
      {required this.orderId,
      required this.productId,
      required this.productName,
      required this.productImage,
      required this.price,
      required this.qty,
      required this.total,
      required this.amountPaid,
      required this.redeemCoins,
      required this.earningCoins,
      required this.myprofitRevenue,
      required this.isReturn,
      required this.categoryId,
      required this.commissionValue});

  int orderId;
  int productId;
  int categoryId;
  String productName;
  String productImage;
  String price;
  int qty;
  String total;
  String amountPaid;
  String redeemCoins;
  String earningCoins;
  String myprofitRevenue;

  int isReturn;
  String commissionValue;
  factory OrderDetail.fromJson(String str) => OrderDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderDetail.fromMap(Map<String, dynamic> json) => OrderDetail(
        orderId: json["order_id"] == null ? 0 : json["order_id"],
        productId: json["product_id"] == null ? 0 : json["product_id"],
        categoryId: json["category_id"] == null ? 0 : json["category_id"],
        productName: json["product_name"] == null ? "" : json["product_name"],
        productImage: json["product_image"] == null ? "" : json["product_image"],
        price: json["price"] == null ? "0" : json["price"],
        qty: json["qty"] == null ? 0 : json["qty"],
        total: json["total"] == null ? "0" : json["total"],
        amountPaid: json["amount_paid"] == null ? "0" : json["amount_paid"],
        redeemCoins: json["redeem_coins"] == null ? "0" : json["redeem_coins"],
        earningCoins: json["earning_coins"] == null ? "0" : json["earning_coins"],
        myprofitRevenue: json["myprofit_revenue"] == null ? "0" : json["myprofit_revenue"],
        isReturn: json["is_return"] == null ? -1 : json["is_return"],
        commissionValue: json["commission_value"] == null ? "" : json["commission_value"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId == null ? null : orderId,
        "product_id": productId == null ? null : productId,
        "category_id": categoryId == null ? null : categoryId,
        "product_name": productName == null ? null : productName,
        "product_image": productImage == null ? null : productImage,
        "price": price == null ? null : price,
        "qty": qty == null ? null : qty,
        "total": total == null ? null : total,
        "amount_paid": amountPaid == null ? null : amountPaid,
        "redeem_coins": redeemCoins == null ? null : redeemCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
        "myprofit_revenue": myprofitRevenue == null ? null : myprofitRevenue,
        "is_return": isReturn == null ? null : isReturn,
        "commission_value": commissionValue == null ? null : commissionValue,
      };
}

class BillingDetail {
  BillingDetail({
    required this.orderId,
    required this.categoryId,
    required this.total,
    required this.categoryName,
    required this.categoryImage,
    required this.redeemCoins,
    required this.earningCoins,
    required this.amountPaid,
    required this.commissionValue,
  });
  int orderId;
  String categoryId;
  String total;
  String categoryName;
  String categoryImage;
  String redeemCoins;
  String earningCoins;
  String amountPaid;
  String commissionValue;
  factory BillingDetail.fromJson(String str) => BillingDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BillingDetail.fromMap(Map<String, dynamic> json) => BillingDetail(
        orderId: json["order_id"] == null ? 0 : json["order_id"],
        categoryId: json["category_id"] == null ? "0" : json["category_id"],
        total: json["total"] == null ? "0" : json["total"].toString(),
        categoryName: json["category_name"] == null ? "" : json["category_name"].toString(),
        categoryImage: json["category_image"] == null ? "" : json["category_image"].toString(),
        redeemCoins: json["redeem_coins"] == null ? "0" : json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"] == null ? "0" : json["earning_coins"].toString(),
        amountPaid: json["amount_paid"] == null ? "0" : json["amount_paid"].toString(),
        commissionValue: json["commission_value"] == null ? "" : json["commission_value"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId == null ? null : orderId,
        "category_id": categoryId == null ? null : categoryId,
        "total": total == null ? null : total,
        "category_name": categoryName == null ? null : categoryName,
        "category_image": categoryImage == null ? null : categoryImage,
        "redeeme_coins": redeemCoins == null ? null : redeemCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
        "amount_paid": amountPaid == null ? null : amountPaid,
        "commission_value": commissionValue == null ? null : commissionValue,
      };
}

class PaymentDetail {
  PaymentDetail({
    required this.bankTxnId,
    required this.txnType,
    required this.gatewayName,
    required this.paymentMode,
    required this.responseMsg,
    required this.txnDate,
    required this.from,
    required this.to,
  });

  String bankTxnId;
  String txnType;
  String gatewayName;
  String paymentMode;
  String responseMsg;
  String txnDate;
  String from;
  String to;

  factory PaymentDetail.fromJson(String str) => PaymentDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PaymentDetail.fromMap(Map<String, dynamic> json) => PaymentDetail(
        bankTxnId: json["bank_txn_id"] == null ? "" : json["bank_txn_id"].toString(),
        txnType: json["txnType"] == null ? "" : json["txnType"].toString(),
        gatewayName: json["gateway_name"] == null ? "" : json["gateway_name"].toString(),
        paymentMode: json["payment_mode"] == null ? "" : json["payment_mode"].toString(),
        responseMsg: json["response_msg"] == null ? "" : json["response_msg"].toString(),
        txnDate: json["txn_date"] == null ? "" : json["txn_date"].toString(),
        from: json["from"] == null ? "" : json["from"].toString(),
        to: json["to"] == null ? "" : json["to"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "bank_txn_id": bankTxnId == null ? null : bankTxnId,
        "txnType": txnType == null ? null : txnType,
        "gateway_name": gatewayName == null ? null : gatewayName,
        "payment_mode": paymentMode == null ? null : paymentMode,
        "response_msg": responseMsg == null ? null : responseMsg,
        "txn_date": txnDate == null ? null : txnDate,
        "from": from == null ? null : from,
        "to": to == null ? null : to,
      };

  @override
  String toString() {
    return 'PaymentDetail{bankTxnId: $bankTxnId, txnType: $txnType, gatewayName: $gatewayName, paymentMode: $paymentMode, responseMsg: $responseMsg, txnDate: $txnDate, from: $from, to: $to}';
  }
}
// import 'dart:convert';
//
// class GetDueAmountResponse {
//   GetDueAmountResponse({
//     this.success,
//     this.message,
//     this.data,
//     this.directBilling,
//   });
//
//   bool success;
//   String message;
//   List<Datum> data;
//   List<Datum> directBilling;
//
//   factory GetDueAmountResponse.fromJson(String str) => GetDueAmountResponse.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory GetDueAmountResponse.fromMap(Map<String, dynamic> json) => GetDueAmountResponse(
//     success: json["success"] == null ? null : json["success"],
//     message: json["message"] == null ? null : json["message"],
//     data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
//     directBilling: json["direct_billing"] == null ? null : List<Datum>.from(json["direct_billing"].map((x) => Datum.fromMap(x))),
//   );
//
//   Map<String, dynamic> toMap() => {
//     "success": success == null ? null : success,
//     "message": message == null ? null : message,
//     "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toMap())),
//     "direct_billing": directBilling == null ? null : List<dynamic>.from(directBilling.map((x) => x.toMap())),
//   };
// }
//
// class Datum {
//   Datum({
//     this.vendorId,
//     this.firstName,
//     this.mobile,
//     this.orderId,
//     this.orderTotal,
//     this.myprofitRevenue,
//     this.status,
//     this.paymentOrderId,
//     this.dateTime,
//     this.paymentDetails,
//     this.isReturn,
//     this.orderDetails,
//     this.billingDetails,
//   });
//
//   int vendorId;
//   String firstName;
//   String mobile;
//   int orderId;
//   String orderTotal;
//   String myprofitRevenue;
//   int status;
//   String paymentOrderId;
//   DateTime dateTime;
//   List<PaymentDetail> paymentDetails;
//   int isReturn;
//   List<OrderDetail> orderDetails;
//   List<BillingDetail> billingDetails;
//
//   factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory Datum.fromMap(Map<String, dynamic> json) => Datum(
//     vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
//     firstName: json["first_name"] == null ? null : json["first_name"],
//     mobile: json["mobile"] == null ? null : json["mobile"],
//     orderId: json["order_id"] == null ? null : json["order_id"],
//     orderTotal: json["order_total"] == null ? null : json["order_total"],
//     myprofitRevenue: json["myprofit_revenue"] == null ? null : json["myprofit_revenue"],
//     status: json["status"] == null ? null : json["status"],
//     paymentOrderId: json["payment_order_id"] == null ? null : json["payment_order_id"],
//     dateTime: json["date_time"] == null ? null : DateTime.parse(json["date_time"]),
//     paymentDetails: json["payment_details"] == null ? null : List<PaymentDetail>.from(json["payment_details"].map((x) => PaymentDetail.fromMap(x))),
//     isReturn: json["is_return"] == null ? null : json["is_return"],
//     orderDetails: json["order_details"] == null ? null : List<OrderDetail>.from(json["order_details"].map((x) => OrderDetail.fromMap(x))),
//     billingDetails: json["billing_details"] == null ? null : List<BillingDetail>.from(json["billing_details"].map((x) => BillingDetail.fromMap(x))),
//   );
//
//   Map<String, dynamic> toMap() => {
//     "vendor_id": vendorId == null ? null : vendorId,
//     "first_name": firstName == null ? null : firstName,
//     "mobile": mobile == null ? null : mobile,
//     "order_id": orderId == null ? null : orderId,
//     "order_total": orderTotal == null ? null : orderTotal,
//     "myprofit_revenue": myprofitRevenue == null ? null : myprofitRevenue,
//     "status": status == null ? null : status,
//     "payment_order_id": paymentOrderId == null ? null : paymentOrderId,
//     "date_time": dateTime == null ? null : dateTime.toIso8601String(),
//     "payment_details": paymentDetails == null ? null : List<dynamic>.from(paymentDetails.map((x) => x.toMap())),
//     "is_return": isReturn == null ? null : isReturn,
//     "order_details": orderDetails == null ? null : List<dynamic>.from(orderDetails.map((x) => x.toMap())),
//     "billing_details": billingDetails == null ? null : List<dynamic>.from(billingDetails.map((x) => x.toMap())),
//   };
// }
//
// class BillingDetail {
//   BillingDetail({
//     this.orderId,
//     this.categoryId,
//     this.categoryName,
//     this.categoryImage,
//     this.total,
//     this.redeemCoins,
//     this.earningCoins,
//     this.amountPaid,
//     this.commissionValue,
//   });
//
//   int orderId;
//   String categoryId;
//   String categoryName;
//   String categoryImage;
//   int total;
//   String redeemCoins;
//   String earningCoins;
//   String amountPaid;
//   double commissionValue;
//
//   factory BillingDetail.fromJson(String str) => BillingDetail.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory BillingDetail.fromMap(Map<String, dynamic> json) => BillingDetail(
//     orderId: json["order_id"] == null ? null : json["order_id"],
//     categoryId: json["category_id"] == null ? null : json["category_id"],
//     categoryName: json["category_name"] == null ? null : json["category_name"],
//     categoryImage: json["category_image"] == null ? null : json["category_image"],
//     total: json["total"] == null ? null : json["total"],
//     redeemCoins: json["redeem_coins"] == null ? null : json["redeem_coins"],
//     earningCoins: json["earning_coins"] == null ? null : json["earning_coins"],
//     amountPaid: json["amount_paid"] == null ? null : json["amount_paid"],
//     commissionValue: json["commission_value"] == null ? null : json["commission_value"].toDouble(),
//   );
//
//   Map<String, dynamic> toMap() => {
//     "order_id": orderId == null ? null : orderId,
//     "category_id": categoryId == null ? null : categoryId,
//     "category_name": categoryName == null ? null : categoryName,
//     "category_image": categoryImage == null ? null : categoryImage,
//     "total": total == null ? null : total,
//     "redeem_coins": redeemCoins == null ? null : redeemCoins,
//     "earning_coins": earningCoins == null ? null : earningCoins,
//     "amount_paid": amountPaid == null ? null : amountPaid,
//     "commission_value": commissionValue == null ? null : commissionValue,
//   };
// }
//
// class OrderDetail {
//   OrderDetail({
//     this.orderId,
//     this.productId,
//     this.categoryId,
//     this.productName,
//     this.productImage,
//     this.price,
//     this.qty,
//     this.total,
//     this.amountPaid,
//     this.redeemCoins,
//     this.earningCoins,
//     this.myprofitRevenue,
//     this.isReturn,
//     this.commissionValue,
//   });
//
//   int orderId;
//   int productId;
//   int categoryId;
//   String productName;
//   String productImage;
//   String price;
//   int qty;
//   String total;
//   String amountPaid;
//   String redeemCoins;
//   String earningCoins;
//   String myprofitRevenue;
//   int isReturn;
//   double commissionValue;
//
//   factory OrderDetail.fromJson(String str) => OrderDetail.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory OrderDetail.fromMap(Map<String, dynamic> json) => OrderDetail(
//     orderId: json["order_id"] == null ? null : json["order_id"],
//     productId: json["product_id"] == null ? null : json["product_id"],
//     categoryId: json["category_id"] == null ? null : json["category_id"],
//     productName: json["product_name"] == null ? null : json["product_name"],
//     productImage: json["product_image"] == null ? null : json["product_image"],
//     price: json["price"] == null ? null : json["price"],
//     qty: json["qty"] == null ? null : json["qty"],
//     total: json["total"] == null ? null : json["total"],
//     amountPaid: json["amount_paid"] == null ? null : json["amount_paid"],
//     redeemCoins: json["redeem_coins"] == null ? null : json["redeem_coins"],
//     earningCoins: json["earning_coins"] == null ? null : json["earning_coins"],
//     myprofitRevenue: json["myprofit_revenue"] == null ? null : json["myprofit_revenue"],
//     isReturn: json["is_return"] == null ? null : json["is_return"],
//     commissionValue: json["commission_value"] == null ? null : json["commission_value"].toDouble(),
//   );
//
//   Map<String, dynamic> toMap() => {
//     "order_id": orderId == null ? null : orderId,
//     "product_id": productId == null ? null : productId,
//     "category_id": categoryId == null ? null : categoryId,
//     "product_name": productName == null ? null : productName,
//     "product_image": productImage == null ? null : productImage,
//     "price": price == null ? null : price,
//     "qty": qty == null ? null : qty,
//     "total": total == null ? null : total,
//     "amount_paid": amountPaid == null ? null : amountPaid,
//     "redeem_coins": redeemCoins == null ? null : redeemCoins,
//     "earning_coins": earningCoins == null ? null : earningCoins,
//     "myprofit_revenue": myprofitRevenue == null ? null : myprofitRevenue,
//     "is_return": isReturn == null ? null : isReturn,
//     "commission_value": commissionValue == null ? null : commissionValue,
//   };
// }
//
// class PaymentDetail {
//   PaymentDetail({
//     this.bankTxnId,
//     this.txnType,
//     this.gatewayName,
//     this.paymentMode,
//     this.responseMsg,
//     this.txnDate,
//     this.from,
//     this.to,
//   });
//
//   String bankTxnId;
//   String txnType;
//   String gatewayName;
//   String paymentMode;
//   String responseMsg;
//   DateTime txnDate;
//   String from;
//   String to;
//
//   factory PaymentDetail.fromJson(String str) => PaymentDetail.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory PaymentDetail.fromMap(Map<String, dynamic> json) => PaymentDetail(
//     bankTxnId: json["bank_txn_id"] == null ? null : json["bank_txn_id"],
//     txnType: json["txnType"] == null ? null : json["txnType"],
//     gatewayName: json["gateway_name"] == null ? null : json["gateway_name"],
//     paymentMode: json["payment_mode"] == null ? null : json["payment_mode"],
//     responseMsg: json["response_msg"] == null ? null : json["response_msg"],
//     txnDate: json["txn_date"] == null ? null : DateTime.parse(json["txn_date"]),
//     from: json["from"] == null ? null : json["from"],
//     to: json["to"] == null ? null : json["to"],
//   );
//
//   Map<String, dynamic> toMap() => {
//     "bank_txn_id": bankTxnId == null ? null : bankTxnId,
//     "txnType": txnType == null ? null : txnType,
//     "gateway_name": gatewayName == null ? null : gatewayName,
//     "payment_mode": paymentMode == null ? null : paymentMode,
//     "response_msg": responseMsg == null ? null : responseMsg,
//     "txn_date": txnDate == null ? null : txnDate.toIso8601String(),
//     "from": from == null ? null : from,
//     "to": to == null ? null : to,
//   };
// }
