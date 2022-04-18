import 'dart:convert';

class UpiSalesReturnResponse {
  UpiSalesReturnResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.directBilling,
  });

  bool success;
  String message;
  List<BillingDetails> data;
  List<BillingDetails> directBilling;

  factory UpiSalesReturnResponse.fromJson(String str) => UpiSalesReturnResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpiSalesReturnResponse.fromMap(Map<String, dynamic> json) => UpiSalesReturnResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? [] : List<BillingDetails>.from(json["data"].map((x) => BillingDetails.fromMap(x))),
        directBilling: json["direct_billing"] == null
            ? []
            : List<BillingDetails>.from(json["direct_billing"].map((x) => BillingDetails.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? [] : List<dynamic>.from(data.map((x) => x.toMap())),
        "direct_billing": directBilling == null ? [] : List<dynamic>.from(directBilling.map((x) => x.toMap())),
      };
}

class BillingDetails {
  BillingDetails({
    required this.customerId,
    required this.vendorName,
    required this.vendorImage,
    required this.vendorId,
    required this.orderId,
    required this.mobile,
    required this.returnCoinsCustomer,
    required this.returnAmountCustomer,
    required this.dateTime,
    required this.customerCoinBalance,
    required this.amountPaidToMyProfit,
    required this.amountPaidToVendor,
    required this.orderDetails,
    required this.billingId,
    required this.billingDetails,
  });

  String customerId;
  String vendorName;
  String vendorImage;
  String vendorId;
  String orderId;
  String mobile;
  String returnCoinsCustomer;
  String returnAmountCustomer;
  String dateTime;
  String customerCoinBalance;
  String amountPaidToMyProfit;
  String amountPaidToVendor;
  String billingId;
  int billingType = 0;
  List<OrderDetail> orderDetails;
  List<DirectBillingDetails> billingDetails;
  factory BillingDetails.fromJson(String str) => BillingDetails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BillingDetails.fromMap(Map<String, dynamic> json) => BillingDetails(
        customerId: json["customer_id"] == null ? "0" : json["customer_id"].toString(),
        vendorName: json["vendor_name"] == null ? "" : json["vendor_name"].toString(),
        vendorImage: json["store_images"] == null ? "" : json["store_images"].toString(),
        vendorId: json["vendor_id"] == null ? "0" : json["vendor_id"].toString(),
        orderId: json["order_id"] == null ? "0" : json["order_id"].toString(),
        mobile: json["mobile"] == null ? "" : json["mobile"].toString(),
        returnCoinsCustomer: json["return_coins_customer"] == null ? "0" : json["return_coins_customer"].toString(),
        returnAmountCustomer: json["return_amount_customer"] == null ? "0" : json["return_amount_customer"].toString(),
        dateTime: json["date_time"] == null ? "" : json["date_time"].toString(),
        customerCoinBalance: json["customer_coin_balance"] == null ? "0" : json["customer_coin_balance"].toString(),
        amountPaidToMyProfit:
            json["amount_paid_to_myProfit"] == null ? "0" : json["amount_paid_to_myProfit"].toString(),
        amountPaidToVendor: json["amount_paid_to_vendor"] == null ? "" : json["amount_paid_to_vendor"].toString(),
        orderDetails: json["order_details"] == null
            ? []
            : List<OrderDetail>.from(json["order_details"].map((x) => OrderDetail.fromMap(x))),
        billingId: json["billing_id"] == null ? "" : json["billing_id"].toString(),
        billingDetails: json["billing_details"] == null
            ? []
            : List<DirectBillingDetails>.from(json["billing_details"].map((x) => DirectBillingDetails.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "customer_id": customerId == null ? null : customerId,
        "vendor_name": vendorId == null ? null : vendorName,
        "store_images": orderId == null ? null : vendorImage,
        "vendor_id": vendorId == null ? null : vendorId,
        "order_id": orderId == null ? null : orderId,
        "mobile": mobile == null ? null : mobile,
        "return_coins_customer": returnCoinsCustomer == null ? null : returnCoinsCustomer,
        "return_amount_customer": returnAmountCustomer == null ? null : returnAmountCustomer,
        "date_time": dateTime == null ? null : dateTime,
        "customer_coin_balance": customerCoinBalance == null ? null : customerCoinBalance,
        "amount_paid_to_myProfit": amountPaidToMyProfit == null ? null : amountPaidToMyProfit,
        "amount_paid_to_vendor": amountPaidToVendor == null ? null : amountPaidToVendor,
        "order_details": orderDetails == null ? null : List<dynamic>.from(orderDetails.map((x) => x.toMap())),
        "billing_id": billingId == null ? null : billingId,
        "billing_details": billingDetails == null ? [] : List<dynamic>.from(billingDetails.map((x) => x.toMap())),
      };
}

class OrderDetail {
  OrderDetail({
    required this.orderId,
    required this.mobile,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.qty,
    required this.price,
    required this.total,
    required this.amountPaid,
    required this.redeemCoins,
    required this.earningCoins,
    required this.myProfitRevenue,
  });

  String orderId;
  String mobile;
  String productId;
  String productName;
  String productImage;
  String qty;
  String price;
  String total;
  String amountPaid;
  String redeemCoins;
  String earningCoins;
  String myProfitRevenue;

  factory OrderDetail.fromJson(String str) => OrderDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderDetail.fromMap(Map<String, dynamic> json) => OrderDetail(
        orderId: json["order_id"] == null ? "0" : json["order_id"].toString(),
        mobile: json["mobile"] == null ? "" : json["mobile"].toString(),
        productId: json["product_id"] == null ? "0" : json["product_id"].toString(),
        productName: json["product_name"] == null ? "" : json["product_name"].toString(),
        productImage: json["product_image"] == null ? "" : json["product_image"].toString(),
        qty: json["qty"] == null ? "0" : json["qty"].toString(),
        price: json["price"] == null ? "0" : json["price"].toString(),
        total: json["total"] == null ? "0" : json["total"].toString(),
        amountPaid: json["amount_paid"] == null ? "0" : json["amount_paid"].toString(),
        redeemCoins: json["redeem_coins"] == null ? "0" : json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"] == null ? "0" : json["earning_coins"].toString(),
        myProfitRevenue: json["myprofit_revenue"] == null ? "0" : json["myprofit_revenue"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId == null ? null : orderId,
        "mobile": mobile == null ? null : mobile,
        "product_id": productId == null ? null : productId,
        "product_name": productName == null ? null : productName,
        "product_image": productImage == null ? null : productImage,
        "qty": qty == null ? null : qty,
        "price": price == null ? null : price,
        "total": total == null ? null : total,
        "amount_paid": amountPaid == null ? null : amountPaid,
        "redeem_coins": redeemCoins == null ? null : redeemCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
        "myprofit_revenue": myProfitRevenue == null ? null : myProfitRevenue,
      };
}

class DirectBillingDetails {
  DirectBillingDetails({
    required this.billingId,
    required this.mobile,
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.amountPaid,
    required this.redeemCoins,
    required this.earningCoins,
    required this.myProfitRevenue,
    required this.total,
  });

  String billingId;
  String mobile;
  String categoryId;
  String categoryName;
  String categoryImage;
  String amountPaid;
  String redeemCoins;
  String earningCoins;
  String myProfitRevenue;
  String total;

  factory DirectBillingDetails.fromJson(String str) => DirectBillingDetails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DirectBillingDetails.fromMap(Map<String, dynamic> json) => DirectBillingDetails(
        billingId: json["billing_id"] == null ? "0" : json["billing_id"].toString(),
        mobile: json["mobile"] == null ? "" : json["mobile"].toString(),
        categoryId: json["category_id"] == null ? "0" : json["category_id"].toString(),
        categoryName: json["category_name"] == null ? "" : json["category_name"].toString(),
        categoryImage: json["category_image"] == null ? "" : json["category_image"].toString(),
        amountPaid: json["amount_paid"] == null ? "0" : json["amount_paid"].toString(),
        redeemCoins: json["redeem_coins"] == null ? "0" : json["redeem_coins"].toString(),
        earningCoins: json["earning_coins"] == null ? "" : json["earning_coins"].toString(),
        myProfitRevenue: json["myprofit_revenue"] == null ? "0" : json["myprofit_revenue"].toString(),
        total: json["total"] == null ? "0" : json["total"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "billing_id": billingId == null ? null : billingId,
        "mobile": mobile == null ? null : mobile,
        "category_id": categoryId == null ? null : categoryId,
        "category_name": categoryName == null ? null : categoryName,
        "category_image": categoryImage == null ? null : categoryImage,
        "amount_paid": amountPaid == null ? null : amountPaid,
        "redeem_coins": redeemCoins == null ? null : redeemCoins,
        "earning_coins": earningCoins == null ? null : earningCoins,
        "myprofit_revenue": myProfitRevenue == null ? null : myProfitRevenue,
        "total": total == null ? null : total,
      };
}

class CommonSaleReturnProductDetails {
  CommonSaleReturnProductDetails({
    required this.orderId,
    required this.mobile,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.qty,
    required this.price,
    required this.total,
    required this.amountPaid,
    required this.redeemCoins,
    required this.earningCoins,
    required this.myProfitRevenue,
    required this.billingId,
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
  });
  String orderId;
  String mobile;
  String productId;
  String productName;
  String productImage;
  String qty;
  String price;
  String total;
  String amountPaid;
  String redeemCoins;
  String earningCoins;
  String myProfitRevenue;

  String billingId;

  String categoryId;
  String categoryName;
  String categoryImage;
}
