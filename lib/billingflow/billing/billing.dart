import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendor/billingflow/billing/billing_bloc.dart';
import 'package:vendor/billingflow/billing/billing_event.dart';
import 'package:vendor/billingflow/billing/billing_state.dart';
import 'package:vendor/model/get_vendorcategory_id.dart';
import 'package:vendor/search_all/search_all_product.dart';
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
  List<GetVendorCategoryByIdData> category = [];
  var coins;
  @override
  void initState() {
    super.initState();
  }

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
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 10,
                ),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              msg: state.message,
                              backgroundColor: ColorPrimary);
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
                                "  ${state.data}",
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
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                child: Image.asset(
                              "assets/images/point.png",
                              scale: 2,
                            )),
                            Text(
                              "  0.0",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPrimary),
                            ),
                          ],
                        );
                      },
                    ),
                    BlocConsumer<CustomerNumberResponseBloc,
                        CustomerNumberResponseState>(
                      listener: (context, state) {},
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
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchAllProduct()));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        padding: EdgeInsets.only(left: 10),
                        color: Colors.grey[300],
                        child: Row(
                          children: [
                            Icon(Icons.search),
                            Text(
                              "  Search All Products",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Search By Category",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    BlocConsumer<CustomerNumberResponseBloc,
                        CustomerNumberResponseState>(
                      listener: (context, state) {
                        if (state is GetCategoryByVendorIdState) {
                          log("category chl gya");
                          // Fluttertoast.showToast(
                          //     backgroundColor: ColorPrimary,
                          //     textColor: Colors.white,
                          //     msg: state.message);
                        }
                        if (state is GetCategoryByVendorIdFailureState) {
                          Fluttertoast.showToast(
                              msg: state.message,
                              backgroundColor: ColorPrimary);
                        }
                      },
                      builder: (context, state) {
                        if (state is CustomerNumberResponseIntialState) {
                          customerNumberResponseBloc
                              .add(GetVendorCategoryEvent());
                        }
                        if (state is GetCategoryByVendorIdState) {
                          category = state.data!;
                        }
                        if (state is GetCategoryByVendorIdLoadingstate) {
                          return Container(
                            height: 40,
                            child: CircularProgressIndicator(
                              backgroundColor: ColorPrimary,
                            ),
                          );
                        }
                        return Container(
                            height: MediaQuery.of(context).size.height * 0.80,
                            child: categoryListWidget(category));
                      },
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

  Widget categoryListWidget(List<GetVendorCategoryByIdData> category) {
    return ListView.builder(
        itemCount: category.length,
        itemBuilder: (context, index) {
          return Container(
            // padding: EdgeInsets.all(10),

            margin: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              minLeadingWidth: 20,

              leading: CachedNetworkImage(
                imageUrl: "${category[index].image}",
                imageBuilder: (context, imageProvider) {
                  return Container(
                    padding: EdgeInsets.all(5),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                    ),
                    child: Image(
                        image: imageProvider,
                        //color: ColorPrimary,
                        height: 20,
                        width: 20,
                        //colorBlendMode: BlendMode.clear,
                        fit: BoxFit.contain),
                  );
                },
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Icon(
                  Icons.image,
                  color: ColorPrimary,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              // Image.network('${result!.data![index].image}', width: 20),
              title: Container(
                transform: Matrix4.translationValues(0, -2, 0),
                child: Text(
                  "${category[index].categoryName}",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              // trailing: ButtonTheme(
              //   minWidth: 80,
              //   height: 32,
              //   // ignore: deprecated_member_use
              //   child: RaisedButton(
              //     padding: EdgeInsets.all(0),
              //     color: Color.fromRGBO(102, 87, 244, 1),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(7),
              //     ),
              //     onPressed: () async {
              //       FocusScope.of(context).unfocus();
              //       //int id;
              //       // if (_tap == true) {
              //       //   _tap = false;
              //       //   getVendorId(
              //       //       category[index].id, category[index].categoryName);
              //       // }
              //     },
              //     child: Text(
              //       "See Category",
              //       style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 12,
              //           fontWeight: FontWeight.w600),
              //     ),
              //   ),
              //  ),
            ),
          );
        });
  }
}
