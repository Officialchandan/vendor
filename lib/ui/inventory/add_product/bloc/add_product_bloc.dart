import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor/UI/inventory/add_product/bloc/add_product_state.dart';
import 'package:vendor/main.dart';
import 'package:vendor/UI/inventory/add_product/bloc/add_product_event.dart';

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
}
