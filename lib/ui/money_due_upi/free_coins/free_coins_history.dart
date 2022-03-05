import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/model/free_coin_history.dart';
import 'package:vendor/ui/money_due_upi/free_coins/free_coins_history_bloc/free_coin_history_bloc.dart';
import 'package:vendor/ui/money_due_upi/free_coins/free_coins_history_bloc/free_coin_history_event.dart';
import 'package:vendor/ui/money_due_upi/free_coins/free_coins_history_bloc/free_coin_history_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/widget/calendar_bottom_sheet.dart';

import 'free_coin_details/free_coin_detail.dart';

class FreeCoinsHistory extends StatefulWidget {
  const FreeCoinsHistory({Key? key}) : super(key: key);

  @override
  _FreeCoinsHistoryState createState() => _FreeCoinsHistoryState();
}

class _FreeCoinsHistoryState extends State<FreeCoinsHistory> {
  String startDate = "";
  String endDate = "";
  TextEditingController _searchController = TextEditingController();
  FreeCoinHistoryBloc freeCoinHistoryBloc = FreeCoinHistoryBloc();
  List<GetFreeCoinHistoryData> searchList = [];
  List<GetFreeCoinHistoryData>? freecoinsdata;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterApiCall(context);
  }

  Future<void> filterApiCall(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["from_date"] = startDate.isEmpty ? "" : startDate.toString();
    input["to_date"] = endDate.isEmpty ? startDate.toString() : endDate.toString();
    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    log("=====? $input");
    freeCoinHistoryBloc.add(GetFreeCoinsHistoryEvent(input: input));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FreeCoinHistoryBloc>(
      create: (context) => freeCoinHistoryBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Free Coins",
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
                        filterApiCall(context);
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
        ),
        body: BlocBuilder<FreeCoinHistoryBloc, FreeCoinHistoryState>(builder: (context, state) {
          if (state is GetFreeCoinHistoryInitialState) {
            filterApiCall(context);
          }
          if (state is GetFreeCoinHistoryState) {
            freecoinsdata = state.data;
            searchList = freecoinsdata!;
          }
          if (freecoinsdata == null) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GetFreeCoinHistoryFailureState) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Image.asset("assets/images/no_data.gif"),
            );
          }
          if (state is GetFreeCoinUserSearchState) {
            if (state.searchword.isEmpty) {
              searchList = freecoinsdata!;
            } else {
              List<GetFreeCoinHistoryData> list = [];
              freecoinsdata!.forEach((element) {
                if (element.mobile.toLowerCase().contains(state.searchword.toLowerCase())) {
                  list.add(element);
                  log("how much -->${state.searchword}");
                }
              });
              if (list.isEmpty) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset("assets/images/no_data.gif"),
                );
              } else {
                searchList = list;
              }
            }
          }
          return Container(
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
                      freeCoinHistoryBloc.add(FindUserEvent(searchkeyword: text));
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      itemCount: searchList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: FreeCoinDetail(freecoindetail: searchList[index]),
                                    type: PageTransitionType.fade));
                          },
                          child: Stack(children: [
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              padding: EdgeInsets.all(0),
                              height: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white38),
                                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1.0, spreadRadius: 1)]),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 12.0),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "+91 ${searchList[index].mobile}",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${searchList[index].dateTime}",
                                        ),
                                      ]),
                                ),
                                Container(
                                  width: 90,
                                ),
                              ]),
                            ),
                            Positioned(
                              right: 0,
                              top: 15,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 5),
                                width: 90,
                                height: 70,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10), topRight: Radius.circular(10))),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Earn",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                                      ),
                                      Row(children: [
                                        Image.asset(
                                          "assets/images/point.png",
                                          scale: 2.5,
                                        ),
                                        Text(
                                          " ${searchList[index].orderDetails[index].earningCoins} ",
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: ColorPrimary),
                                        ),
                                      ]),
                                    ]),
                              ),
                            )
                          ]),
                        );
                      }),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
