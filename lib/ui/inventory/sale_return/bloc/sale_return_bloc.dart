import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/common_response.dart';
import 'package:vendor/model/get_purchased_product_response.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_event.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_state.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class SaleReturnBloc extends Bloc<SaleReturnEvent, SaleReturnState> {
  SaleReturnBloc() : super(SaleReturnInitialState());

  @override
  Stream<SaleReturnState> mapEventToState(SaleReturnEvent event) async* {
    if (event is GetPurchasedProductEvent) {
      yield* getPurchasedProduct(event.mobile);
    }
    if (event is SaleReturnApiEvent) {
      yield* saleReturnApi(event.input);
    }
    if (event is VerifyOtpEvent) {
      yield* verifyOtpApi(event.input);
    }
    if (event is SelectProductEvent) {
      yield SelectProductState(returnProductList: event.returnProductList);
    }
  }

  Stream<SaleReturnState> getPurchasedProduct(String mobile) async* {
    if (await Network.isConnected()) {
      Map input = {"mobile": mobile};
      GetPurchasedProductResponse response = await apiProvider.getPurchasedProduct(input);

      if (response.success) {
        yield GetProductSuccessState(purchaseList: response.data!);
      } else {
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast("Please check your internet connection");
    }
  }

  Stream<SaleReturnState> saleReturnApi(Map input) async* {
    if (await Network.isConnected()) {
      CommonResponse response = await apiProvider.saleReturnApi(input);

      if (response.success) {
        yield ProductReturnSuccessState(message: response.message, input: input);
      } else {
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast("Please check your internet connection");
    }
  }

  Stream<SaleReturnState> verifyOtpApi(Map input) async* {
    if (await Network.isConnected()) {
      CommonResponse response = await apiProvider.saleReturnOtpApi(input);

      if (response.success) {
        yield VerifyOtpSuccessState(message: response.message);
      } else {
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast("Please check your internet connection");
    }
  }
}