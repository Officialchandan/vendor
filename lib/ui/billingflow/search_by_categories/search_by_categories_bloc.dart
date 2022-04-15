import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/ui/billingflow/search_by_categories/search_by_categories_event.dart';
import 'package:vendor/ui/billingflow/search_by_categories/search_by_categories_state.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

import '../../../main.dart';

class SearchByCategoriesBloc extends Bloc<SearchByCategoriesEvents, SearchByCategoriesState> {
  SearchByCategoriesBloc() : super(SearchByCategoriesInitialState());

  ProductByCategoryResponse? result;
  @override
  Stream<SearchByCategoriesState> mapEventToState(SearchByCategoriesEvents event) async* {
    if (event is ProductsSearchByCategoriesEvent) {
      yield SearchByCategoriesLoadingState();
      yield* getSearchAllResponse(event.input);
    }

    if (event is CheckBoxSearchByCategoriesEvent) {
      yield SearchByCategoriesLoadingState();
      yield SearchByCategoriesCheckBoxState(check: event.check, index: event.index);
    }

    if (event is SearchByCategoriesIncrementEvent) {
      yield SearchByCategoriesLoadingState();
      yield SearchByCategoriesIncrementState(count: event.count, index: event.index);
    }
    if (event is SearchByCategoriesDecrementEvent) {
      yield SearchByCategoriesLoadingState();
      yield SearchByCategoriesDecrementState(count: event.count, index: event.index);
    }
    if (event is FindSearchByCategoriesEvent) {
      yield SearchByCategoriesLoadingState();
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
          yield GetSearchByCategoriesState(message: result!.message, data: result!.data);
        } else {
          yield SearchByCategoriesFailureState(message: result!.message);
        }
      } catch (error) {
        yield SearchByCategoriesFailureState(message: "internal_server_error_key".tr());
      }
    } else {
      Utility.showToast(
        msg: "please_check_your_internet_connection_key".tr(),
      );
    }
  }
}
