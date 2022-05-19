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
import 'package:vendor/ui_without_inventory/performancetracker/upi/master_ledger/bloc/master_ledger_history_bloc.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/master_ledger/bloc/master_ledger_history_event.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/master_ledger/bloc/master_ledger_history_state.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/master_ledger/master_ledger_full_detail.dart';
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
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
                    if (state is GetNormalLedgerState) {
                      orderList = state.orderList;
                      searchList = orderList;
                    }

                    //if (state is GetNormalLedgerHistoryLoadingState) {
                    //   return Container(
                    //       height: MediaQuery.of(context).size.height * 0.70,
                    //       child: Center(child: CircularProgressIndicator()));
                    // }

                    if (orderList.isEmpty) {
                      log("===>$_commonLedgerHistory");
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.80,
                          child: Center(child: CircularProgressIndicator()));
                    }
                    if (state is GetNormalLedgerHistoryFailureState) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.80,
                        child: Center(
                          child: Image.asset("assets/images/no_data.gif"),
                        ),
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
                        if (list.isEmpty) {
                          return Center(
                            child: Image.asset("assets/images/no_data.gif"),
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
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NormalLedgerDetails(
                                                order: searchList[index],
                                              )));
                                },
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
                                                style: GoogleFonts.openSans(
                                                    fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                                              ),
                                              Text(
                                                "${DateFormat("dd MMM yyyy").format(searchList[index].dateTime)}",
                                                style: GoogleFonts.openSans(
                                                    fontSize: 13, color: TextGrey, fontWeight: FontWeight.w600),
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
                                        //       child: widget.searchList[index].status == 1
                                        //           ? Container(
                                        //               padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                        //               decoration: BoxDecoration(
                                        //                   borderRadius: BorderRadius.circular(20), color: PendingTextBgColor),
                                        //               child: Text(
                                        //                 "pending_key".tr(),
                                        //                 style: TextStyle(
                                        //                     color: PendingTextColor, fontSize: 10, fontWeight: FontWeight.w400),
                                        //               ),
                                        //             )
                                        //           : Container(
                                        //               padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                        //               decoration: BoxDecoration(
                                        //                   borderRadius: BorderRadius.circular(20), color: ApproveTextBgColor),
                                        //               child: Text(
                                        //                 "paid_key".tr(),
                                        //                 style: TextStyle(
                                        //                     color: ApproveTextColor, fontSize: 10, fontWeight: FontWeight.w400),
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
                                    // Positioned(
                                    //   right: 0,
                                    //   top: 0,
                                    //   child: Container(
                                    //     alignment: Alignment.center,
                                    //     width: 90,
                                    //     height: 76,
                                    //     decoration: BoxDecoration(
                                    //         color: widget.searchList[index].status == 1 ? RejectedTextBgColor : GreenBoxBgColor,
                                    //         borderRadius:
                                    //             BorderRadius.only(bottomRight: Radius.circular(10), topRight: Radius.circular(10))),
                                    //     child: Text(
                                    //       " \u20B9 ${widget.searchList[index].myprofitRevenue} ",
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //           fontSize: 14,
                                    //           color: widget.searchList[index].status == 1 ? RejectedBoxTextColor : GreenBoxTextColor),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            );
                          })
                    ]);
                  }),
                  BlocBuilder<NormalLedgerHistoryBloc, NormalLedgerHistoryState>(builder: (context, state) {
                    log("state===>$state");
                    if (state is GetNormalLedgerHistoryInitialState) {
                      normalLedgerApiCall(context);
                    }
                    if (state is GetNormalLedgerState) {
                      orderList = state.orderList;
                      searchList = orderList;
                    }

                    //if (state is GetNormalLedgerHistoryLoadingState) {
                    //   return Container(
                    //       height: MediaQuery.of(context).size.height * 0.70,
                    //       child: Center(child: CircularProgressIndicator()));
                    // }

                    if (orderList.isEmpty) {
                      log("===>$_commonLedgerHistory");
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.80,
                          child: Center(child: CircularProgressIndicator()));
                    }
                    if (state is GetNormalLedgerHistoryFailureState) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.80,
                        child: Center(
                          child: Image.asset("assets/images/no_data.gif"),
                        ),
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
                        if (list.isEmpty) {
                          return Center(
                            child: Image.asset("assets/images/no_data.gif"),
                          );
                        } else {
                          searchList = list;

                          ;
                        }
                      }
                    }
                    return Column(children: [
                      searchList.first.status == 0
                          ? Container(
                              padding: EdgeInsets.only(left: 14, bottom: 10, top: 10),
                              child: Text(
                                "Settled",
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
                            if (searchList[index].status == 0) {
                              return Container();
                            }
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: () {
                                  log("searchList[index]=>${searchList[index].paymentDetails.first.bankTxnId}");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NormalLedgerDetails(
                                                // commonLedgerHistory: _commonLedgerHistory!,
                                                order: searchList[index],
                                              )));
                                },
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
                                                style: GoogleFonts.openSans(
                                                    fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                                              ),
                                              Text(
                                                "${DateFormat("dd MMM yyyy").format(searchList[index].dateTime)}",
                                                style: GoogleFonts.openSans(
                                                    fontSize: 13, color: TextGrey, fontWeight: FontWeight.w600),
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
                                        //       child: widget.searchList[index].status == 1
                                        //           ? Container(
                                        //               padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                        //               decoration: BoxDecoration(
                                        //                   borderRadius: BorderRadius.circular(20), color: PendingTextBgColor),
                                        //               child: Text(
                                        //                 "pending_key".tr(),
                                        //                 style: TextStyle(
                                        //                     color: PendingTextColor, fontSize: 10, fontWeight: FontWeight.w400),
                                        //               ),
                                        //             )
                                        //           : Container(
                                        //               padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                        //               decoration: BoxDecoration(
                                        //                   borderRadius: BorderRadius.circular(20), color: ApproveTextBgColor),
                                        //               child: Text(
                                        //                 "paid_key".tr(),
                                        //                 style: TextStyle(
                                        //                     color: ApproveTextColor, fontSize: 10, fontWeight: FontWeight.w400),
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
                                    // Positioned(
                                    //   right: 0,
                                    //   top: 0,
                                    //   child: Container(
                                    //     alignment: Alignment.center,
                                    //     width: 90,
                                    //     height: 76,
                                    //     decoration: BoxDecoration(
                                    //         color: widget.searchList[index].status == 1 ? RejectedTextBgColor : GreenBoxBgColor,
                                    //         borderRadius:
                                    //             BorderRadius.only(bottomRight: Radius.circular(10), topRight: Radius.circular(10))),
                                    //     child: Text(
                                    //       " \u20B9 ${widget.searchList[index].myprofitRevenue} ",
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //           fontSize: 14,
                                    //           color: widget.searchList[index].status == 1 ? RejectedBoxTextColor : GreenBoxTextColor),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            );
                          })
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
}
//
// class ListWidget extends StatefulWidget {
//   List<OrderData> searchList = [];
//   ListWidget(this.searchList);
//
//   @override
//   _ListWidgetState createState() => _ListWidgetState();
// }
//
// class _ListWidgetState extends State<ListWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: widget.searchList.length,
//         shrinkWrap: true,
//         itemBuilder: (context, index) {
//           if (widget.searchList[index].status == 1) {
//             return Container();
//           }
//           return ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Stack(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                   height: 80,
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.shade300,
//                         offset: Offset(0.0, 0.0), //(x,y)
//                         blurRadius: 7.0,
//                       ),
//                     ],
//                   ),
//                   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                     Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "+91 ${widget.searchList[index].mobile}",
//                             style:
//                                 GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
//                           ),
//                           Text(
//                             "${DateFormat("dd MMM yyyy").format(widget.searchList[index].dateTime)}",
//                             style: GoogleFonts.openSans(fontSize: 13, color: TextGrey, fontWeight: FontWeight.w600),
//                           ),
//                         ]),
//                     Text(
//                       " \u20B9 ${widget.searchList[index].myprofitRevenue} ",
//                       style: GoogleFonts.openSans(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: widget.searchList[index].status == 1 ? RejectedBoxTextColor : GreenBoxTextColor),
//                     ),
//                     // Row(
//                     //   children: [
//                     //     Center(
//                     //       child: widget.searchList[index].status == 1
//                     //           ? Container(
//                     //               padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
//                     //               decoration: BoxDecoration(
//                     //                   borderRadius: BorderRadius.circular(20), color: PendingTextBgColor),
//                     //               child: Text(
//                     //                 "pending_key".tr(),
//                     //                 style: TextStyle(
//                     //                     color: PendingTextColor, fontSize: 10, fontWeight: FontWeight.w400),
//                     //               ),
//                     //             )
//                     //           : Container(
//                     //               padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
//                     //               decoration: BoxDecoration(
//                     //                   borderRadius: BorderRadius.circular(20), color: ApproveTextBgColor),
//                     //               child: Text(
//                     //                 "paid_key".tr(),
//                     //                 style: TextStyle(
//                     //                     color: ApproveTextColor, fontSize: 10, fontWeight: FontWeight.w400),
//                     //               ),
//                     //             ),
//                     //     ),
//                     //     SizedBox(
//                     //       width: 5,
//                     //     ),
//                     //     Container(
//                     //       width: 90,
//                     //     )
//                     //   ],
//                     // ),
//                   ]),
//                 ),
//                 // Positioned(
//                 //   right: 0,
//                 //   top: 0,
//                 //   child: Container(
//                 //     alignment: Alignment.center,
//                 //     width: 90,
//                 //     height: 76,
//                 //     decoration: BoxDecoration(
//                 //         color: widget.searchList[index].status == 1 ? RejectedTextBgColor : GreenBoxBgColor,
//                 //         borderRadius:
//                 //             BorderRadius.only(bottomRight: Radius.circular(10), topRight: Radius.circular(10))),
//                 //     child: Text(
//                 //       " \u20B9 ${widget.searchList[index].myprofitRevenue} ",
//                 //       style: TextStyle(
//                 //           fontWeight: FontWeight.bold,
//                 //           fontSize: 14,
//                 //           color: widget.searchList[index].status == 1 ? RejectedBoxTextColor : GreenBoxTextColor),
//                 //     ),
//                 //   ),
//                 // )
//               ],
//             ),
//           );
//         });
//   }
// }
