import 'dart:collection';

import 'package:flutter/material.dart';

import 'upi_transfer_detail_ledger_bloc/upi_transfer_detail_ledger_bloc.dart';
import 'upi_transfer_detail_ledger_bloc/upi_transfer_detail_ledger_event.dart';

class UpiTransferDetailLedger extends StatefulWidget {
  int billingid;
  int orderId;
  int salereturn;
  UpiTransferDetailLedger({Key? key, required this.billingid, required this.orderId, required this.salereturn})
      : super(key: key);

  @override
  State<UpiTransferDetailLedger> createState() => _UpiTransferDetailLedgerState();
}

class _UpiTransferDetailLedgerState extends State<UpiTransferDetailLedger> {
  UpiTansferHistoryDeatilLedgerBloc _upiTansferHistoryDeatilLedgerBloc = UpiTansferHistoryDeatilLedgerBloc();

  ledgerdetaiapi() {
    Map<String, dynamic> input = HashMap();

    input['order_id'] = widget.orderId.toString().length > 8 ? "" : widget.orderId;
    input["billing_id"] = widget.billingid.toString().length > 8 ? "" : widget.billingid;

    _upiTansferHistoryDeatilLedgerBloc.add(GetUpiTansferHistoryDeatilLedgerEvent(input: input));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ledgerdetaiapi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "UPI Tansiction Product Detail",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(),
        ));
  }
}
