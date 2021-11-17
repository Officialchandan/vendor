import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/ui/billingflow/search_by_categories/search_by_categories_event.dart';
import 'package:vendor/ui/billingflow/search_by_categories/search_by_categories_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';

import '../../../main.dart';

class SearchByCategoriesBloc
    extends Bloc<SearchByCategoriesEvents, SearchByCategoriesState> {
  SearchByCategoriesBloc() : super(SearchByCategoriesIntialState());

  ProductByCategoryResponse? result;
  @override
  Stream<SearchByCategoriesState> mapEventToState(
      SearchByCategoriesEvents event) async* {
    if (event is GetProductsSearchByCategoriesEvent) {
      yield* getSearchAllResponse(event.input);
    }
    if (event is GetCheckBoxSearchByCategoriesEvent) {
      yield GetSearchByCategoriesCheckBoxState(
          check: event.check, index: event.index);
    }
    if (event is GetIncrementSearchByCategoriesEvent) {
      yield GetSearchByCategoriesIcrementState(count: event.count);
    }
    if (event is GetDecrementSearchByCategoriesEvent) {
      yield GetSearchByCategoriesDecrementState(count: event.count);
    }
    if (event is GetAddSearchByCategoriesEvent) {}

    if (event is FindSearchByCategoriesEvent) {
      yield SearchByCategoriesSearchState(searchword: event.searchkeyword);
    }
  }

  Stream<SearchByCategoriesState> getSearchAllResponse(String input) async* {
    if (await Network.isConnected()) {
      yield SearchByCategoriesLoadingState();
      try {
        result = await apiProvider.getProductByCategories(input);

        log("$result");
        if (result!.success) {
          yield GetSearchByCategoriesState(
              message: result!.message, data: result!.data);
        } else {
          yield GetSearchByCategoriesFailureState(message: result!.message);
        }
      } catch (error) {
        yield GetSearchByCategoriesFailureState(
            message: "internal_server_error_key".tr());
      }
    } else {
      Fluttertoast.showToast(
          msg: "please_turn_on_the_internet_key".tr(),
          backgroundColor: ColorPrimary);
    }
  }
}
