import 'package:flutter/material.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/utility/color.dart';

class BillingProducts extends StatefulWidget {
  BillingProducts({Key? key}) : super(key: key);

  @override
  _BillingProductsState createState() => _BillingProductsState();
}

class _BillingProductsState extends State<BillingProducts> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          "Billing Products",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),
      body: Stack(children: [
        Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.55,
                color: Colors.amber,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 15, bottom: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Pay Amount",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          Text("\u20B9 ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPrimary)),
                          Text("1000",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPrimary)),
                        ],
                      ),
                    ]),
              ),
              Divider(
                height: 1,
                color: ColorTextPrimary,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 15, bottom: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Redeem Coins",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          Container(
                              child: Image.asset(
                            "assets/images/point.png",
                            scale: 2.5,
                          )),
                          Text(" 1000",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPrimary)),
                        ],
                      ),
                    ]),
              ),
              Divider(
                height: 1,
                color: ColorTextPrimary,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 15, bottom: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Earn Coins",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          Container(
                              child: Image.asset(
                            "assets/images/point.png",
                            scale: 2.5,
                          )),
                          Text(" 1000",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPrimary)),
                        ],
                      ),
                    ]),
              ),
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            child: InkWell(
              onTap: () {},
              child: Container(
                width: width,
                color: ColorPrimary,
                child: Center(
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                height: height * 0.07,
              ),
            ))
      ]),
    );
  }
}
