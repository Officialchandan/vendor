import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/model/normal_ladger_response.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_bloc/normal_ledger_event.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_bloc/normal_ledger_state.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class NormalLedgerHistoryBloc extends Bloc<NormalLedgerHistoryEvent, NormalLedgerHistoryState> {
  NormalLedgerHistoryBloc() : super(GetNormalLedgerHistoryInitialState());

  @override
  Stream<NormalLedgerHistoryState> mapEventToState(NormalLedgerHistoryEvent event) async* {
    if (event is GetNormalLedgerHistoryEvent) {
      yield* getNormalLedgerHistoryApi(event.input);
    }
    if (event is GetFindUserEvent) {
      yield GetNormalLedgerUserSearchState(searchword: event.searchkeyword);
    }
  }

  Stream<NormalLedgerHistoryState> getNormalLedgerHistoryApi(input) async* {
    log("===>getNormalLedgerHistoryApi");
    if (await Network.isConnected()) {
      NormalLedgerResponse response = await apiProvider.getNormalLedgerHistory(input);
      log("response.data=== >${response.toString()}");
      log("response.data===== >${response.data}");
      log(" response.direct==>${response.directBilling}");
      log(" response.paymentDetails==>${response.directBilling[5].paymentDetails.toString()}");
      if (response.success) {
        List<OrderData> orderList = [];
        // orderList.addAll(response.data);
        // orderList.addAll(response.directBilling);

        await Future.forEach(response.data, (OrderData order) async {
          order.orderType = 0;
          orderList.add(order);
          log(" orderList.add(order)1${orderList}");
          log(" orderList.add(order)1${order}");
        });
        await Future.forEach(response.directBilling, (OrderData order) async {
          order.orderType = 1;

          orderList.add(order);
          log(" orderList.add(order)2${orderList}");
          log(" orderList.add(order)2${order}");
        });
        orderList.sort((a, b) => b.dateTime.compareTo(a.dateTime));

        yield GetNormalLedgerState(orderList: orderList);

        /*
        List<CommonLedgerHistory> products = [];
        for (GetNormalLedgerHistoryData data in response.data!) {
          List<CommonData> listOrderDetail = [];
          data.orderDetails.forEach((element) {
            CommonData commonData = CommonData(
                orderId: element.orderId.toString(),
                billingId: "",
                categoryId: "",
                categoryName: "",
                categoryImage: "",
                productImage: element.productImage,
                productId: element.productId.toString(),
                productName: element.productName,
                price: element.price,
                qty: element.qty.toString(),
                total: element.total,
                amountPaid: element.amountPaid,
                redeemCoins: element.redeemCoins,
                earningCoins: element.earningCoins,
                myprofitRevenue: element.myprofitRevenue,
                isReturn: element.isReturn.toString());

            listOrderDetail.add(commonData);
          });
          CommonLedgerHistory commonLedgerHistory = CommonLedgerHistory(
            vendorId: data.vendorId.toString(),
            mobile: data.mobile,
            firstName: data.firstName,
            orderId: data.orderId,
            billingId: data.billingId,
            orderTotal: data.orderTotal,
            myprofitRevenue: data.myprofitRevenue,
            status: data.status.toString(),
            dateTime: data.dateTime,
            isReturn: data.isReturn.toString(),
            orderDetails: listOrderDetail,
            billingDetails: [],
          );
          commonLedgerHistory.billingType = 0;
          products.add(commonLedgerHistory);
        }
        for (GetNormalLedgerHistoryDirectBilling data in response.directBilling!) {
          List<CommonData> listOrderDetail = [];
          data.billingDetails.forEach((element) {
            CommonData commonData = CommonData(
              orderId: "",
              billingId: element.billingId.toString(),
              categoryId: element.categoryId,
              categoryName: element.categoryName,
              categoryImage: element.categoryImage,
              productImage: "",
              productId: "",
              productName: "",
              price: "",
              qty: "",
              total: "",
              amountPaid: element.amountPaid,
              redeemCoins: element.redeemCoins,
              earningCoins: element.earningCoins,
              myprofitRevenue: "",
              isReturn: "",
            );

            listOrderDetail.add(commonData);
          });
          CommonLedgerHistory commonLedgerHistory = CommonLedgerHistory(
            vendorId: data.vendorId.toString(),
            mobile: data.mobile,
            firstName: data.firstName,
            orderId: "",
            billingId: data.billingId.toString(),
            orderTotal: data.orderTotal,
            myprofitRevenue: data.myprofitRevenue,
            status: data.status.toString(),
            dateTime: data.dateTime,
            isReturn: data.isReturn.toString(),
            orderDetails: [],
            billingDetails: listOrderDetail,
          );
          log("====>${commonLedgerHistory}");
          commonLedgerHistory.billingType = 1;
          products.add(commonLedgerHistory);
        }
        log("====>${products[0].myprofitRevenue}");*/
        // yield GetNormalLedgerHistoryState(data: products);
      } else {
        yield GetNormalLedgerHistoryFailureState(succes: response.success, message: response.message);
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }
}
