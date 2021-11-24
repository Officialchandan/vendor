import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/model/get_due_amount_response.dart';
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
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
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
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Categories",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                BlocBuilder<MoneyDueBloc, MoneyDueState>(
                  builder: (context, state) {
                    if (state is MoneyDueInitialState) {
                      moneyDueBloc.add(GetDueAmount());
                    }
                    if (state is GetDueAmountState) {
                      dueAmount = state.dueAmount;
                      categoryDue = state.categoryDue;
                    }

                    return Column(
                      children: List.generate(
                          categoryDue.length,
                          (index) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: ColorPrimary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                                  ),
                                  child: ListTile(
                                    onTap: () {},
                                    leading: Image(
                                      image: NetworkImage("${categoryDue[index].image}"),
                                      height: 30,
                                      width: 30,
                                      fit: BoxFit.contain,
                                    ),
                                    title: Text("${categoryDue[index].categoryName}"),
                                    // subtitle: Text("${categoryDue[index]["subTitle"]}"),

                                    trailing: Text("₹ ${categoryDue[index].myprofitRevenue}"),
                                  ),
                                ),
                              )),
                    );
                  },
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
              "UPI - TRANSFER",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}
