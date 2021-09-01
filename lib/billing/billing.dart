import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendor/billing/billing_bloc.dart';
import 'package:vendor/billing/billing_event.dart';
import 'package:vendor/billing/billing_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/validator.dart';

class BillingScreen extends StatefulWidget {
  BillingScreen({Key? key}) : super(key: key);

  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  CustomerNumberResponseBloc customerNumberResponseBloc =
      CustomerNumberResponseBloc();
  TextEditingController mobileController = TextEditingController();
  var coins;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerNumberResponseBloc>(
      create: (context) => customerNumberResponseBloc,
      child:
          BlocConsumer<CustomerNumberResponseBloc, CustomerNumberResponseState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Billing"),
              leading: Text(""),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    height: 30,
                    width: 30,
                    child: Image.asset("assets/images/home.png"),
                  ),
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  BlocConsumer<CustomerNumberResponseBloc,
                      CustomerNumberResponseState>(
                    listener: (context, state) {
                      if (state is GetCustomerNumberResponseState) {
                        log("number chl gya");
                        // Fluttertoast.showToast(
                        //     backgroundColor: ColorPrimary,
                        //     textColor: Colors.white,
                        //     msg: state.message);
                      }
                      if (state is GetCustomerNumberResponseFailureState) {
                        Fluttertoast.showToast(
                            msg: state.message, backgroundColor: ColorPrimary);
                      }
                    },
                    builder: (context, state) {
                      if (state is GetCustomerNumberResponseState) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                child: Image.asset(
                              "assets/images/point.png",
                              scale: 2,
                            )),
                            Text(
                              "  1000",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPrimary),
                            ),
                          ],
                        );
                      }
                      if (state is GetCustomerNumberResponseLoadingstate) {
                        return Container(
                          height: 40,
                          child: CircularProgressIndicator(
                            backgroundColor: ColorPrimary,
                          ),
                        );
                      }
                      return Container(
                        height: 20,
                      );
                    },
                  ),
                  BlocConsumer<CustomerNumberResponseBloc, CustomerNumberResponseState>(
                    listener: (context, state) {
                     
                    },
                    builder: (context, state) {
                      return Container(
                        child: TextFormField(
                            controller: mobileController,
                            keyboardType: TextInputType.number,
                            validator: (numb) =>
                                Validator.validateMobile(numb!, context),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 10,
                            decoration: const InputDecoration(
                              hintText: 'Enter Customer phone number',
                              labelText: 'Mobile Number',
                              counterText: "",
                              contentPadding: EdgeInsets.all(0),
                              fillColor: Colors.transparent,
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorTextPrimary, width: 1.5)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorPrimary, width: 1.5)),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorPrimary, width: 1.5)),
                            ),
                            onChanged: (length) {
                              if (mobileController.text.length == 10) {
                                customerNumberResponseBloc.add(
                                    GetCustomerNumberResponseEvent(
                                        mobile: mobileController.text));
                              }
                            }),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    padding: EdgeInsets.only(left: 10),
                    color: Colors.grey[300],
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        Text(
                          "  Search All",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
