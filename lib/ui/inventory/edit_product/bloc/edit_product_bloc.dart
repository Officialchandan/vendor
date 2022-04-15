import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/add_product_response.dart';
import 'package:vendor/model/common_response.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/inventory/edit_product/bloc/edit_product_event.dart';
import 'package:vendor/ui/inventory/edit_product/bloc/edit_product_state.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class EditProductBloc extends Bloc<EditProductEvent, EditProductState> {
  EditProductBloc() : super(EditProductInitialState());

  @override
  Stream<EditProductState> mapEventToState(EditProductEvent event) async* {
    if (event is EditProductApiEvent) {
      // yield ImageLoadingState();
      yield* editProductApi(event.input);
    }
    if (event is DeleteImageEvent) {
      // yield ImageLoadingState();
      yield* deleteProductImage(event.image);
    }
  }

  Stream<EditProductState> editProductApi(Map<String, dynamic> input) async* {
    if (await Network.isConnected()) {
      EasyLoading.show();
      AddProductResponse response = await apiProvider.updateProduct(input);
      EasyLoading.dismiss();
      if (response.success) {
        Utility.showToast(msg: response.message);
        yield UpdateProductState();
      } else {
        EasyLoading.dismiss();
        Utility.showToast(msg: response.message);
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }

  Stream<EditProductState> deleteProductImage(ProductImage image) async* {
    if (await Network.isConnected()) {
      EasyLoading.show();
      Map input = {"image_id": "${image.id}"};
      CommonResponse response = await apiProvider.deleteProductImage(input);
      EasyLoading.dismiss();
      if (response.success) {
        yield DeleteProductImageState(image: image);
      } else {
        EasyLoading.dismiss();
        Utility.showToast(msg: response.message);
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }
}
