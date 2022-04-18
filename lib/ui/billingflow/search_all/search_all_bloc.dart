import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/ui/billingflow/search_all/search_all_event.dart';
import 'package:vendor/ui/billingflow/search_all/search_all_state.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

import '../../../main.dart';

class SearchAllBloc extends Bloc<SearchAllEvent, SearchAllState> {
  SearchAllBloc() : super(SearchAllIntialState());

  ProductByCategoryResponse? result;
  @override
  Stream<SearchAllState> mapEventToState(SearchAllEvent event) async* {
    if (event is GetProductsEvent) {
      yield GetSearchLoadingState();
      yield* getSearchAllResponse();
    }
    if (event is GetCheckBoxEvent) {
      yield GetSearchLoadingState();
      yield GetCheckBoxState(check: event.check, index: event.index);
    }
    if (event is GetIncrementEvent) {
      yield GetSearchLoadingState();
      yield GetIncrementState(count: event.count, index: event.index);
    }
    if (event is GetDecrementEvent) {
      yield GetSearchLoadingState();
      yield GetDecrementState(count: event.count, index: event.index);
    }
    if (event is GetAddEvent) {
      yield* getSearchAllResponse();
    }
    if (event is GetSelectSizeEvent) {
      yield* getSearchAllResponse();
    }
    if (event is GetSelectColorEvent) {
      yield* getSearchAllResponse();
    }
    if (event is FindCategoriesEvent) {
      yield GetSearchLoadingState();
      yield CategoriesSearchState(searchword: event.searchkeyword);
    }
  }

  Stream<SearchAllState> getSearchAllResponse() async* {
    if (await Network.isConnected()) {
      yield GetSearchLoadingState();
      try {
        result = await apiProvider.getAllVendorProducts();

        log("$result");
        if (result!.success) {
          yield GetSearchState(message: result!.message, data: result!.data);
        } else {
          yield GetSearchFailureState(message: result!.message);
        }
      } catch (error) {
        yield GetSearchFailureState(message: "internal_server_error_key".tr());
      }
    } else {
      Utility.showToast(
        msg: "please_check_your_internet_connection_key".tr(),
      );
    }
  }
}
