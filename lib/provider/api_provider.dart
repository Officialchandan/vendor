import 'dart:collection';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:vendor/model/add_product_response.dart';
import 'package:vendor/model/add_sub_category_response.dart';
import 'package:vendor/model/billing_product_response.dart';
import 'package:vendor/model/common_response.dart';
import 'package:vendor/model/customer_number_response.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/model/get_colors_response.dart';
import 'package:vendor/model/get_size_response.dart';
import 'package:vendor/model/get_sub_category_response.dart';
import 'package:vendor/model/get_unit_response.dart';
import 'package:vendor/model/get_vendorcategory_id.dart';
import 'package:vendor/model/login_otp.dart';
import 'package:vendor/model/login_response.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/model/product_variant_response.dart';
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
      input["category_id"] = categoryId;

      Response res = await dio.get(
        Endpoint.GET_PRODUCT_VARIANT_TYPE,
        // data: input,
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

  Future<CommonResponse> addProductImage(FormData input) async {
    try {
      Response res = await dio.post(Endpoint.ADD_PRODUCT_IMAGE,
          data: input,
          options: Options(sendTimeout: 10000, receiveTimeout: 10000));

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
}

Future<BillingProductResponse> billingProducts(
    Map<String, dynamic> input) async {
  try {
    Response res = await dio.post(Endpoint.GET_BILLING_PRODUCT, data: input);

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
