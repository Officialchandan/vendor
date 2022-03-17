import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/ui/login/login_bloc.dart';
import 'package:vendor/ui/login/login_event.dart';
import 'package:vendor/ui/login/login_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/routs.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode focusNode = new FocusNode();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  bool _passwordVisible = true;
  LoginBloc loginBloc = LoginBloc();

  // void _toggle() {
  //   setState(() {
  //     _passwordVisible = !_passwordVisible;
  //   });
  // }

  bool _tap = true;

  var email;

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "email_is_required_key".tr();
    } else if (!regExp.hasMatch(value)) {
      return "invalid_email_key".tr();
    } else {
      return null;
    }
  }

  TextEditingController _textFieldController = TextEditingController();

  onTouchKeyBoard() {
    return GestureDetector(onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    });
  }

  _displayDialog(BuildContext context, mobile) async {
    return showDialog(
        context: context,
        builder: (context) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: RichText(
                text: TextSpan(
                  text: "${"otp_verification_key".tr()}\n",
                  style: GoogleFonts.openSans(
                    fontSize: 25.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: "${"please_verify_your_otp_on_key".tr()} $mobile",
                      style: GoogleFonts.openSans(
                        fontSize: 14.0,
                        color: ColorTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              content: TextFormField(
                controller: _textFieldController,
                cursorColor: ColorPrimary,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  filled: true,

                  // fillColor: Colors.black,
                  hintText: "enter_otp_key".tr(),
                  hintStyle: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                  ),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              actions: <Widget>[
                Center(
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.60,
                    height: 50,
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: ColorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      if (_textFieldController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "please_enter_password_key".tr(),
                            backgroundColor: ColorPrimary);
                      } else {
                        loginBloc.add(GetLoginOtpEvent(
                            mobile: mobileController.text,
                            otp: _textFieldController.text));
                      }
                      // loginApiCall(
                      //     mobileController.text, _textFieldController.text);
                    },
                    child: new Text(
                      "verify_key".tr(),
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

  loginApiOtpCall(mobile) async {
    if (mobileController.text.isEmpty) {
      Fluttertoast.showToast(
          backgroundColor: ColorPrimary,
          textColor: Colors.white,
          msg: "please_enter_username_key".tr());
      _tap = true;
    } else if (mobileController.text.length != 10) {
      Fluttertoast.showToast(
          backgroundColor: ColorPrimary,
          textColor: Colors.white,
          msg: "please_enter_valid_mobile_key".tr());
      _tap = true;
    } else {
      EasyLoading.show();
      loginBloc.add(GetLoginEvent(mobile: mobileController.text));

      _tap = true;
    }
  }

  loginApiCall(mobile, otp) async {
    if (_textFieldController.text.isEmpty) {
      Fluttertoast.showToast(
          backgroundColor: ColorPrimary,
          textColor: Colors.white,
          msg: "please_enter_password_key".tr());
    } else if (_textFieldController.text.length != 6) {
      Fluttertoast.showToast(
          backgroundColor: ColorPrimary,
          textColor: Colors.white,
          msg: "please_enter_6_digit_valid_otp_key".tr());
    } else {
      loginBloc.add(GetLoginOtpEvent(
          mobile: mobileController.text, otp: _textFieldController.text));
    }
  }

  _onrefresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    Widget mobileNumber = TextFormField(
      keyboardType: TextInputType.number,
      validator: (numb) => Validator.validateMobile(numb!, context),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 10,
      controller: mobileController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(242, 242, 242, 1),
        counterText: "",
        hintText: "please_enter_mobile_number_key".tr(),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "  +91  ",
              style: TextStyle(color: ColorPrimary),
            ),
            Container(
              height: 25,
              width: 1.5,
              margin: EdgeInsets.all(2),
              color: ColorTextPrimary,
            )
          ],
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        prefixIconConstraints: BoxConstraints(
            minWidth: 50, minHeight: 25, maxWidth: 51, maxHeight: 25),
        // errorText: Validator.validateMobile(edtMobile.text, context),
      ),
    );
    return BlocProvider<LoginBloc>(
      create: (context) => loginBloc,
      child: BlocConsumer<LoginBloc, LoginState>(
        bloc: loginBloc,
        listener: (context, state) async {
          int status =
              await SharedPref.getIntegerPreference(SharedPref.USERSTATUS);
          if (state is GetLoginState) {
            log("display khulja sim");
            _displayDialog(context, mobileController.text);
          }

          if (state is GetLoginOtpState) {
            if (await SharedPref.getIntegerPreference(SharedPref.USERSTATUS) ==
                0) {
              Navigator.pushNamedAndRemoveUntil(context,
                  Routes.HomeScreenWithoutInventory, ModalRoute.withName("/"));
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.HomeScreen, ModalRoute.withName("/"));
            }
          }

          if (state is GetLoginFailureState) {
            Fluttertoast.showToast(
                backgroundColor: ColorPrimary,
                textColor: Colors.white,
                msg: state.message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () {
                return _onrefresh();
              },
              child: SingleChildScrollView(
                child: Container(
                  child: Stack(
                    children: [
                      Container(
                          // height: deviceHeight,Ftex
                          //width: 400,
                          child: Image.asset(
                        "assets/images/bg.png",
                        height: deviceHeight,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      )),
                      Positioned(
                        left: 20,
                        right: 20,
                        top: deviceHeight * 0.17,
                        child: Container(
                          width: 500,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Center(
                                //   child: RichText(
                                //     text: TextSpan(
                                //         text: 'Don\'t have an Account?',
                                //         style: TextStyle(
                                //             color: ColorTextPrimary,
                                //             fontWeight: FontWeight.w600,
                                //             fontSize: 18),
                                //         children: <TextSpan>[
                                //           TextSpan(
                                //               text: ' Sign up',
                                //               style: TextStyle(
                                //                   fontWeight: FontWeight.w600,
                                //                   color: ColorPrimary,
                                //                   fontSize: 18),
                                //               recognizer: TapGestureRecognizer()
                                //                 ..onTap = () {
                                //                   Navigator.push(
                                //                       context,
                                //                       MaterialPageRoute(
                                //                           builder: (context) =>
                                //                               SignUp()));
                                //                 })
                                //         ]),
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 35,
                                // ),
                                Text(
                                  "login_key".tr(),
                                  style: GoogleFonts.openSans(
                                      fontSize: 28,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.none),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "add_your_details_to_login_key".tr(),
                                  style: GoogleFonts.openSans(
                                      fontSize: 17,
                                      color: ColorTextPrimary,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.none),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                mobileNumber,
                                SizedBox(
                                  height: 80,
                                ),
                                Center(
                                  child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          minWidth: deviceWidth * 0.65,
                                          height: 50,
                                          padding: const EdgeInsets.all(8.0),
                                          textColor: Colors.white,
                                          color: ColorPrimary,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          onPressed: () {
                                            _textFieldController.clear();

                                            print(
                                                "kuch to ${mobileController.text}");
                                            // loginApiCall(
                                            //     nameController.text, passwordController.text);
                                            if (_tap == true) {
                                              _tap = false;
                                              loginApiOtpCall(
                                                  mobileController.text);
                                            }
                                            // _displayDialog(
                                            //     context, mobileController.text);
                                          },
                                          child: new Text(
                                            "login_key".tr(),
                                            style: GoogleFonts.openSans(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Center(
                                          child: Text(
                                            "forget_your_password_key".tr(),
                                            style: GoogleFonts.openSans(
                                                fontSize: 17,
                                                color: ColorTextPrimary,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        ),
                                      ]),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: ColorPrimary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "Powered By ",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Text(
                    " Tech Points Concepts Pvt Ltd",
                    style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
