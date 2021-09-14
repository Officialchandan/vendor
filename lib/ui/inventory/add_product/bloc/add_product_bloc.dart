import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:vendor/main.dart';
import 'package:vendor/model/add_product_response.dart';
import 'package:vendor/model/common_response.dart';
import 'package:vendor/ui/inventory/add_product/bloc/add_product_event.dart';
import 'package:vendor/ui/inventory/add_product/bloc/add_product_state.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  AddProductBloc() : super(AddProductInitialState());

  @override
  Stream<AddProductState> mapEventToState(AddProductEvent event) async* {
    if (event is SelectImageEvent) {
      yield ImageLoadingState();
      yield* selectImage(event.context);
    }
    if (event is ShowOnlineShopEvent) {
      yield ShowOnlineShopState(online: event.online);
    }
    if (event is AddProductVariantEvent) {
      yield ImageLoadingState();
      yield AddProductVariantState(productVariant: event.productVariant);
    }
    if (event is UpdateProductVariantEvent) {
      yield ImageLoadingState();
      yield UpdateProductVariantState(productVariant: event.productVariant);
    }
    if (event is UpdateSingleProductVariantEvent) {
      yield ImageLoadingState();
      yield UpdateSingleProductVariantState(productVariant: event.productVariant, index: event.index);
    }
    if (event is DeleteProductVariantEvent) {
      yield ImageLoadingState();
      yield DeleteProductVariantState(productVariant: event.productVariant);
    }
    if (event is SelectVariantOptionEvent) {
      yield ImageLoadingState();
      yield SelectVariantOptionState(variant: event.variant);
    }
    // if (event is AddProductApiEvent) {
    //   // yield ImageLoadingState();
    //   yield* addProductApi(event.input);
    // }

    if (event is AddProductApiEvent) {
      yield ImageLoadingState();
      yield* addProductApi(event.input);
    }

    if (event is UploadImageEvent) {
      yield ImageLoadingState();
      yield* uploadProductImage(event);
    }
  }

  Stream<AddProductState> selectImage(BuildContext context) async* {
    try {
      XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        print(image.path);
        yield SelectImageState(image: File(image.path));
      }
    } catch (exception) {
      debugPrint("exception-->$exception");
    }
  }

  Stream<AddProductState> addProductApi(Map<String, dynamic> input) async* {
    if (await Network.isConnected()) {
      EasyLoading.show();
      AddProductResponse response = await apiProvider.addProduct(input);
      // EasyLoading.dismiss();
      if (response.success) {
        yield AddProductSuccessState(responseData: response.data!);
      } else {
        EasyLoading.dismiss();
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast("Please check your internet connection");
    }
  }

  Stream<AddProductState> uploadProductImage(UploadImageEvent event) async* {
    if (event.images.isEmpty) {
      yield UploadImageFailureState();
    } else if (await Network.isConnected()) {
      Map<String, dynamic> input = HashMap<String, dynamic>();

      input["product_id"] = event.productId;
      input["variant_id"] = event.variantId;

      var files = [];

      for (File image in event.images) {
        print("image size->");
        int size = await image.length();
        print(size);
        files.add(MultipartFile.fromFileSync(image.path, filename: path.basename(image.path)));
      }

      input["product_image[]"] = files;

      FormData formData = FormData.fromMap(input);
      // for (File image in event.images) {
      //   print("image size->");
      //   int size = await image.length();
      //   print(size);
      //   formData.files.add(MapEntry("product_image", await MultipartFile.fromFile(image.path, filename: path.basename(image.path))));
      // }

      print("upload image input -> $input");
      print("upload image input -> ${formData.files}");

      CommonResponse response = await apiProvider.addProductImage(formData);
      if (response.success) {
        yield UploadImageSuccessState();
      } else {
        yield UploadImageFailureState();
      }
    } else {
      Utility.showToast("Please check your internet connection");
    }
  }
}
