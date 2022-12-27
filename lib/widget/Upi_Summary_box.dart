// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/utility/color.dart';

class UpiSummaryBox extends StatefulWidget {
  String gencoin, reedemamount, billingcounter;
  UpiSummaryBox(
      {Key? key,
      required this.billingcounter,
      required this.gencoin,
      required this.reedemamount})
      : super(key: key);

  @override
  State<UpiSummaryBox> createState() => _UpiSummaryBoxState();
}

class _UpiSummaryBoxState extends State<UpiSummaryBox> {
  // Widget listtileview(title, value, icon, Size screen, bool costumercheak) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
  //     child: Row(
  //       children: [
  //         CircleAvatar(
  //           radius: 22,
  //           backgroundColor: ColorPrimary,
  //           child: CircleAvatar(
  //             backgroundColor: Colors.white,
  //             // backgroundImage: AssetImage(icon),
  //             radius: 21,
  //             child: Image.asset(
  //               icon,
  //               width: 24,
  //               height: 24,
  //               fit: BoxFit.contain,
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           width: screen.width * 0.05,
  //         ),
  //         SizedBox(
  //           width: screen.width * 0.15,
  //           child: costumercheak
  //               ? Text(
  //                   double.parse(value).toStringAsFixed(0).length > 6
  //                       ? NumberFormat.compactCurrency(
  //                               decimalDigits: 2, symbol: "", locale: 'en_IN')
  //                           .format(value)
  //                       : double.parse(value).toStringAsFixed(0),
  //                   style: GoogleFonts.openSans(
  //                       color: ColorPrimary,
  //                       fontWeight: FontWeight.w900,
  //                       fontSize: 16),
  //                 )
  //               : Text(
  //                   double.parse(value).toStringAsFixed(2).length > 6
  //                       ? NumberFormat.compactCurrency(
  //                               decimalDigits: 2, symbol: "", locale: 'en_UK')
  //                           .format(value)
  //                       : double.parse(value).toStringAsFixed(2),
  //                   style: GoogleFonts.openSans(
  //                       color: ColorPrimary,
  //                       fontWeight: FontWeight.w900,
  //                       fontSize: 16),
  //                 ),
  //         ),
  //         SizedBox(
  //           width: screen.width * 0.12,
  //         ),
  //         Expanded(
  //             child: Text(
  //           title,
  //           style: GoogleFonts.openSans(
  //               color: TextBlackLight,
  //               fontWeight: FontWeight.w700,
  //               fontSize: screen.width >= 360.0 ? 14 : 13),
  //         ))
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 8,
                right: 28,
                child: Container(
                  width: 32,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Color(0xff6657f4).withOpacity(0.10),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 14,
                right: 15,
                child: Container(
                  width: 32,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Color(0xff6657f4).withOpacity(0.25),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                ),
              ),
              Image.asset(
                "assets/images/Redemptionimage.png",
                height: 110,
                width: screen.width * 0.42,
                fit: BoxFit.fill,
              ),
              Positioned(
                top: 34,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                  child: Container(
                    width: screen.width * 0.40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "total_redem_key".tr(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                              color: TextBlackLight,
                              fontWeight: FontWeight.w700,
                              fontSize: screen.width >= 360.0 ? 14 : 13),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/point.png",
                              width: 18,
                              height: 18,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              double.parse(widget.reedemamount)
                                          .toStringAsFixed(1)
                                          .length >
                                      7
                                  ? NumberFormat.compactCurrency(
                                          decimalDigits: 2,
                                          symbol: "",
                                          locale: 'en_UK')
                                      .format(double.parse(widget.reedemamount))
                                  : double.parse(widget.reedemamount)
                                      .toStringAsFixed(2),
                              style: GoogleFonts.openSans(
                                  color: ColorPrimary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 8,
              right: 28,
              child: Container(
                width: 32,
                height: 14,
                decoration: BoxDecoration(
                  color: Color(0xff6657f4).withOpacity(0.10),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 14,
              right: 15,
              child: Container(
                width: 32,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0xff6657f4).withOpacity(0.25),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
              ),
            ),
            Image.asset(
              "assets/images/generationimage.png",
              height: 110,
              width: screen.width * 0.42,
              fit: BoxFit.fill,
            ),
            Positioned(
              top: 34,
              child: Padding(
                padding: const EdgeInsets.only(left: 7, right: 10, top: 2),
                child: Container(
                  width: screen.width * 0.39,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "total_generate_key".tr(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            color: TextBlackLight,
                            fontWeight: FontWeight.w700,
                            fontSize: screen.width >= 360.0 ? 14 : 13),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        double.parse(widget.gencoin).toStringAsFixed(1).length >
                                7
                            ? NumberFormat.compactCurrency(
                                    decimalDigits: 2,
                                    symbol: "₹ ",
                                    locale: 'en_UK')
                                .format(double.parse(widget.gencoin))
                            : "₹ " +
                                double.parse(widget.gencoin).toStringAsFixed(2),
                        style: GoogleFonts.openSans(
                            color: ColorPrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            textStyle: TextStyle()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
    //  Container(
    //   width: screen.width,
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(
    //       horizontal: 20,
    //     ),
    //     child: Card(
    //         margin: EdgeInsets.only(left: 2, right: 2, bottom: 12),
    //         elevation: 3,
    //         shape: RoundedRectangleBorder(
    //             side: BorderSide(color: ColorPrimary, width: 1),
    //             borderRadius: BorderRadius.all(Radius.circular(12))),
    //         shadowColor: Colors.green[100],
    //         child: Column(
    //           children: [
    //             // ListTile(
    //             //   title: Text(
    //             //     "Summary",
    //             //     style: TextStyle(fontSize: 20),
    //             //   ),
    //             // ),
    //             // SizedBox(
    //             //   height: 20,
    //             // ),
    //             listtileview("total_redem_key".tr(), widget.reedemamount,
    //                 "assets/images/ruppee-icon.png", screen, false),
    //             listtileview("total_costumer_key".tr(), widget.billingcounter,
    //                 "assets/images/MP-new.png", screen, true),
    //             listtileview("total_generate_key".tr(), widget.gencoin,
    //                 "assets/images/point.png", screen, false),
    //           ],
    //         )),
    //   ),
    // );
  }
}
