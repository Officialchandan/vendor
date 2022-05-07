import 'dart:collection';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vendor/model/get_master_ledger_history.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/model/normal_ladger_response.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/daily_ledger_withoutinventory/daily_ledger_bloc/daily_ledger_withoutinventory_bloc.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/daily_ledger_withoutinventory/daily_ledger_bloc/daily_ledger_withoutinventory_event.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/daily_ledger_withoutinventory/daily_ledger_bloc/daily_ledger_withoutinventory_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';

class DailyLedgerWithoutInventory extends StatefulWidget {
  const DailyLedgerWithoutInventory({Key? key}) : super(key: key);

  @override
  _DailyLedgerWithoutInventoryState createState() => _DailyLedgerWithoutInventoryState();
}

class _DailyLedgerWithoutInventoryState extends State<DailyLedgerWithoutInventory> with TickerProviderStateMixin {
  TabController? _tabController;
  List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  DateTime? dateTime;
  DateTime now = DateTime.now();
  String year = "";
  String startDate = "";
  String endDate = "";
  List<CommonLedgerHistory>? _commonLedgerHistory;
  List<OrderData> searchList = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<OrderData> orderList = [];

  DailyLedgerHistoryBloc _dailyLedgerHistoryBloc = DailyLedgerHistoryBloc();
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    log("$now");
    year = (now.year).toString();
    _tabController = TabController(length: 12, vsync: this, initialIndex: now.month - 1);
    log("$year");
    // normalLedgerApiCall(context);
  }

  Future<void> normalLedgerApiCall(BuildContext context) async {
    DateTime datenow = DateTime.now();
    String date = DateFormat("yyyy/MM/dd").format(datenow);

    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    // input["to_date"] = endDate.isEmpty ? startDate.toString() : endDate.toString();
    input["date"] = DateFormat("yyyy-mm-dd").format(DateTime.now());

    log("input---->${input}");
    _dailyLedgerHistoryBloc.add(GetDailyLedgerHistoryEvent(input: input));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DailyLedgerHistoryBloc>(
      create: (context) => _dailyLedgerHistoryBloc,
      child: DefaultTabController(
        length: months.length,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "daily_ledger_key".tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            // bottom: PreferredSize(
            //   child: Container(
            //     color: ColorPrimary,
            //     child: TabBar(
            //       indicatorWeight: 3,
            //       isScrollable: true,
            //       controller: _tabController,
            //       indicatorColor: ColorPrimary,
            //       unselectedLabelColor: Colors.white,
            //       labelColor: Colors.white,
            //       labelStyle: const TextStyle(
            //         fontSize: 18,
            //         letterSpacing: 0.67,
            //         fontWeight: FontWeight.w500,
            //       ),
            //       onTap: (a) {
            //         log("$a");
            //       },
            //       tabs: List.generate(months.length, (index) {
            //         return Tab(
            //           text: months[index].toString(),
            //         );
            //         log("${months.length}");
            //         log("${_tabController?.length}");
            //       }),
            //     ),
            //   ),
            //   preferredSize: const Size.fromHeight(50),
            // ),
          ),
          body: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: () {
              normalLedgerApiCall(context);
            },
            child: BlocBuilder<DailyLedgerHistoryBloc, DailyLedgerHistoryState>(builder: (context, state) {
              log("state===>$state");
              if (state is GetDailyLedgerHistoryInitialState) {
                normalLedgerApiCall(context);
              }

              if (state is GetDailyLedgerState) {
                orderList = state.orderList;
                searchList = orderList;
              }

              if (state is GetDailyLedgerHistoryFailureState) {
                return Center(child: Image.asset("assets/images/no_data.gif"));
              }
              if (state is GetDailyLedgerHistoryLoadingState) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is GetDailyLedgerUserSearchState) {
                if (state.searchword.isEmpty) {
                  searchList = orderList;
                } else {
                  List<OrderData> list = [];
                  orderList.forEach((element) {
                    if (element.mobile.toLowerCase().contains(state.searchword.toLowerCase())) {
                      list.add(element);
                      log("how much -->${state.searchword}");
                    }
                  });
                  if (list.isEmpty) {
                    return Image.asset("assets/images/no_data.gif");
                  } else {
                    searchList = list;
                  }
                }
              }

              return Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: TextFormField(
                        cursorColor: ColorPrimary,
                        controller: _searchController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          filled: true,

                          // fillColor: Colors.black,
                          hintText: "search_here_key".tr(),

                          hintStyle: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.black),
                          contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: textFieldBorderColor, width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: textFieldBorderColor, width: 1.0),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: textFieldBorderColor, width: 1.0),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onChanged: (text) {
                          _dailyLedgerHistoryBloc.add(GetFindUserEvent(searchkeyword: text));
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: searchList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => NormalLedgerDetails(
                                //           // commonLedgerHistory: _commonLedgerHistory!,
                                //           order: searchList[index],
                                //         )));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      height: 80,
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            offset: Offset(0.0, 0.0), //(x,y)
                                            blurRadius: 7.0,
                                          ),
                                        ],
                                      ),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "+91 ${searchList[index].mobile}",
                                                style: TextStyle(
                                                    fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                                              ),
                                              Text(
                                                "${DateFormat("yyyy MM dd ").format(searchList[index].dateTime)}(${DateFormat.jm().format(searchList[index].dateTime)})",
                                                style: TextStyle(
                                                    fontSize: 13, color: TextGrey, fontWeight: FontWeight.bold),
                                              ),
                                            ]),

                                        Text(
                                          " \u20B9 ${searchList[index].myprofitRevenue} ",
                                          style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: searchList[index].status == 1
                                                  ? RejectedBoxTextColor
                                                  : GreenBoxTextColor),
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Center(
                                        //       child: searchList[index]
                                        //                   .status ==
                                        //               1
                                        //           ? Container(
                                        //               padding: EdgeInsets
                                        //                   .symmetric(
                                        //                       vertical: 2,
                                        //                       horizontal:
                                        //                           6),
                                        //               decoration: BoxDecoration(
                                        //                   borderRadius:
                                        //                       BorderRadius
                                        //                           .circular(
                                        //                               20),
                                        //                   color:
                                        //                       PendingTextBgColor),
                                        //               child: Text(
                                        //                 "pending_key".tr(),
                                        //                 style: TextStyle(
                                        //                     color:
                                        //                         PendingTextColor,
                                        //                     fontSize: 10,
                                        //                     fontWeight:
                                        //                         FontWeight
                                        //                             .w400),
                                        //               ),
                                        //             )
                                        //           : Container(
                                        //               padding: EdgeInsets
                                        //                   .symmetric(
                                        //                       vertical: 2,
                                        //                       horizontal:
                                        //                           8),
                                        //               decoration: BoxDecoration(
                                        //                   borderRadius:
                                        //                       BorderRadius
                                        //                           .circular(
                                        //                               20),
                                        //                   color:
                                        //                       ApproveTextBgColor),
                                        //               child: Text(
                                        //                 "paid_key".tr(),
                                        //                 style: TextStyle(
                                        //                     color:
                                        //                         ApproveTextColor,
                                        //                     fontSize: 10,
                                        //                     fontWeight:
                                        //                         FontWeight
                                        //                             .w400),
                                        //               ),
                                        //             ),
                                        //     ),
                                        //     SizedBox(
                                        //       width: 5,
                                        //     ),
                                        //     Container(
                                        //       width: 90,
                                        //     )
                                        //   ],
                                        // ),
                                      ]),
                                    ),
                                    // searchList[index].isReturn == 1
                                    //     ? Positioned(
                                    //         top: -28,
                                    //         left: -25,
                                    //         child: Transform.rotate(
                                    //           angle: -0.6,
                                    //           child: Container(
                                    //             padding: EdgeInsets.fromLTRB(
                                    //                 18, 32, 30, 2),
                                    //             decoration: BoxDecoration(
                                    //               color: Color(0xff6657f4),
                                    //             ),
                                    //             child: Text("return_key".tr(),
                                    //                 style: TextStyle(
                                    //                     color: Colors.white,
                                    //                     fontSize: 10,
                                    //                     fontWeight:
                                    //                         FontWeight.w400)),
                                    //           ),
                                    //         ),
                                    //       )
                                    //     : Container(),
                                    // Positioned(
                                    //   right: 0,
                                    //   top: 0,
                                    //   child: Container(
                                    //     alignment: Alignment.center,
                                    //     width: 90,
                                    //     height: 76,
                                    //     decoration: BoxDecoration(
                                    //         color: searchList[index].status == 1
                                    //             ? RejectedTextBgColor
                                    //             : GreenBoxBgColor,
                                    //         borderRadius: BorderRadius.only(
                                    //             bottomRight:
                                    //                 Radius.circular(10),
                                    //             topRight: Radius.circular(10))),
                                    //     child: Text(
                                    //       " \u20B9 ${searchList[index].myprofitRevenue} ",
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //           fontSize: 14,
                                    //           color:
                                    //               searchList[index].status == 1
                                    //                   ? RejectedBoxTextColor
                                    //                   : GreenBoxTextColor),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              );
            }),
          ),
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
                    "   ${"select_week_key".tr()}",
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
                            "cancel_key".tr(),
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
                            "done_key".tr(),
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
                "select_days_key".tr(),
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
                        "cancel_key".tr(),
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
                        "done_key".tr(),
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
