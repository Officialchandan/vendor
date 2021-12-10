import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  int _gift = -1;
  GiftSchemeBloc giftSchemeBloc = GiftSchemeBloc(GiftSchemeIntialState());
  GiftSchemeData? data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    giftSchemeBloc.add(GetGiftSchemeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gift Scheme",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocProvider<GiftSchemeBloc>(
        create: (context) => giftSchemeBloc,
        child: BlocConsumer<GiftSchemeBloc, GiftSchemeState>(
          listener: (context, state) {
            if (state is GetGiftSchemeLoadingstate) {}
            if (state is GetGiftSchemestate) {
              data = state.data;
            }
            if (state is GetGiftSchemeFailureState) {}
          },
          builder: (context, state) {
            return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 150,
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
                                child: Image.asset(
                                    "assets/images/wallpaperflare.com_wallpaper.jpg",
                                    width: 55,
                                    height: 55,
                                    fit: BoxFit.cover),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Gift Received?",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Row(children: [
                                          Container(
                                            width: 30,
                                            child: Radio<int>(
                                              activeColor: ColorPrimary,
                                              value: 1,
                                              visualDensity:
                                                  VisualDensity.comfortable,
                                              splashRadius: 15,
                                              groupValue: _gift,
                                              onChanged: (value) {
                                                log("===>$_gift");
                                                setState(() {
                                                  _gift = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          Text(
                                            "YES",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
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
                                              groupValue: _gift,
                                              onChanged: (value) {
                                                log("===>");
                                                setState(() {
                                                  _gift = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          Text(
                                            "NO",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ]),
                                      ),
                                      // Container(
                                      //   width: 40,
                                      //   child: ListTile(
                                      //     title: const Text('NO'),
                                      //     contentPadding: EdgeInsets.all(0),
                                      //     leading: Radio<int>(
                                      //       value: 0,
                                      //       groupValue: _gift,
                                      //       onChanged: (value) {
                                      //         log("===>");
                                      //         setState(() {
                                      //           _gift = value!;
                                      //         });
                                      //       },
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          Text(
                            "Boat EarPhone",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "qty: 50",
                            style: TextStyle(
                                color: ColorTextPrimary,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Schem: above rs200 available this earphone",
                            style: TextStyle(
                                color: ColorTextPrimary,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
