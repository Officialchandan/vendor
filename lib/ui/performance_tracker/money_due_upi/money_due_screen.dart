import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/ui/performance_tracker/money_due_upi/bloc/money_due_bloc.dart';
import 'package:vendor/ui/performance_tracker/money_due_upi/bloc/money_due_event.dart';
import 'package:vendor/ui/performance_tracker/money_due_upi/bloc/money_due_state.dart';
import 'package:vendor/utility/color.dart';

class MoneyDueScreen extends StatefulWidget {
  @override
  _MoneyDueScreenState createState() => _MoneyDueScreenState();
}

class _MoneyDueScreenState extends State<MoneyDueScreen> {
  MoneyDueBloc moneyDueBloc = MoneyDueBloc();
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
          title: Text("Money_Due_UPI_key".tr()),
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
                      "Company_due_amount_key".tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(15.0),
              //   child: Text(
              //     "Categories",
              //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
