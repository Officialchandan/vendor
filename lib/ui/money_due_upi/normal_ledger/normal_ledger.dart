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
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_bloc/normal_ledger_state.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_details/noraml_ledger_details.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/widget/calendar_bottom_sheet.dart';
import 'package:vendor/widget/progress_indecator.dart';

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
    _refreshController.refreshCompleted();
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
                        return CalendarBottomSheet(
                            endDate: endDate,
                            startDate: startDate,
                            onSelect: (startDate, endDate) {
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
                  Center(child: Text("${"filter_key".tr()}   ")),
                ]),
              ),
            ],
          ),
          body: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: () {
              normalLedgerApiCall(context);
            },
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
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
                    if (state is GetNormalLedgerHistoryFailureState) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.80,
                        child: Image.asset("assets/images/no_data.gif"),
                      );
                    }
                    if (orderList.isEmpty) {
                      log("===>$_commonLedgerHistory");
                      if (state is GetNormalLedgerHistoryFailureState) {
                        return Container(
                          height: MediaQuery.of(context).size.height * .50,
                          child: Center(child: Image.asset("assets/images/no_data.gif")),
                        );
                      } else if (state is GetNormalLedgerUserSearchState) {
                        return Container(
                          height: MediaQuery.of(context).size.height * .50,
                          child: Center(child: Image.asset("assets/images/no_data.gif")),
                        );
                      } else {
                        return Container(
                            height: MediaQuery.of(context).size.height * 0.80, child: Center(child: CircularLoader()));
                      }
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
                        if (list == null || list.isEmpty) {
                          return Container(
                            height: MediaQuery.of(context).size.height * .50,
                            child: Center(child: Image.asset("assets/images/no_data.gif")),
                          );
                        } else {
                          searchList = list;
                        }
                      }
                    }
                    return Column(children: [
                      searchList.first.status == 0
                          ? Container(
                              padding: EdgeInsets.only(left: 14, bottom: 10, top: 10),
                              child: Text(
                                "Pending",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ColorTextPrimary),
                              ),
                              alignment: Alignment.topLeft,
                            )
                          : Container(),
                      ListView.builder(
                          itemCount: searchList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (searchList[index].status == 1) {
                              return Container();
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              child: InkWell(
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
                                child: Stack(children: [
                                  Container(
                                    height: 80,
                                    padding: EdgeInsets.all(14),
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
                                              "     +91 ${searchList[index].mobile}",
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                                            ),
                                            Text(
                                              "      ${DateFormat("dd MMM yyyy").format(searchList[index].dateTime)}-${DateFormat.jm().format(searchList[index].dateTime)}",
                                              style:
                                                  TextStyle(fontSize: 13, color: TextGrey, fontWeight: FontWeight.bold),
                                            ),
                                          ]),
                                      searchList[index].myProfitVendor == "0"
                                          ? Text(
                                              " \u20B9 ${double.parse(searchList[index].vendorMyProfit).toStringAsFixed(2)} ",
                                              style: GoogleFonts.openSans(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: RejectedBoxTextColor),
                                            )
                                          : Text(
                                              " \u20B9 ${double.parse(searchList[index].myProfitVendor).toStringAsFixed(2)} ",
                                              style: GoogleFonts.openSans(
                                                  fontWeight: FontWeight.bold, fontSize: 20, color: GreenBoxTextColor),
                                            ),
                                    ]),
                                  ),
                                  searchList[index].isReturn == 1
                                      ? Positioned(
                                          left: 0,
                                          bottom: 0,
                                          child: Container(
                                            height: 80,
                                            width: 28,
                                            decoration: BoxDecoration(
                                                color: ColorPrimary,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(7), bottomLeft: Radius.circular(7))),
                                            child: RotatedBox(
                                              quarterTurns: 3,
                                              child: Center(
                                                child: Text("return_key".tr(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400)),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ]),
                              ),
                            );
                          }),
                    ]);
                  }),
                  BlocBuilder<NormalLedgerHistoryBloc, NormalLedgerHistoryState>(builder: (context, state) {
                    log("state===>$state");
                    // if (state is GetNormalLedgerHistoryInitialState) {
                    //   normalLedgerApiCall(context);
                    // }
                    /* if (state is GetNormalLedgerHistoryState) {
                        _commonLedgerHistory = state.data!;
                      }*/
                    // if (state is GetNormalLedgerState) {
                    //   orderList = state.orderList;
                    //   searchList = orderList;
                    // }
                    // if (state is GetNormalLedgerHistoryFailureState) {
                    //   return Container(
                    //     height: MediaQuery.of(context).size.height * 0.80,
                    //     child: Image.asset("assets/images/no_data.gif"),
                    //   );
                    // }
                    // if (orderList.isEmpty) {
                    //   log("===>$_commonLedgerHistory");
                    //   return Container(
                    //       height: MediaQuery.of(context).size.height * 0.80,
                    //       child: Center(child: CircularLoader()));
                    // }
                    if (state is GetNormalLedgerUserSearchState) {
                      if (state.searchword.isEmpty) {
                        searchList = orderList.isEmpty ? [] : orderList;
                      } else {
                        List<OrderData> list = [];
                        orderList.forEach((element) {
                          if (element.mobile.toLowerCase().contains(state.searchword.toLowerCase())) {
                            list.add(element);
                            log("how much -->${state.searchword}");
                          }
                        });
                        if (list == null || list.isEmpty) {
                          return Container();
                        } else {
                          searchList = list;
                        }
                      }
                    }
                    return searchList.isEmpty
                        ? Container()
                        : Column(children: [
                            searchList.first.status == 0
                                ? Container(
                                    padding: EdgeInsets.only(left: 14, bottom: 10, top: 10),
                                    child: Text(
                                      "Settled",
                                      style:
                                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ColorTextPrimary),
                                    ),
                                    alignment: Alignment.topLeft,
                                  )
                                : Container(),
                            ListView.builder(
                                itemCount: searchList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (searchList[index].status == 0) {
                                    return Container();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    child: InkWell(
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
                                      child: Stack(children: [
                                        Container(
                                          height: 80,
                                          padding: EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                // color: Colors.grey.shade300,
                                                offset: Offset(0.0, 0.2), //(x,y)
                                                blurRadius: 0,
                                              ),
                                            ],
                                          ),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "     +91 ${searchList[index].mobile}",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: TextBlackLight),
                                                  ),
                                                  Text(
                                                    "      ${DateFormat("dd MMM yyyy").format(searchList[index].dateTime)}",
                                                    style: TextStyle(
                                                        fontSize: 13, color: TextGrey, fontWeight: FontWeight.bold),
                                                  ),
                                                ]),

                                            // Center(
                                            //   child: searchList[index].status == 1
                                            //       ? Container(
                                            //           padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                            //           decoration: BoxDecoration(
                                            //               borderRadius: BorderRadius.circular(20),
                                            //               color: PendingTextBgColor),
                                            //           child: Text(
                                            //             "pending_key".tr(),
                                            //             style: TextStyle(
                                            //                 color: PendingTextColor,
                                            //                 fontSize: 10,
                                            //                 fontWeight: FontWeight.w400),
                                            //           ),
                                            //         )
                                            //       : Container(
                                            //           padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                            //           decoration: BoxDecoration(
                                            //               borderRadius: BorderRadius.circular(20),
                                            //               color: ApproveTextBgColor),
                                            //           child: Text(
                                            //             "paid_key".tr(),
                                            //             style: TextStyle(
                                            //                 color: ApproveTextColor,
                                            //                 fontSize: 10,
                                            //                 fontWeight: FontWeight.w400),
                                            //           ),
                                            //         ),
                                            // ),
                                            searchList[index].myProfitVendor == "0"
                                                ? Text(
                                                    " \u20B9 ${double.parse(searchList[index].vendorMyProfit).toStringAsFixed(2)} ",
                                                    style: GoogleFonts.openSans(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20,
                                                        color: RejectedBoxTextColor),
                                                  )
                                                : Text(
                                                    " \u20B9 ${double.parse(searchList[index].myProfitVendor).toStringAsFixed(2)} ",
                                                    style: GoogleFonts.openSans(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20,
                                                        color: GreenBoxTextColor),
                                                  ),
                                          ]),
                                        ),
                                        searchList[index].isReturn == 1
                                            ? Positioned(
                                                left: 0,
                                                bottom: 0,
                                                child: Container(
                                                  height: 80,
                                                  width: 28,
                                                  decoration: BoxDecoration(
                                                      color: ColorPrimary,
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(7), bottomLeft: Radius.circular(7))),
                                                  child: RotatedBox(
                                                    quarterTurns: 3,
                                                    child: Center(
                                                      child: Text("return_key".tr(),
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400)),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ]),
                                    ),
                                  );
                                }),
                          ]);
                  }),
                ]))
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
