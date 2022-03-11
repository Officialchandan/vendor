import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_master_ledger_history.dart';
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
  }

  Stream<NormalLedgerHistoryState> getNormalLedgerHistoryApi(input) async* {
    if (await Network.isConnected()) {
      GetNormalLedgerHistoryResponse response = await apiProvider.getNormalLedgerHistory(input);
      if (response.success) {
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
            isReturn: "",
            orderDetails: listOrderDetail,
            billingDetails: [],
          );
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
          products.add(commonLedgerHistory);
        }
        yield GetNormalLedgerHistoryState(data: products);
      } else {
        yield GetNormalLedgerHistoryFailureState(succes: response.success, message: response.message);
      }
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
    }
  }
}
