import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendor/billingflow/search_all/search_all_event.dart';
import 'package:vendor/billingflow/search_all/search_all_state.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/utility/network.dart';

import '../../main.dart';

class SearchAllBloc extends Bloc<SearchAllEvent, SearchAllState> {
  SearchAllBloc() : super(SearchAllIntialState());

  @override
  Stream<SearchAllState> mapEventToState(SearchAllEvent event) async* {
    if (event is GetProductsEvent) {
      yield* getSearchAllResponse();
    }
    if (event is GetCheckBoxEvent) {
      yield GetCheckBoxState(check: event.check, index: event.index);
    }
    if (event is GetIncrementEvent) {
      yield GetIcrementState(count: event.count);
    }
    if (event is GetDecrementEvent) {
      yield GetDecrementState(count: event.count);
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
  }

  Stream<SearchAllState> getSearchAllResponse() async* {
    if (await Network.isConnected()) {
      yield GetSearchLoadingState();
      try {
        ProductByCategoryResponse result =
            await apiProvider.getAllVendorProducts();
        log("$result");
        if (result.success) {
          yield GetSearchState(message: result.message, data: result.data);
        } else {
          yield GetSearchFailureState(message: result.message);
        }
      } catch (error) {
        yield GetSearchFailureState(message: "internal Server error");
      }
    } else {
      Fluttertoast.showToast(msg: "Turn on the internet");
    }
  }
}
