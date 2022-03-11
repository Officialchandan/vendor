import 'dart:collection';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/ui/money_due_upi/free_coins/free_coins_history_bloc/free_coin_history_state.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_bloc/normal_ledger_bloc.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_bloc/normal_ledger_event.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_bloc/normal_ledger_state.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_details/noraml_ledger_details.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';

import '../../../model/get_master_ledger_history.dart';

class NormalLedger extends StatefulWidget {
  const NormalLedger({Key? key}) : super(key: key);

  @override
  _NormalLedgerState createState() => _NormalLedgerState();
}

class _NormalLedgerState extends State<NormalLedger> with TickerProviderStateMixin {
  TabController? _tabController;
  List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  DateTime? dateTime;
  DateTime now = DateTime.now();
  String year = "";
  String startDate = "";
  String endDate = "";
  List<CommonLedgerHistory>? _commonLedgerHistory;
  NormalLedgerHistoryBloc _normalLedgerHistoryBloc = NormalLedgerHistoryBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("${now}");
    year = (now.year).toString();
    _tabController = TabController(length: 12, vsync: this, initialIndex: now.month - 1);
    log("${year}");
    normalLedgerApiCall(context);
  }

  Future<void> normalLedgerApiCall(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["from_date"] = "";
    input["to_date"] = "";
    _normalLedgerHistoryBloc.add(GetNormalLedgerHistoryEvent(input: input));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NormalLedgerHistoryBloc>(
      create: (context) => _normalLedgerHistoryBloc,
      child: DefaultTabController(
        length: months.length,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Master Ledger",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            bottom: PreferredSize(
              child: Container(
                color: ColorPrimary,
                child: TabBar(
                  indicatorWeight: 3,
                  isScrollable: true,
                  controller: _tabController,
                  indicatorColor: ColorPrimary,
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.white,
                  labelStyle: const TextStyle(
                    fontSize: 18,
                    letterSpacing: 0.67,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: List.generate(months.length, (index) {
                    return Tab(
                      text: months[index].toString(),
                    );
                    log("${months.length}");
                  }),
                ),
              ),
              preferredSize: const Size.fromHeight(50),
            ),
          ),
          body: BlocBuilder<NormalLedgerHistoryBloc, NormalLedgerHistoryState>(builder: (context, state) {
            if (state is GetNormalLedgerHistoryInitialState) {
              normalLedgerApiCall(context);
            }
            if (state is GetNormalLedgerHistoryState) {
              _commonLedgerHistory = state.data!;
            }
            if (_commonLedgerHistory == null) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is GetFreeCoinHistoryFailureState) {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Image.asset("assets/images/no_data.gif"),
              );
            }
            return Container(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: Colors.grey[100],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showPicker();
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            decoration: BoxDecoration(color: Colors.grey[350], borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Week",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDaysPicker();
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            decoration: BoxDecoration(color: Colors.grey[350], borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Day",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: _commonLedgerHistory!.length,
                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 5),
                        itemBuilder: (context, index) {
                          return InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NormalLedgerDetails(
                                            commonLedgerHistory: _commonLedgerHistory!,
                                            index: index,
                                          )));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: Offset(0, 0), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      padding: EdgeInsets.only(bottom: 12, top: 3),
                                      // height: 70,
                                      // decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.circular(10),
                                      //     color: Colors.white,
                                      //     border: Border.all(color: Colors.white38),
                                      //     boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1.0, spreadRadius: 1)]),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "    +91 ${_commonLedgerHistory![index].mobile}",
                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "    ${_commonLedgerHistory![index].dateTime}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ]),
                                        Row(
                                          children: [
                                            Center(
                                              child: _commonLedgerHistory![index].status == 0
                                                  ? Container(
                                                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: PendingTextBgColor),
                                                      child: Text(
                                                        "Pending",
                                                        style: TextStyle(
                                                            color: PendingTextColor,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w400),
                                                      ),
                                                    )
                                                  : Container(
                                                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: ApproveTextBgColor),
                                                      child: Text(
                                                        "Paid",
                                                        style: TextStyle(
                                                            color: ApproveTextColor,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w400),
                                                      ),
                                                    ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              width: 90,
                                            )
                                          ],
                                        ),
                                      ]),
                                    ),
                                    _commonLedgerHistory![index].isReturn == 1
                                        ? Positioned(
                                            top: -28,
                                            left: -25,
                                            child: Transform.rotate(
                                              angle: -0.6,
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(18, 32, 30, 2),
                                                decoration: BoxDecoration(
                                                  color: Color(0xff6657f4),
                                                ),
                                                child: Text("Return",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w400)),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 90,
                                        height: 76,
                                        decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(10), topRight: Radius.circular(10))),
                                        child: Text(
                                          " \u20B9 ${_commonLedgerHistory![index].myprofitRevenue} ",
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                          // Positioned(
                          //     top: 10,
                          //     left: 0,
                          //
                          //
                          // ),

                          // ]);
                        }),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  List<Widget> days = [
    Text("Mon"),
    Text("Tue"),
    Text("Wed"),
    Text("Thr"),
    Text("Fri"),
    Text("Sat"),
    Text("Sun"),
  ];
  String selectedValue = "";

  List<Widget> Weeks = [
    Text("Week 1"),
    Text("Week 2"),
    Text("Week 3"),
    Text("Week 4"),
    Text("Week 5"),
    Text("Week 6"),
  ];
  String weekselectedValue = "";

  void showPicker() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.40,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "   Select Week",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).copyWith().size.height * 0.30,
                      color: Colors.white,
                      child: CupertinoPicker(
                        children: Weeks,
                        onSelectedItemChanged: (value) {
                          log("$value");
                          // Text text = countries[value];
                          // selectedValue = text.data.toString();
                          setState(() {});
                        },
                        itemExtent: 25,
                        diameterRatio: 1,
                        useMagnifier: true,
                        scrollController: FixedExtentScrollController(initialItem: 1),
                        magnification: 1.3,
                        looping: true,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 30,
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 30,
                          child: Text(
                            "Done",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorPrimary),
                          ),
                        ),
                      )
                    ],
                  )
                ]),
          );
        });
  }

  void showDaysPicker() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.40,
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                "Select Days",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                  height: MediaQuery.of(context).copyWith().size.height * 0.30,
                  color: Colors.white,
                  child: CupertinoPicker(
                    children: days,
                    onSelectedItemChanged: (value) {
                      log("$value");
                      // Text text = countries[value];
                      // selectedValue = text.data.toString();
                      setState(() {});
                    },
                    itemExtent: 25,
                    diameterRatio: 1,
                    useMagnifier: true,
                    scrollController: FixedExtentScrollController(initialItem: 1),
                    magnification: 1.3,
                    looping: true,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      log("${_tabController!.index}");
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 30,
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 30,
                      child: Text(
                        "Done",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorPrimary),
                      ),
                    ),
                  )
                ],
              )
            ]),
          );
        });
  }
}
