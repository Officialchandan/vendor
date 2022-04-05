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
import 'package:vendor/ui_without_inventory/performancetracker/upi/free_coins/bloc/free_coin_history_state.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/master_ledger/bloc/master_ledger_history_bloc.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/master_ledger/bloc/master_ledger_history_event.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/master_ledger/bloc/master_ledger_history_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/widget/calendar_bottom_sheet.dart';

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
  List<OrderData> searchList = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<OrderData> orderList = [];

  NormalLedgerHistoryBloc _normalLedgerHistoryBloc = NormalLedgerHistoryBloc();
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("${now}");
    year = (now.year).toString();
    _tabController = TabController(length: 12, vsync: this, initialIndex: now.month - 1);
    log("${year}");
    // normalLedgerApiCall(context);
  }

  Future<void> normalLedgerApiCall(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["from_date"] = startDate.isEmpty ? "" : startDate.toString();
    input["to_date"] = endDate.isEmpty ? startDate.toString() : endDate.toString();
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
            actions: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return CalendarBottomSheet(onSelect: (startDate, endDate) {
                          this.startDate = startDate;
                          this.endDate = endDate;
                          print("startDate->$startDate");
                          print("endDate->$endDate");
                          normalLedgerApiCall(context);
                          // getCustomer();
                        });
                      });
                  print("startDate---1>$startDate");
                  print("endDate---1>$endDate");
                },
                child: Row(children: [
                  Icon(
                    Icons.filter_alt,
                    color: Colors.white,
                  ),
                  Center(child: Text("Filter   ")),
                ]),
              ),
            ],
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
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
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
                    hintText: "Search Here...",

                    hintStyle: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.black),
                    contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onChanged: (text) {
                    _normalLedgerHistoryBloc.add(GetFindUserEvent(searchkeyword: text));
                  },
                ),
              ),
              BlocBuilder<NormalLedgerHistoryBloc, NormalLedgerHistoryState>(builder: (context, state) {
                log("state===>$state");
                if (state is GetNormalLedgerHistoryInitialState) {
                  normalLedgerApiCall(context);
                }
                /* if (state is GetNormalLedgerHistoryState) {
                  _commonLedgerHistory = state.data!;
                }*/
                if (state is GetNormalLedgerState) {
                  orderList = state.orderList;
                  searchList = orderList;
                }

                if (orderList.isEmpty) {
                  log("===>$_commonLedgerHistory");
                  return Center(child: CircularProgressIndicator());
                }

                // if (_commonLedgerHistory == null) {
                //   log("===>$_commonLedgerHistory");
                //   return Center(child: CircularProgressIndicator());
                // }
                if (state is GetFreeCoinHistoryFailureState) {
                  return Center(
                    child: Image.asset("assets/images/no_data.gif"),
                  );
                }

                if (state is GetNormalLedgerHistoryFailureState) {
                  return Center(
                    child: Image.asset("assets/images/no_data.gif"),
                  );
                }
                if (state is GetNormalLedgerUserSearchState) {
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
                    if (list == null) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: Image.asset("assets/images/no_data.gif"),
                      );
                    } else {
                      searchList = list;
                      return ListWidget(searchList);
                    }
                  }
                }
                return ListWidget(searchList);
              }),
            ]),
          ),
        ),
      ),
    );
  }
}

class ListWidget extends StatefulWidget {
  List<OrderData> searchList = [];
  ListWidget(this.searchList);

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: widget.searchList.length,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 5),
          itemBuilder: (context, index) {
            return Container(
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
                                "    +91 ${widget.searchList[index].mobile}",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "    ${DateFormat("yyyy MM dd ").format(widget.searchList[index].dateTime)}(${DateFormat.jm().format(widget.searchList[index].dateTime)})",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ]),
                        Row(
                          children: [
                            Center(
                              child: widget.searchList[index].status == 1
                                  ? Container(
                                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20), color: PendingTextBgColor),
                                      child: Text(
                                        "Pending",
                                        style: TextStyle(
                                            color: PendingTextColor, fontSize: 10, fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20), color: ApproveTextBgColor),
                                      child: Text(
                                        "Paid",
                                        style: TextStyle(
                                            color: ApproveTextColor, fontSize: 10, fontWeight: FontWeight.w400),
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
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        alignment: Alignment.center,
                        width: 90,
                        height: 76,
                        decoration: BoxDecoration(
                            color: widget.searchList[index].status == 1 ? RejectedTextBgColor : GreenBoxBgColor,
                            borderRadius:
                                BorderRadius.only(bottomRight: Radius.circular(10), topRight: Radius.circular(10))),
                        child: Text(
                          " \u20B9 ${widget.searchList[index].myprofitRevenue} ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: widget.searchList[index].status == 1 ? RejectedBoxTextColor : GreenBoxTextColor),
                        ),
                      ),
                    )
                  ],
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
    );
  }
}