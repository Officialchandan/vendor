import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/model/get_due_amount_response.dart';
import 'package:vendor/ui/money_due_upi/bloc/money_due_event.dart';
import 'package:vendor/ui/money_due_upi/bloc/money_due_state.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

import '../../../model/get_vendor_free_coin.dart';

class MoneyDueBloc extends Bloc<MoneyDueEvent, MoneyDueState> {
  MoneyDueBloc() : super(MoneyDueInitialState());

  @override
  Stream<MoneyDueState> mapEventToState(MoneyDueEvent event) async* {
    if (event is GetDueAmount) {
      yield* getDueAmountApi();
    }
    if (event is GetCategories) {
      yield* getCategories();
    }
    if (event is GetFreeCoins) {
      yield* getFreeCoinApi();
    }
  }

  Stream<MoneyDueState> getDueAmountApi() async* {
    if (await Network.isConnected()) {
      GetDueAmountResponse response = await apiProvider.getDueAmount();
      yield GetDueAmountState(dueAmount: response.totalDue, categoryDue: response.data);
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
    }
  }

  Stream<MoneyDueState> getCategories() async* {
    if (await Network.isConnected()) {
      GetCategoriesResponse response = await apiProvider.getAllCategories();

      if (response.success)
        yield GetCategoriesState(categories: response.data!);
      else
        yield GetCategoriesState(categories: []);
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
    }
  }

  Stream<MoneyDueState> getFreeCoinApi() async* {
    if (await Network.isConnected()) {
      GetVendorFreeCoinResponse response = await apiProvider.getVendorFreeCoins();
      if (response.success) {
        yield GetFreeCoinState(data: response.data);
      } else {
        yield GetFreeCoinFailureState(
          message: response.message,
          succes: response.success,
        );
      }
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
    }
  }
}
