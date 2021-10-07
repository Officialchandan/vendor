import 'dart:collection';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:vendor/model/add_product_response.dart';
import 'package:vendor/model/add_sub_category_response.dart';
import 'package:vendor/model/add_suggested_product_response.dart';
import 'package:vendor/model/billing_product_response.dart';
import 'package:vendor/model/common_response.dart';
import 'package:vendor/model/customer_number_response.dart';
import 'package:vendor/model/daily_earning.dart';
import 'package:vendor/model/daily_sale_amount.dart';
import 'package:vendor/model/daily_walkin.dart';
import 'package:vendor/model/get_brands_response.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/model/get_colors_response.dart';
import 'package:vendor/model/get_purchased_product_response.dart';
import 'package:vendor/model/get_size_response.dart';
import 'package:vendor/model/get_sub_category_response.dart';
import 'package:vendor/model/get_unit_response.dart';
import 'package:vendor/model/get_vendorcategory_id.dart';
import 'package:vendor/model/hourly_sale_amount.dart';
import 'package:vendor/model/log_out.dart';
import 'package:vendor/model/login_otp.dart';
import 'package:vendor/model/login_response.dart';
import 'package:vendor/model/monthly_earning.dart';
import 'package:vendor/model/monthly_sale_amount.dart';
import 'package:vendor/model/monthly_walkin.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/model/product_variant_response.dart';
import 'package:vendor/model/upload_image_response.dart';
import 'package:vendor/model/vendor_profile_response.dart';
import 'package:vendor/model/verify_otp.dart';
import 'package:vendor/provider/Endpoint.dart';
import 'package:vendor/provider/server_error.dart';
import 'package:vendor/utility/sharedpref.dart';

import '../main.dart';

class ApiProvider {
  static ApiProvider apiProvider = ApiProvider.internal();

  ApiProvider.internal();

  factory ApiProvider() {
    return apiProvider;
  }

  Future<LoginOtpResponse> login(mobile) async {
    log("chl gyi");
    try {
      Response res =
          await dio.post(Endpoint.GENERATE_OTP, data: {"mobile": mobile});
      print("${res.data}");
      return LoginOtpResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      print("Exception occurred: $message stackTrace: $stacktrace");
      return LoginOtpResponse(success: false, message: message);
    }
  }

  Future<LoginResponse> verifyOtp(mobile, otp) async {
    log("chl gyi ${mobile + otp}");
    try {
      Response res = await dio
          .post(Endpoint.VERIFY_OTP, data: {"mobile": mobile, "otp": otp});
      log("chl gyi 2${res}");

      return LoginResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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

  Future<CustomerNumberResponse> getCustomerCoins(mobile) async {
    log("chl gyi ${mobile}");
    try {
      var token = await SharedPref.getStringPreference('token');

      Response res = await dio.post(
        Endpoint.GET_CUSTOMER_COINS,
        data: {"mobile": mobile},
      );
      log("chl gyi 2${res}");

      return CustomerNumberResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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

      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_ALL_CATEGORY,
        data: input,
      );

      return GetCategoriesResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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

  Future<ProductByCategoryResponse> getProductByCategories(
      String categoryId) async {
    try {
      Map input = HashMap<String, dynamic>();

      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["category_id"] = categoryId;

      Response res = await dio.post(
        Endpoint.GET_PRODUCT_BY_CATEGORY,
        data: input,
      );

      return ProductByCategoryResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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
  //   } catch (error, stacktrace) {
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

  Future<ProductByCategoryResponse> getSuggestedProduct(String brand) async {
    try {
      Map input = HashMap<String, dynamic>();

      input["brand_name"] = brand;
      // input["category_id"] = categoryId;

      Response res = await dio.post(
        Endpoint.GET_SUGGESTED_PRODUCTS,
        data: input,
      );

      return ProductByCategoryResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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
    try {
      Response res = await dio.post(
        Endpoint.GET_PURCHASED_PRODUCTS,
        data: input,
      );

      return GetPurchasedProductResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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

  Future<CommonResponse> saleReturnApi(Map input) async {
    try {
      Response res = await dio.post(
        Endpoint.SALES_RETURN,
        data: input,
      );

      return CommonResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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
    } catch (error, stacktrace) {
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
      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.ADD_SUGGESTED_PRODUCTS,
        data: input,
      );

      return AddSuggestedProductResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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

      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_ALL_VENDOR_PRODUCTS,
        data: input,
      );

      return ProductByCategoryResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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

  Future<ProductByCategoryResponse> getAllProducts(String categoryId) async {
    try {
      Map input = HashMap<String, dynamic>();

      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_ALL__PRODUCTS,
        data: input,
      );

      return ProductByCategoryResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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
    } catch (error, stacktrace) {
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
    } catch (error, stacktrace) {
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
      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_SUB_CATEGORY,
        data: input,
      );

      return GetSubCategoryResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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
      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.ADD_PRODUCT_SUBCATEGORY,
        data: input,
      );

      return AddSubCategoryResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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

  Future<GetVendorCategoryById> getCategoryByVendorId() async {
    try {
      Map input = HashMap<String, dynamic>();

      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      //input["category_id"] = categoryId;

      Response res = await dio.post(
        Endpoint.GET_SUBCATEGORY_VENDORID,
        data: input,
      );

      return GetVendorCategoryById.fromJson(res.toString());
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return GetVendorCategoryById(success: false, message: message);
    }
  }

  Future<ProductVariantResponse> getProductVariantType(
      String categoryId) async {
    try {
      Map input = HashMap<String, dynamic>();
      // input["category_id"] = categoryId;

      Response res = await dio.get(
        Endpoint.GET_PRODUCT_VARIANT_TYPE,
        // data: input,/**/
      );

      return ProductVariantResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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
    } catch (error, stacktrace) {
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
    } catch (error, stacktrace) {
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
          data: input,
          options: Options(sendTimeout: 10000, receiveTimeout: 10000));

      return UploadImageResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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
    } catch (error, stacktrace) {
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
      Response res =
          await dio.post(Endpoint.DELETE_PRODUCT_VARIANT, data: input);
      return CommonResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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
    } catch (error, stacktrace) {
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
    } catch (error, stacktrace) {
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
    } catch (error, stacktrace) {
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

  Future<BillingProductResponse> getBillingProducts(
      Map<String, dynamic> input) async {
    try {
      Response res = await dio.post(Endpoint.BILLING_PRODUCT, data: input);

      return BillingProductResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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

  Future<VerifyEarningCoinsOtpResponse> getVerifyEarningCoinOtp(
      Map<String, dynamic> input) async {
    try {
      Response res = await dio
          .post(Endpoint.GET_VERIFY_EARNING_COINOTP_VENDORID, data: input);

      return VerifyEarningCoinsOtpResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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

  Future<DailySellAmountResponse> getDailySaleAmount() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_DAILY_SALE_AMOUNT,
        data: input,
      );
      log("------->$res");
      return DailySellAmountResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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

  Future<MonthlySellAmountResponse> getMonthlySaleAmount() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_MONTHLY_SAIE_AMOUNT,
        data: input,
      );
      log("------->$res");
      return MonthlySellAmountResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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

  Future<HourlySellAmountResponse> getHourlySaleAmount() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_HOURLY_SAIE_AMOUNT,
        data: input,
      );
      log("------->$res");
      return HourlySellAmountResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return HourlySellAmountResponse(success: false, message: message);
    }
  }

  Future<DailyEarningAmountResponse> getDailyEarningAmount() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_DAILY_EARNING_AMOUNT,
        data: input,
      );
      log("------->$res");
      return DailyEarningAmountResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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

  Future<MonthlyEarningAmountResponse> getMonthlyEarningAmount() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_MONTHLY_EARNING_AMOUNT,
        data: input,
      );
      log("------->$res");
      return MonthlyEarningAmountResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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

  Future<DailyWalkinAmountResponse> getDailyWalkinAmount() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_DAILY_WALKIN_AMOUNT,
        data: input,
      );
      log("------->$res");
      return DailyWalkinAmountResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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

  Future<MonthlyWalkinAmountResponse> getMonthlyWalkinAmount() async {
    try {
      Map input = HashMap<String, dynamic>();
      log("------->res");
      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_MONTHLY_WALKIN_AMOUNT,
        data: input,
      );
      log("------->$res");
      return MonthlyWalkinAmountResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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
    } catch (error, stacktrace) {
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

      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_VENDOR_PROFILE,
        data: input,
      );

      return VendorDetailResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
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
}
