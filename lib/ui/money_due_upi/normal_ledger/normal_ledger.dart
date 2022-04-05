import 'dart:collection';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/model/normal_ladger_response.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_bloc/normal_ledger_bloc.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_bloc/normal_ledger_event.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_details/noraml_ledger_details.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/widget/calendar_bottom_sheet.dart';

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
  List<OrderData> searchList = [];

  List<OrderData> orderList = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);
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
              "master_ledger_key".tr(),
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
                  Center(child: Text("filter_key".tr() + "   ")),
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
            child: Column(
              children: [
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
                      hintText: "search_here_key".tr(),

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
                Expanded(
                  child: ListView.builder(
                      itemCount: searchList.length,
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 5),
                      itemBuilder: (context, index) {
                        return InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NormalLedgerDetails(
                                          // commonLedgerHistory: _commonLedgerHistory!,
                                          order: searchList[index],
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
                                              "    +91 ${searchList[index].mobile}",
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "    ${DateFormat("yyyy MM dd ").format(searchList[index].dateTime)}(${DateFormat.jm().format(searchList[index].dateTime)})",
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ]),
                                      Row(
                                        children: [
                                          Center(
                                            child: searchList[index].status == 1
                                                ? Container(
                                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        color: PendingTextBgColor),
                                                    child: Text(
                                                      "pending_key".tr(),
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
                                                      "paid_key".tr(),
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
                                  searchList[index].isReturn == 1
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
                                              child: Text("return_key".tr(),
                                                  style: TextStyle(
                                                      color: Colors.white, fontSize: 10, fontWeight: FontWeight.w400)),
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
                                          color: searchList[index].status == 1 ? RejectedTextBgColor : GreenBoxBgColor,
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10), topRight: Radius.circular(10))),
                                      child: Text(
                                        " \u20B9 ${searchList[index].myprofitRevenue} ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: searchList[index].status == 1
                                                ? RejectedBoxTextColor
                                                : GreenBoxTextColor),
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
