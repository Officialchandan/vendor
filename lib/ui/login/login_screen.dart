import 'dart:convert';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/UI/home/home.dart';
import 'package:vendor/UI/login/login_bloc.dart';
import 'package:vendor/UI/login/login_event.dart';
import 'package:vendor/UI/login/login_state.dart';
import 'package:vendor/localization/app_translations.dart';
import 'package:vendor/model/login_response.dart';
import 'package:vendor/provider/api_provider.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
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
  TextEditingController nameController = TextEditingController();
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
  var status = SharedPref.getStringPreference(SharedPref.USERSTATUS);

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
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
                  text:
                      "${AppTranslations.of(context)!.text("otp_verification_key")}\n",
                  style: GoogleFonts.openSans(
                    fontSize: 25.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text:
                          "${AppTranslations.of(context)!.text("please_verify_your_otp_on_key")} ${mobile}",
                      style: GoogleFonts.openSans(
                        fontSize: 14.0,
                        color: ColorTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              content: TextField(
                controller: _textFieldController,
                cursorColor: ColorPrimary,
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  filled: true,

                  // fillColor: Colors.black,
                  hintText:
                      "${AppTranslations.of(context)!.text("enter_otp_key")}",
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
                            msg: "Please enter otp",
                            backgroundColor: ColorPrimary);
                      } else {
                        loginBloc.add(GetLoginOtpEvent(
                            mobile: mobileController.text,
                            otp: _textFieldController.text)
                            
                            
                            
                            );
                      }
                      // loginApiCall(
                      //     mobileController.text, _textFieldController.text);
                    },
                    child: new Text(
                      "${AppTranslations.of(context)!.text("verify_key")}",
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
          msg:
              "${AppTranslations.of(context)!.text("please_enter_username_key")}");
      _tap = true;
    } else if (mobileController.text.length != 10) {
      Fluttertoast.showToast(
          backgroundColor: ColorPrimary,
          textColor: Colors.white,
          msg: "PLease enter valid mobile number");
      _tap = true;
    } else {
      loginBloc.add(GetLoginEvent(mobile: mobileController.text));
      //     final loginData = await ApiProvider().login(mobile);
      //     // SharedPref.setStringPreference(SharedPref.USERSTATUS, loginData.status);
      //     print("kai kroge +${jsonEncode(loginData)}");

      //     if (loginData.success == true) {
      //       _displayDialog(context, mobileController.text);
      //     } else {
      //       Fluttertoast.showToast(
      //         backgroundColor: ColorPrimary,
      //         textColor: Colors.white,
      //         msg: "Please enter vaild mobile number",

      //         // timeInSecForIos: 3
      //       );
      //     }
      //   }
      // }
      _tap = true;
    }
  }

  loginApiCall(mobile, otp) async {
    if (_textFieldController.text.isEmpty) {
      Fluttertoast.showToast(
          backgroundColor: ColorPrimary,
          textColor: Colors.white,
          msg: "${AppTranslations.of(context)!.text("please_enter_password")}");
    } else if (_textFieldController.text.length != 6) {
      Fluttertoast.showToast(
          backgroundColor: ColorPrimary,
          textColor: Colors.white,
          msg: "Please enter 6 digit valid otp");
    } else {
      loginBloc.add(GetLoginOtpEvent(
          mobile: mobileController.text, otp: _textFieldController.text));
      //   final loginData = await ApiProvider().verifyOtp(mobile, otp);
      //   print("edhar ka+${jsonEncode(loginData)}");

      //   if (loginData.success == true) {
      //     SharedPref.setBooleanPreference(SharedPref.LOGIN, true);
      //     //SharedPref.setStringPreference(SharedPref.TOKEN, loginData.token!);
      //     // SharedPref.setStringPreference(
      //     //     SharedPref.VENDORID, loginData.vendorId!.toString());

      //     // pref.setBool("login", true);
      //     // pref.setString("token", loginData.token);
      //     // pref.setBool("sucees", loginData.success);

      //     Navigator.pushAndRemoveUntil(
      //         context,
      //         MaterialPageRoute(builder: (context) => HomeScreen()),
      //         (Route<dynamic> route) => false);
      //   } else {
      //     Fluttertoast.showToast(
      //       backgroundColor: ColorPrimary,
      //       textColor: Colors.white,
      //       msg: loginData.success == false
      //           ? "${AppTranslations.of(context)!.text("otp_incorrect_key")}"
      //           : "thanks for login ",
      //       // timeInSecForIos: 3
      //     );
      //   }
    }
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
        counterText: "",
        hintText:
            "${AppTranslations.of(context)!.text("please_enter_mobile_number_key")}",
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "   +91",
              style: TextStyle(color: ColorPrimary),
            ),
            Container(
              height: 25,
              width: 1.5,
              margin: EdgeInsets.all(10),
              color: ColorTextPrimary,
            )
          ],
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        // errorText: Validator.validateMobile(edtMobile.text, context),
      ),
    );
    return BlocProvider<LoginBloc>(
      create: (context) => loginBloc,
      child: BlocConsumer<LoginBloc, LoginState>(
        bloc: loginBloc,
        listener: (context, state) {
          if (state is GetLoginState) {
            log("display khulja sim");
            _displayDialog(context, mobileController.text);
          }

          if (state is GetLoginOtpState) {
            Navigator.pushNamed(context, Routes.HomeScreen)
               ;
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
            body: SingleChildScrollView(
              child: Container(
                child: Stack(
                  children: [
                    Container(
                        // height: deviceHeight,
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
                                "${AppTranslations.of(context)!.text("login_key")}",
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
                                "${AppTranslations.of(context)!.text("add_your_details_to_login_key")}",
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
                                          "${AppTranslations.of(context)!.text("login_key")}",
                                          style: GoogleFonts.openSans(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.none),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Center(
                                        child: Text(
                                          "${AppTranslations.of(context)!.text("forget_your_password_key")}",
                                          style: GoogleFonts.openSans(
                                              fontSize: 17,
                                              color: ColorTextPrimary,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.none),
                                        ),
                                      ),

                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.center,
                                      //   children: [
                                      //     Container(
                                      //       height: 2,
                                      //       width: 80,
                                      //       color: Colors.grey,
                                      //     ),
                                      //     Text(
                                      //       "  or Login with  ",
                                      //       style: GoogleFonts.openSans(
                                      //           fontSize: 15,
                                      //           color: ColorTextPrimary,
                                      //           fontWeight: FontWeight.w600,
                                      //           decoration: TextDecoration.none),
                                      //     ),
                                      //     Container(
                                      //       height: 2,
                                      //       width: 80,
                                      //       color: Colors.grey,
                                      //     ),
                                      //   ],
                                      // ),

                                      // MaterialButton(
                                      //     minWidth: 220,
                                      //     height: 50,
                                      //     padding: const EdgeInsets.all(8.0),
                                      //     textColor: Colors.white,
                                      //     color: Colors.red,
                                      //     shape: RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.circular(25)),
                                      //     onPressed: () {
                                      //       _displayDialog(context, mobileController.text);
                                      //     },
                                      //     child: Row(
                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                      //         children: [
                                      //           Image.asset(
                                      //             'assets/images/3x/google.png',
                                      //             height: 25,
                                      //             width: 25,
                                      //           ),
                                      //           Text(
                                      //             "   Login with Google",
                                      //             style: GoogleFonts.openSans(
                                      //                 fontSize: 17,
                                      //                 fontWeight: FontWeight.w600,
                                      //                 decoration: TextDecoration.none),
                                      //           ),
                                      //         ])),
                                    ]),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
