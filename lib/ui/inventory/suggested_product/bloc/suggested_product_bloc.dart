import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/add_suggested_product_response.dart';
import 'package:vendor/model/get_brands_response.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/ui/inventory/suggested_product/bloc/suggested_product_event.dart';
import 'package:vendor/ui/inventory/suggested_product/bloc/suggested_product_state.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class SuggestedProductBloc extends Bloc<SuggestedProductEvent, SuggestedProductState> {
  SuggestedProductBloc() : super(SuggestedProductInitialState());

  @override
  Stream<SuggestedProductState> mapEventToState(SuggestedProductEvent event) async* {
    if (event is GetProductEvent) {
      yield LoadingState();
      yield* getProducts(event);
    }
    if (event is GetBrandsEvent) {
      yield LoadingState();
      yield* getBrands();
    }
    if (event is ChangeTabEvent) {
      yield LoadingState();
      yield ChangeTabState(index: event.index);
    }
    if (event is CheckEvent) {
      // yield LoadingState();
      yield CheckState(index: event.index, check: event.check);
    }
    if (event is AddProductApiEvent) {
      // yield LoadingState();
      yield* addProductApiEvent(event.id);
    }
  }

  Stream<SuggestedProductState> getBrands() async* {
    if (await Network.isConnected()) {
      // EasyLoading.show();

      GetBrandsResponse response = await apiProvider.getBrands();
      // EasyLoading.dismiss();
      if (response.success) {
        yield GetBrandsState(brands: response.data!);
      } else {
        EasyLoading.dismiss();
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast("Please check your internet connection");
    }
  }

  Stream<SuggestedProductState> getProducts(GetProductEvent event) async* {
    if (await Network.isConnected()) {
      ProductByCategoryResponse response = await apiProvider.getSuggestedProduct(event.brandId);

      if (response.success) {
        yield GetProductState(products: response.data!);
      } else {
        EasyLoading.dismiss();
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast("Please check your internet connection");
    }
  }

  Stream<SuggestedProductState> addProductApiEvent(String id) async* {
    if (await Network.isConnected()) {
      AddSuggestedProductResponse response = await apiProvider.addSuggestedProduct(id);

      if (response.success) {
        yield AddProductSuccessState(message: response.message);
      } else {
        EasyLoading.dismiss();
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast("Please check your internet connection");
    }
  }
}
