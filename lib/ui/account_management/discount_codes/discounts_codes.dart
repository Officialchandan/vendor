import 'package:flutter/material.dart';
import 'package:vendor/utility/color.dart';

class DiscountCodes extends StatefulWidget {
  DiscountCodes({Key? key}) : super(key: key);

  @override
  _DiscountCodesState createState() => _DiscountCodesState();
}

class _DiscountCodesState extends State<DiscountCodes> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Discount Codes",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            leadingWidth: 30,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios))),
        body: Container(
          child: Stack(
            children: [
              ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 130,
                      margin: EdgeInsets.all(20),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "FESTIVE10",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  height: 25,
                                  child: Switch(
                                    value: isSwitched,
                                    onChanged: (value) {
                                      setState(() {
                                        isSwitched = value;
                                        print(isSwitched);
                                      });
                                    },
                                    inactiveTrackColor: ButtonInactive,
                                    activeTrackColor: Buttonactive,
                                    activeColor: ColorPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                  text: '\u20B950',
                                  style: TextStyle(
                                      color: ColorPrimary, fontSize: 14),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' off on orders above ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                    TextSpan(
                                      text: '\u20B9500',
                                      style: TextStyle(
                                          color: ColorPrimary, fontSize: 14),
                                    )
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.green),
                                  child: Text(
                                    "   Active   ",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                Text("Coupan Expired: 27/07/2021")
                              ],
                            ),
                          ),
                          Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: ColorPrimary,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  )
                                ],
                              )),
                        ],
                      ),
                    );
                  }),
              Positioned(
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: width,
                      color: ColorPrimary,
                      child: Center(
                        child: Text(
                          "CREATE CODES",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      height: height * 0.07,
                    ),
                  ))
            ],
          ),
        ));
  }
}
