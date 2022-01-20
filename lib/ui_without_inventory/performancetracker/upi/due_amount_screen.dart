import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/model/get_due_amount_response.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/bloc/due_amount_bloc.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/bloc/due_amount_event.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/bloc/due_amount_state.dart';

import 'package:vendor/utility/color.dart';

class DueAmountScreen extends StatefulWidget {
  @override
  _DueAmountScreenState createState() => _DueAmountScreenState();
}

class _DueAmountScreenState extends State<DueAmountScreen> {
  MoneyDueBloc moneyDueBloc = MoneyDueBloc();

  List<CategoryDueAmount> categoryDue = [];
  String dueAmount = "0.0";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MoneyDueBloc>(
      create: (context) => moneyDueBloc,
      child: Scaffold(
          appBar: AppBar(
            title: Text("money_due_upi_key".tr()),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.50,
                  color: ColorPrimary,
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<MoneyDueBloc, MoneyDueState>(
                        builder: (context, state) {
                          if (state is MoneyDueInitialState) {
                            moneyDueBloc.add(GetDueAmount());
                          }
                          if (state is GetDueAmountState) {
                            dueAmount = state.dueAmount;
                            categoryDue = state.categoryDue;
                          }

                          return Text(
                            "₹ $dueAmount",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          );
                        },
                      ),
                      Text(
                        "company_due_amount_key".tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: MaterialButton(
            onPressed: () {},
            color: ColorPrimary,
            height: 50,
            shape: RoundedRectangleBorder(),
            child: Text(
              "upi_transfer_key".tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}
