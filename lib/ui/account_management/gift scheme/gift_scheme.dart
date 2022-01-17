import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/model/gift_scheme_response.dart';
import 'package:vendor/ui/account_management/gift%20scheme/git_scheme_bloc.dart';
import 'package:vendor/ui/account_management/gift%20scheme/git_scheme_event.dart';
import 'package:vendor/ui/account_management/gift%20scheme/git_scheme_state.dart';
import 'package:vendor/utility/color.dart';

class GiftScheme extends StatefulWidget {
  GiftScheme({Key? key}) : super(key: key);

  @override
  _GiftSchemeState createState() => _GiftSchemeState();
}

class _GiftSchemeState extends State<GiftScheme> {
  // int _gift = 0;
  int? gift_id;
  GiftSchemeBloc giftSchemeBloc = GiftSchemeBloc(GiftSchemeIntialState());
  List<GiftSchemeData>? data;
  String message = "";

  TextEditingController _textFieldController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    giftSchemeBloc.add(GetGiftSchemeEvent());
    log("init===>");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "gift_scheme_key".tr(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocProvider<GiftSchemeBloc>(
        create: (context) => giftSchemeBloc,
        child: BlocConsumer<GiftSchemeBloc, GiftSchemeState>(
          listener: (context, state) {
            if (state is GetGiftSchemestate) {
              data = state.data;
              message = state.message;
            }
            if (state is GetGiftSchemeFailureState) {
              message = state.message;
            }
            if (state is GiftSchemeIntialState) {
              giftSchemeBloc.add(GetGiftSchemeEvent());
              log("initial");
            }
            if (state is GetGiftSchemeLoadingstate) {}

            if (state is GetGiftDeliverdstate) {
              giftSchemeBloc.add(GetGiftSchemeEvent());
            }
          },
          builder: (context, state) {
            if (state is GiftSchemeIntialState) {
              giftSchemeBloc.add(GetGiftSchemeEvent());
              log("initial");
            }

            if (state is GetGiftSchemeFailureState) {
              Fluttertoast.showToast(
                  msg: state.message, backgroundColor: ColorPrimary);
            }
            if (state is GetGiftSchemestate) {
              return ListView.builder(
                  itemCount: data!.length == null ? 0 : data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        // height: 150,
                        decoration: BoxDecoration(
                            color: Buttonactive,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                      "${data![index].giftImage}",
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.cover),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "gift_received_key".tr() + "?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    data![index].status == 1
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Row(children: [
                                                  Container(
                                                    width: 30,
                                                    child: Radio<int>(
                                                      activeColor: ColorPrimary,
                                                      value: 1,
                                                      visualDensity:
                                                          VisualDensity
                                                              .comfortable,
                                                      splashRadius: 15,
                                                      groupValue:
                                                          data![index].gift,
                                                      onChanged: (value) {},
                                                    ),
                                                  ),
                                                  Text(
                                                    "yes_key".tr(),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ]),
                                              ),
                                              Container(
                                                child: Row(children: [
                                                  Container(
                                                    width: 30,
                                                    child: Radio<int>(
                                                      value: 0,
                                                      activeColor: ColorPrimary,
                                                      groupValue:
                                                          data![index].gift,
                                                      onChanged: (value) {},
                                                    ),
                                                  ),
                                                  Text(
                                                    "no_key".tr(),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ]),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Row(children: [
                                                  Container(
                                                    width: 30,
                                                    child: Radio<int>(
                                                      activeColor: ColorPrimary,
                                                      value: 1,
                                                      visualDensity:
                                                          VisualDensity
                                                              .comfortable,
                                                      splashRadius: 15,
                                                      groupValue:
                                                          data![index].gift,
                                                      onChanged: (value) {
                                                        gift_id =
                                                            data![index].id;
                                                        log("===>$data![index].gift");
                                                        //setState(() {
                                                        data![index].gift =
                                                            value!;
                                                        // });
                                                        _displayDialog(
                                                            context, index);
                                                      },
                                                    ),
                                                  ),
                                                  Text(
                                                    "YES",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ]),
                                              ),
                                              Container(
                                                child: Row(children: [
                                                  Container(
                                                    width: 30,
                                                    child: Radio<int>(
                                                      value: 0,
                                                      activeColor: ColorPrimary,
                                                      groupValue:
                                                          data![index].gift,
                                                      onChanged: (value) {
                                                        log("===>");
                                                        //    setState(() {
                                                        data![index].gift =
                                                            value!;
                                                        //   });
                                                      },
                                                    ),
                                                  ),
                                                  Text(
                                                    "NO",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ]),
                                              ),
                                            ],
                                          ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${data![index].giftName}",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "qty_key".tr() + ":" + " ${data![index].qty}",
                              style: TextStyle(
                                  color: ColorTextPrimary,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${data![index].description}",
                              style: TextStyle(
                                  color: ColorTextPrimary,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
            if (state is GetGiftSchemeLoadingstate) {
              return Center(
                child: Container(
                  height: 40,
                  child: CircularProgressIndicator(
                    backgroundColor: ColorPrimary,
                  ),
                ),
              );
            }
            return Center(child: Text("$message"));
          },
        ),
      ),
    );
  }

  _displayDialog(BuildContext context, index) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: Text("you_wont_key"),
              actions: <Widget>[
                Center(
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.40,
                    height: 50,
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: ColorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      data![index].gift = 1;
                      giftSchemeBloc
                          .add(GetGiftDeliverdEvent(giftid: gift_id!));
                      data![index].gift = 1;
                      Navigator.pop(context);
                    },
                    child: new Text(
                      "done_key".tr(),
                      style: GoogleFonts.openSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width * 0.95,
                  color: Colors.transparent,
                )
              ],
            ),
          );
        });
  }
}
