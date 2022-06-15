import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vendor/api/Endpoint.dart';
import 'package:vendor/api/server_error.dart';
import 'package:vendor/model/add_product_response.dart';
import 'package:vendor/model/add_sub_category_response.dart';
import 'package:vendor/model/add_suggested_product_response.dart';
import 'package:vendor/model/billing_product_response.dart';
import 'package:vendor/model/chat_papdi_module/billing_chatpapdi.dart';
import 'package:vendor/model/chat_papdi_module/billing_chatpapdi_otp.dart';
import 'package:vendor/model/chat_papdi_module/get_customer_of_chatpapdi.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Daily_Earning.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Daily_Sale.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Daily_walkin.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Hourly_Earning.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Hourly_Sale.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Hourly_walkin.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Monthly_Earning.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Monthly_Sale.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Monthly_walkin.dart';
import 'package:vendor/model/common_response.dart';
import 'package:vendor/model/customer_number_response.dart';
import 'package:vendor/model/daily_earning.dart';
import 'package:vendor/model/daily_sale_amount.dart';
import 'package:vendor/model/daily_walkin.dart';
import 'package:vendor/model/direct_billing.dart';
import 'package:vendor/model/direct_billing_otp.dart';
import 'package:vendor/model/get_brands_response.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/model/get_colors_response.dart';
import 'package:vendor/model/get_customer_product_response.dart';
import 'package:vendor/model/get_due_amount_response.dart';
import 'package:vendor/model/get_my_customer_response.dart';
import 'package:vendor/model/get_purchased_product_response.dart';
import 'package:vendor/model/get_size_response.dart';
import 'package:vendor/model/get_sub_category_response.dart';
import 'package:vendor/model/get_unit_response.dart';
import 'package:vendor/model/get_vendor_free_coin.dart';
import 'package:vendor/model/gift_deliverd.dart';
import 'package:vendor/model/gift_scheme_response.dart';
import 'package:vendor/model/hourly_earning.dart';
import 'package:vendor/model/hourly_sale_amount.dart';
import 'package:vendor/model/hourly_walkin.dart';
import 'package:vendor/model/log_out.dart';
import 'package:vendor/model/login_otp.dart';
import 'package:vendor/model/login_response.dart';
import 'package:vendor/model/monthly_earning.dart';
import 'package:vendor/model/monthly_sale_amount.dart';
import 'package:vendor/model/monthly_walkin.dart';
import 'package:vendor/model/partial_user_register.dart';
import 'package:vendor/model/payment/initiate_payment_response.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/model/product_variant_response.dart';
import 'package:vendor/model/qr_code.dart';
import 'package:vendor/model/sale_return_resonse.dart';
import 'package:vendor/model/upi_transfer_history.dart';
import 'package:vendor/model/upload_image_response.dart';
import 'package:vendor/model/validate_app_version.dart';
import 'package:vendor/model/vendor_profile_response.dart';
import 'package:vendor/model/verify_otp.dart';
import 'package:vendor/model/videoresponse.dart';
import 'package:vendor/ui/account_management/terms_and_condition/t&c_response.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/model/normal_ladger_response.dart';
import 'package:vendor/ui/money_due_upi/redeem_coin/customer_coin_history_response.dart';
import 'package:vendor/ui/money_due_upi/redeem_coin/response/redeem_coin_response.dart';
import 'package:vendor/ui/money_due_upi/sales_return/response/upi_sales_return_response.dart';
import 'package:vendor/ui/notification_screen/model/notification_response.dart';
import 'package:vendor/utility/sharedpref.dart';

import '../main.dart';

class ApiProvider {
  static ApiProvider apiProvider = ApiProvider.internal();

  ApiProvider.internal();

  factory ApiProvider() {
    return apiProvider;
  }

  Future<LoginOtpResponse> login(mobile) async {
    try {
      Response res = await dio.post(Endpoint.GENERATE_OTP, data: {"mobile": mobile});

      return LoginOtpResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      print("Exception occurred: $message");
      return LoginOtpResponse(success: false, message: message);
    }
  }

  Future<LoginResponse> verifyOtp(mobile, otp) async {
    try {
      Response res = await dio.post(Endpoint.VERIFY_OTP,
          data: {"mobile": mobile, "otp": otp, "device_token": await firebaseMessaging.getToken()});

      return LoginResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      print("Exception occurred: $message stackTrace: $error");
      return LoginResponse(success: false, message: message);
    }
  }

  Future<ValidateAppVersionResponse> validateAppVersion() async {
    try {
      PackageInfo _packageInfo = await PackageInfo.fromPlatform();
      Map<String, dynamic> input = {
        "app_name": "vendor_app",
        "app_version": "${_packageInfo.version}",
        "device_type": Platform.isAndroid ? "1" : "2"
      };
      Response res = await dio.post(Endpoint.GET_VALIDATE_APP_VERSION, data: input);

      return ValidateAppVersionResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      print("Exception occurred: $message stackTrace: $error");
      return ValidateAppVersionResponse(success: false, message: message);
    }
  }

  Future<CustomerNumberResponse> getCustomerCoins(mobile) async {
    try {
      Response res = await dio.post(
        Endpoint.GET_CUSTOMER_COINS,
        data: {"mobile": mobile},
      );

      return CustomerNumberResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return CustomerNumberResponse(success: false, message: message);
    }
  }

  Future<GetCategoriesResponse> getAllCategories() async {
    try {
      Map input = HashMap<String, dynamic>();

      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_ALL_CATEGORY,
        data: input,
      );

      return GetCategoriesResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return GetCategoriesResponse(success: false, message: message);
    }
  }

  Future<ProductByCategoryResponse> getProductByCategories(String categoryId) async {
    try {
      Map input = HashMap<String, dynamic>();

      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["category_id"] = categoryId;

      Response res = await dio.post(
        Endpoint.GET_VENDOR_PRODUCT_BY_CATEGORY,
        data: input,
      );

      return ProductByCategoryResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return ProductByCategoryResponse(success: false, message: message);
    }
  }

  // Future<ProductByCategoryResponse> getProductByBrand(String brand) async {
  //   try {
  //     Map input = HashMap<String, dynamic>();
  //
  //     // input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
  //     input["brand_name"] = brand;
  //
  //     Response res = await dio.post(
  //       Endpoint.GET_SUGGESTED_PRODUCTS,
  //       data: input,
  //     );
  //
  //     return ProductByCategoryResponse.fromJson(res.toString());
  //   } catch (error) {
  //     String message = "";
  //     if (error is DioError) {
  //       ServerError e = ServerError.withError(error: error);
  //       message = e.getErrorMessage();
  //     } else {
  //       message = "Please try again later!";
  //     }
  //     print("Exception occurred: $message stackTrace: $error");
  //     return ProductByCategoryResponse(success: false, message: message);
  //   }
  // }

  Future<ProductByCategoryResponse> getSuggestedProduct(String categoryId) async {
    try {
      Map input = HashMap<String, dynamic>();

      // input["brand_name"] = brand;
      input["category_id"] = categoryId;

      Response res = await dio.post(
        Endpoint.GET_SUGGESTED_PRODUCTS,
        data: input,
      );

      return ProductByCategoryResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return ProductByCategoryResponse(success: false, message: message);
    }
  }

  Future<GetPurchasedProductResponse> getPurchasedProduct(Map input) async {
    log("=----->$input");
    try {
      Response res = await dio.post(
        Endpoint.GET_PURCHASED_PRODUCTS,
        data: input,
      );

      return GetPurchasedProductResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return GetPurchasedProductResponse(success: false, message: message);
    }
  }

  Future<SaleReturnResponse> saleReturnApi(Map input) async {
    try {
      Response res = await dio.post(
        Endpoint.SALES_RETURN,
        data: input,
      );

      return SaleReturnResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return SaleReturnResponse(success: false, message: message);
    }
  }

  Future<CommonResponse> checkPaymentStatus(Map input) async {
    try {
      Response res = await dio.post(
        Endpoint.CHECK_PAYMENT,
        data: input,
      );

      return CommonResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return CommonResponse(success: false, message: message);
    }
  }

  Future<CommonResponse> saleReturnOtpApi(Map input) async {
    try {
      Response res = await dio.post(
        Endpoint.SALES_RETURN_OTP,
        data: input,
      );

      return CommonResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return CommonResponse(success: false, message: message);
    }
  }

  Future<AddSuggestedProductResponse> addSuggestedProduct(String id) async {
    try {
      Map input = HashMap<String, dynamic>();

      input["id"] = id;
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.ADD_SUGGESTED_PRODUCTS,
        data: input,
      );

      return AddSuggestedProductResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return AddSuggestedProductResponse(success: false, message: message);
    }
  }

  Future<ProductByCategoryResponse> getAllVendorProducts() async {
    try {
      Map input = HashMap<String, dynamic>();

      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_ALL_VENDOR_PRODUCTS,
        data: input,
      );

      return ProductByCategoryResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return ProductByCategoryResponse(success: false, message: message);
    }
  }

  Future<GetUnitResponse> getUnitsByCategory(String categoryId) async {
    try {
      Map input = HashMap<String, dynamic>();

      input["category_id"] = categoryId;

      Response res = await dio.post(
        Endpoint.GET_UNITS_BY_CATEGORY,
        data: input,
      );

      return GetUnitResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return GetUnitResponse(success: false, message: message);
    }
  }

  Future<GetSizeResponse> getSizeByCategory(String categoryId) async {
    try {
      Map input = HashMap<String, dynamic>();

      input["category_id"] = categoryId;

      Response res = await dio.post(
        Endpoint.GET_SIZE_BY_CATEGORY,
        data: input,
      );

      return GetSizeResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return GetSizeResponse(success: false, message: message);
    }
  }

  Future<GetSubCategoryResponse> getSubCategory(String categoryId) async {
    try {
      Map input = HashMap<String, dynamic>();

      input["category_id"] = categoryId;
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_SUB_CATEGORY,
        data: input,
      );

      return GetSubCategoryResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return GetSubCategoryResponse(success: false, message: message);
    }
  }

  Future<AddSubCategoryResponse> addSubCategory(Map input) async {
    try {
      // Map input = HashMap<String, dynamic>();
      //
      // input["category_id"] = categoryId;
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.ADD_PRODUCT_SUBCATEGORY,
        data: input,
      );

      return AddSubCategoryResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return AddSubCategoryResponse(success: false, message: message);
    }
  }

  Future<GetCategoriesResponse> getCategoryByVendorId() async {
    try {
      Map input = HashMap<String, dynamic>();

      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      //input["category_id"] = categoryId;

      Response res = await dio.post(
        Endpoint.GET_SUBCATEGORY_VENDORID,
        data: input,
      );

      return GetCategoriesResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return GetCategoriesResponse(success: false, message: message);
    }
  }

  Future<ProductVariantResponse> getProductVariantType(String categoryId) async {
    try {
      Map input = HashMap<String, dynamic>();
      // input["category_id"] = categoryId;

      Response res = await dio.get(
        Endpoint.GET_PRODUCT_VARIANT_TYPE,
        // data: input,/**/
      );

      return ProductVariantResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return ProductVariantResponse(success: false, message: message);
    }
  }

  Future<GetColorsResponse> getColors() async {
    try {
      Response res = await dio.get(Endpoint.GET_COLORS);

      return GetColorsResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return GetColorsResponse(success: false, message: message);
    }
  }

  Future<AddProductResponse> addProduct(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.ADD_VENDOR_PRODUCT, data: input);

      return AddProductResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return AddProductResponse(success: false, message: message);
    }
  }

  Future<UploadImageResponse> addProductImage(FormData input) async {
    try {
      Response res = await dio.post(Endpoint.ADD_PRODUCT_IMAGE,
          data: input, options: Options(sendTimeout: 100000, receiveTimeout: 60000));

      return UploadImageResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return UploadImageResponse(success: false, message: message);
    }
  }

  Future<CommonResponse> deleteProductImage(Map input) async {
    try {
      Response res = await dio.post(Endpoint.DELETE_PRODUCT_IMAGE, data: input);
      return CommonResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return CommonResponse(success: false, message: message);
    }
  }

  Future<CommonResponse> deleteProduct(Map input) async {
    try {
      Response res = await dio.post(Endpoint.DELETE_PRODUCT_VARIANT, data: input);
      return CommonResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return CommonResponse(success: false, message: message);
    }
  }

  Future<CommonResponse> purchaseReturnApi(Map input) async {
    try {
      Response res = await dio.post(Endpoint.PURCHASE_RETURN, data: input);
      return CommonResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return CommonResponse(success: false, message: message);
    }
  }

  updateProduct(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.EDIT_VENDOR_PRODUCT, data: input);

      return AddProductResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return AddProductResponse(success: false, message: message);
    }
  }

  Future<GetBrandsResponse> getBrands() async {
    try {
      Response res = await dio.get(Endpoint.GET_BRANDS);

      return GetBrandsResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return GetBrandsResponse(success: false, message: message);
    }
  }

  Future<BillingProductResponse> getBillingProducts(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.BILLING_PRODUCT, data: input);

      return BillingProductResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return BillingProductResponse(success: false, message: message);
    }
  }

  Future<VerifyEarningCoinsOtpResponse> getVerifyEarningCoinOtp(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.GET_VERIFY_EARNING_COINOTP_VENDORID, data: input);

      return VerifyEarningCoinsOtpResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return VerifyEarningCoinsOtpResponse(success: false, message: message);
    }
  }

  Future<DailySellAmountResponse> getDailySaleAmount(catid, productid, date) async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["category_id"] = catid;
      input["product_id"] = productid;
      input["date"] = date;

      Response res = await dio.post(
        Endpoint.GET_DAILY_SALE_AMOUNT,
        data: input,
      );
      log("------->$res");
      return DailySellAmountResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return DailySellAmountResponse(success: false, message: message);
    }
  }

  Future<MonthlySellAmountResponse> getMonthlySaleAmount(catid, productid, month) async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["category_id"] = catid;
      input["product_id"] = productid;
      input["month"] = month;

      Response res = await dio.post(
        Endpoint.GET_MONTHLY_SALE_AMOUNT,
        data: input,
      );
      log("------->$res");
      return MonthlySellAmountResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return MonthlySellAmountResponse(success: false, message: message);
    }
  }

  Future<HourlySaleAmountResponse> getHourlySaleAmount(catid) async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res$catid");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["category_id"] = catid.toString();

      Response res = await dio.post(
        Endpoint.GET_HOURLY_SALE_AMOUNT,
        data: input,
      );
      log("------->$res");
      return HourlySaleAmountResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return HourlySaleAmountResponse(success: false, message: message);
    }
  }

  Future<HourlyEarningAmountResponse> getHourlyEarningAmount(catid) async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["category_id"] = catid;

      Response res = await dio.post(
        Endpoint.GET_HOURLY_EARNING_AMOUNT,
        data: input,
      );
      log("------->$res");
      return HourlyEarningAmountResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return HourlyEarningAmountResponse(success: false, message: message);
    }
  }

  Future<HourlyWalkinAmountResponse> getHourlyWalkinAmount(catid) async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["category_id"] = catid;

      Response res = await dio.post(
        Endpoint.GET_HOURLY_WALKIN_AMOUNT,
        data: input,
      );
      log("------->$res");
      return HourlyWalkinAmountResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return HourlyWalkinAmountResponse(success: false, message: message);
    }
  }

  Future<DailyEarningAmountResponse> getDailyEarningAmount(catid, productid, date) async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["category_id"] = catid;
      input["product_id"] = productid;
      input["date"] = date;

      Response res = await dio.post(
        Endpoint.GET_DAILY_EARNING_AMOUNT,
        data: input,
      );
      log("------->$res");
      return DailyEarningAmountResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return DailyEarningAmountResponse(success: false, message: message);
    }
  }

  Future<MonthlyEarningAmountResponse> getMonthlyEarningAmount(catid, productid, month) async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["category_id"] = catid;
      input["product_id"] = productid;
      input["month"] = month;

      Response res = await dio.post(
        Endpoint.GET_MONTHLY_EARNING_AMOUNT,
        data: input,
      );
      log("------->$res");
      return MonthlyEarningAmountResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return MonthlyEarningAmountResponse(success: false, message: message);
    }
  }

  Future<DailyWalkinAmountResponse> getDailyWalkinAmount(catid, productid, date) async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["category_id"] = catid;
      input["product_id"] = productid;
      input["date"] = date;

      Response res = await dio.post(
        Endpoint.GET_DAILY_WALKIN_AMOUNT,
        data: input,
      );
      log("------->$res");
      return DailyWalkinAmountResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return DailyWalkinAmountResponse(success: false, message: message);
    }
  }

  Future<MonthlyWalkinAmountResponse> getMonthlyWalkinAmount(catid, productid, month) async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["category_id"] = catid;
      input["product_id"] = productid;
      input["month"] = month;

      Response res = await dio.post(
        Endpoint.GET_MONTHLY_WALKIN_AMOUNT,
        data: input,
      );
      log("------->$res");
      return MonthlyWalkinAmountResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return MonthlyWalkinAmountResponse(success: false, message: message);
    }
  }

  Future<LogOutResponse> getLogOut() async {
    try {
      Response res = await dio.post(
        Endpoint.GET_LOG_OUT,
      );
      log("------->$res");
      return LogOutResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return LogOutResponse(success: false);
    }
  }

  Future<VendorDetailResponse> getVendorProfileDetail() async {
    try {
      Map input = HashMap<String, dynamic>();

      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_VENDOR_PROFILE,
        data: input,
      );

      return VendorDetailResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return VendorDetailResponse(success: false, message: message);
    }
  }

  Future<DirectBillingResponse> getDirectBilling(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.GET_DIRECT_BILLING, data: input);
      log("===>billing$res");
      return DirectBillingResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return DirectBillingResponse(success: false, message: message);
    }
  }

  Future<DirectBillingOtpResponse> getDirectBillingOtp(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.GET_DIRECT_BILLING_OTP, data: input);
      log("===>otp$res");
      return DirectBillingOtpResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return DirectBillingOtpResponse(success: false, message: message);
    }
  }

  Future<GetMyCustomerResponse> getMyCustomer(Map<String, dynamic> input) async {
    //try {
    Response res = await dio.post(Endpoint.GET_MY_CUSTOMER, data: input);
    log("===>otp$res");
    return GetMyCustomerResponse.fromJson(res.toString());
    // } catch (error) {
    //   String message = "";
    //   if (error is DioError) {
    //     ServerError e = ServerError.withError(error: error);
    //     message = e.getErrorMessage();
    //   } else {
    //     message = "Please try again later!";
    //   }
    //   print("Exception occurred: $message stackTrace: $error");
    //   return GetMyCustomerResponse(success: false, message: message);
    // }
  }

  Future<GetMyChatPapdiCustomerResponse> getChatPapdiCustomer(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.GET_CUSTOMER_OF_CHAT_PAPDI, data: input);
      log("===>otp$res");
      return GetMyChatPapdiCustomerResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return GetMyChatPapdiCustomerResponse(success: false, message: message);
    }
  }

  Future<GetCustomerProductResponse> getCustomerProduct(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.GET_CUSTOMER_PRODUCT, data: input);
      log("===>otp$res");
      return GetCustomerProductResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return GetCustomerProductResponse(success: false, message: message);
    }
  }

  Future<GetDueAmountResponse> getDueAmount() async {
    try {
      Map input = {"vendor_id": await SharedPref.getIntegerPreference(SharedPref.VENDORID)};
      Response res = await dio.post(Endpoint.GET_TOTAL_MONEY_DUE, data: input);
      log("===>otp$res");
      return GetDueAmountResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return GetDueAmountResponse(success: false, message: message);
    }
  }

  Future<ChatPapdiResponse> getChatPapdiBilling(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.GET_CHATPAPDI_BILLING, data: input);
      log("===>billing$res");
      return ChatPapdiResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return ChatPapdiResponse(success: false, message: message);
    }
  }

  Future<ChatPapdiOtpResponse> getChatPapdiOtp(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.GET_CHATPAPDI_BILLING_OTP, data: input);
      log("===>otp$res");
      return ChatPapdiOtpResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return ChatPapdiOtpResponse(success: false, message: message);
    }
  }

  Future<WithoutInventoryDailySaleResponse> getChatPapdiDailySaleAmount() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_CHATPAPDI_DAILY_REPORT,
        data: input,
      );
      log("------->$res");
      return WithoutInventoryDailySaleResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return WithoutInventoryDailySaleResponse(success: false, message: message);
    }
  }

  Future<WithoutInventoryMonthlySaleResponse> getChatPapdiMonthlySaleAmount() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_CHATPAPDI_MONTHLY_SALE_AMOUNT,
        data: input,
      );
      log("------->$res");
      return WithoutInventoryMonthlySaleResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return WithoutInventoryMonthlySaleResponse(success: false, message: message);
    }
  }

  Future<WithoutInventoryHourlySaleResponse> getChatPapdiHourlySaleAmount() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_CHATPAPDI_HOURLY_SALE_AMOUNT,
        data: input,
      );
      log("------->$res");
      return WithoutInventoryHourlySaleResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return WithoutInventoryHourlySaleResponse(success: false, message: message);
    }
  }

  Future<WithoutInventoryHourlyEarningResponse> getChatPapdiHourlyEarningAmount() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_CHATPAPDI_HOURLY_EARNING_AMOUNT,
        data: input,
      );
      log("------->$res");
      return WithoutInventoryHourlyEarningResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return WithoutInventoryHourlyEarningResponse(success: false, message: message);
    }
  }

  Future<WithoutInventoryDailyEarningResponse> getChatPapdiDailyEarningAmount() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_CHATPAPDI_DAILY_EARNING_AMOUNT,
        data: input,
      );
      log("------->$res");
      return WithoutInventoryDailyEarningResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return WithoutInventoryDailyEarningResponse(success: false, message: message);
    }
  }

  Future<WithoutInventoryMonthlyEarningResponse> getChatPapdiMonthlyEarningAmount() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_CHATPAPDI_MONTHLY_EARNING_AMOUNT,
        data: input,
      );
      log("------->$res");
      return WithoutInventoryMonthlyEarningResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return WithoutInventoryMonthlyEarningResponse(success: false, message: message);
    }
  }

  Future<WithoutInventoryHourlyWalkinResponse> getChatPapdiHourlyWalkinAmount() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_CHATPAPDI_HOURLY_WALKIN_AMOUNT,
        data: input,
      );
      log("------->$res");
      return WithoutInventoryHourlyWalkinResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return WithoutInventoryHourlyWalkinResponse(success: false, message: message);
    }
  }

  Future<WithoutInventoryDailyWalkinResponse> getChatPapdiDailyWalkinAmount() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_CHATPAPDI_DAILY_WALKIN_AMOUNT,
        data: input,
      );
      log("------->$res");
      return WithoutInventoryDailyWalkinResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return WithoutInventoryDailyWalkinResponse(success: false, message: message);
    }
  }

  Future<WithoutInventoryMonthlyWalkinResponse> getChatPapdiMonthlyWalkinAmount() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_CHATPAPDI_MONTHLY_WALKIN_AMOUNT,
        data: input,
      );
      log("------->$res");
      return WithoutInventoryMonthlyWalkinResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return WithoutInventoryMonthlyWalkinResponse(success: false, message: message);
    }
  }

  Future<PartialUserRegisterResponse> getChatPapdiPatialUserRegister(Map<String, dynamic> input) async {
    // try {
    log("------->res");
    // input["vendor_id"] =
    //     await SharedPref.getIntegerPreference(SharedPref.VENDORID);

    Response res = await dio.post(
      Endpoint.GET_CHATPAPDI_PARTIAL_USER_REGISTER,
      data: input,
    );
    log("------->$res");
    return PartialUserRegisterResponse.fromJson(res.toString());
    // } catch (error) {
    // String message = "";
    // if (error is DioError) {
    //   ServerError e = ServerError.withError(error: error);
    //   message = e.getErrorMessage();
    // } else {
    //   message = "Please try again later!";
    // }
    //   print("Exception occurred: $message stackTrace: $error");
    //   return PartialUserRegisterResponse(success: false, message: message);
    // }
  }

  Future<GiftSchemeResponse> getVendorGiftScheme() async {
    try {
      Map input = HashMap<String, dynamic>();

      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET__VENDOR_GIFT_SCHEME,
        data: input,
      );

      return GiftSchemeResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return GiftSchemeResponse(success: false, message: message);
    }
  }

  Future<GiftDeliverdResponse> getVendorGiftStatus(giftid) async {
    try {
      Map input = HashMap<String, dynamic>();

      input["gift_id"] = giftid;

      Response res = await dio.post(
        Endpoint.GET_UPDATE_VENDOR_GIFT_RECEIVED_STATUS,
        data: input,
      );

      return GiftDeliverdResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return GiftDeliverdResponse(success: false, message: message);
    }
  }

  Future<QrcodeResponse> getQRcode(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.GET_QR_CODE, data: input);
      log("===>billing$res");
      return QrcodeResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return QrcodeResponse(success: false, message: message);
    }
  }

  Future<QrcodeResponse> getNormalQRcode(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.GET_NORMAL_QR_CODE, data: input);
      log("===>billing$res");
      return QrcodeResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return QrcodeResponse(success: false, message: message);
    }
  }

  Future<NotificationResponse> getNotifications(Map input) async {
    try {
      Response res = await dio.post(Endpoint.GET_NOTIFICATIONS, data: input);

      return NotificationResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return NotificationResponse(success: false, message: message);
    }
  }

  Future<GetVendorFreeCoinResponse> getVendorFreeCoins() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      Response res = await dio.post(Endpoint.GET_VENDOR_FREE_COINS, data: input);

      return GetVendorFreeCoinResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return GetVendorFreeCoinResponse(success: false, message: message);
    }
  }

  Future<NormalLedgerResponse> getVendorFreeCoinsHistory(Map<String, dynamic> input) async {
    try {
      // input = HashMap<String, dynamic>();
      log("------->res");

      Response res = await dio.post(Endpoint.GET_VENDOR_COINS_HISTORY, data: input);

      return NormalLedgerResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return NormalLedgerResponse(success: false, message: message, data: [], directBilling: []);
    }
  }

  Future<NormalLedgerResponse> getNormalLedgerHistory(Map<String, dynamic> input) async {
    // try {
    Response res = await dio.post(Endpoint.GET_MASTER_LEDGER_HISTORY, data: input);

    return NormalLedgerResponse.fromJson(res.toString());
    // } catch (error) {
    //   String message = "";
    //   if (error is DioError) {
    //     ServerError e = ServerError.withError(error: error);
    //     message = e.getErrorMessage();
    //   } else {
    //     message = "Please try again later!";
    //   }
    //   print("Exception occurred: $message stackTrace: $error");
    //   return NormalLedgerResponse(success: false, message: message, data: [], directBilling: []);
    // }
  }

  Future<UpiRedeemCoinResponse> upiRedeemCoin(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.GET_REDEEM_COINS, data: input);

      return UpiRedeemCoinResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return UpiRedeemCoinResponse(success: false, message: "", directBilling: [], normalBilling: []);
    }
  }

  Future<UpiSalesReturnResponse> upiSalesReturn(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.GET_SALES_RETURN_HISTORY, data: input);

      return UpiSalesReturnResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return UpiSalesReturnResponse(success: false, message: "", directBilling: [], data: []);
    }
  }

  Future<CustomerRedeemCoinHistory> redeemCoinHistory(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.GET_CUSTOMER_REDEEM_COIN_HISTORY, data: input);

      return CustomerRedeemCoinHistory.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return CustomerRedeemCoinHistory(success: false, message: "", data: []);
    }
  }

  Future<UpiTansferResponse> upiPaymentHistory(input) async {
    try {
      Response res = await dio.post(Endpoint.UPI_PAYMENT_HISTORY, data: input);

      return UpiTansferResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return UpiTansferResponse(success: false, message: "", data: []);
    }
  }

  Future<IntiatePaymnetResponse> initiatePayment(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.GET_INITIATE_PAYMENT_RESPONSE, data: input);

      return IntiatePaymnetResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return IntiatePaymnetResponse(
          success: false, message: "", orderId: "", mid: "", signature: "", txnToken: "", callbackUrl: "");
    }
  }

  Future<TermsResponse> tncWithSignature(Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.TNC_WITH_SIGNATURE, data: input);
      return TermsResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return TermsResponse(success: false, message: "");
    }
  }

  Future<VideoPlayerResponse> getVideo() async {
    try {
      Response res = await dio.post(
        Endpoint.GET_VENDOR_Video,
      );

      return VideoPlayerResponse.fromJson(res.toString());
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return VideoPlayerResponse(success: false, message: message);
    }
  }
}
