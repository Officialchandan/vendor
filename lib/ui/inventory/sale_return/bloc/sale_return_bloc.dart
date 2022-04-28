import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/common_response.dart';
import 'package:vendor/model/get_purchased_product_response.dart';
import 'package:vendor/model/sale_return_resonse.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_event.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_state.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class SaleReturnBloc extends Bloc<SaleReturnEvent, SaleReturnState> {
  SaleReturnBloc() : super(SaleReturnInitialState());

  @override
  Stream<SaleReturnState> mapEventToState(SaleReturnEvent event) async* {
    if (event is GetPurchasedProductEvent) {
      yield SaleReturnLoadingState();
      yield* getPurchasedProduct(event.input);
    }
    if (event is SaleReturnApiEvent) {
      yield SaleReturnLoadingState();
      yield* saleReturnApi(event.input);
    }
    if (event is VerifyOtpEvent) {
      yield SaleReturnLoadingState();
      yield* verifyOtpApi(event.input);
    }
    if (event is SelectProductEvent) {
      yield SaleReturnLoadingState();
      yield SelectProductState(returnProductList: event.returnProductList);
    }

    if (event is SaleReturnCheckBoxEvent) {
      yield SaleReturnLoadingState();
      yield SaleReturnCheckBoxState(isChecked: event.isChecked, index: event.index);
    }

    if (event is SaleReturnQtyIncrementEvent) {
      yield SaleReturnLoadingState();
      yield SaleReturnQtyIncrementState(count: event.count, index: event.index);
    }

    if (event is SaleReturnQtyDecrementEvent) {
      yield SaleReturnLoadingState();
      yield SaleReturnQtyDecrementState(count: event.count, index: event.index);
    }

    if (event is SaleReturnClearDataEvent) {
      yield SaleReturnLoadingState();
      yield SaleReturnClearDataState(message: event.message);
    }
  }

  Stream<SaleReturnState> getPurchasedProduct(Map input) async* {
    if (await Network.isConnected()) {
      GetPurchasedProductResponse response = await apiProvider.getPurchasedProduct(input);

      if (response.success) {
        List<SaleReturnProducts> products = [];
        for (var i in response.data!) {
          SaleReturnProducts categoryWise = SaleReturnProducts(
            orderId: i.orderId,
            categoryName: "",
            dateTime: i.dateTime,
            productId: i.productId,
            productName: i.productName,
            productImages: i.productImages.isEmpty ? "" : i.productImages.first,
            vendorId: i.vendorId,
            customerId: i.customerId,
            earningCoins: i.earningCoins,
            redeemCoins: i.redeemCoins,
            qty: i.qty,
            price: i.price,
            total: i.total,
            mobile: "",
          );
          products.add(categoryWise);
        }

        for (var i in response.directBilling!) {
          SaleReturnProducts directBilling = SaleReturnProducts(
            orderId: i.orderId.toString(),
            categoryName: i.categoryName,
            dateTime: i.dateTime,
            productId: "",
            productName: i.categoryName,
            productImages: "",
            vendorId: i.vendorId.toString(),
            customerId: "",
            earningCoins: "",
            redeemCoins: i.redeemedCoins,
            qty: 1,
            price: "0",
            total: i.totalPay,
            mobile: i.mobile,
          );
          products.add(directBilling);
        }

        yield GetProductSuccessState(purchaseList: products);
      } else {
        Utility.showToast(msg: response.message);
        yield GetProductFailureState(message: response.message);
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }

  Stream<SaleReturnState> saleReturnApi(Map input) async* {
    if (await Network.isConnected()) {
      SaleReturnResponse response = await apiProvider.saleReturnApi(input);

      if (response.success) {
        yield ProductReturnSuccessState(message: response.message, input: input, data: response.data!);
      } else {
        yield GetProductFailureState(message: response.message);
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }

  Stream<SaleReturnState> verifyOtpApi(Map input) async* {
    if (await Network.isConnected()) {
      CommonResponse response = await apiProvider.saleReturnOtpApi(input);

      if (response.success) {
        yield VerifyOtpSuccessState(message: response.message);
      } else {
        Utility.showToast(msg: response.message);
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }
}
