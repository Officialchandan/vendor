import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/chat_papdi_module/get_customer_of_chatpapdi.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/progress_indecator.dart';
import '../../../model/get_customer_product_response.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;

  const CustomerDetailScreen({required this.customer, Key? key}) : super(key: key);

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  double totalPay = 0.0;
  double redeemedCoin = 0.0;
  double earnCoin = 0.0;
  double total = 0.0;
  String s = "";
  List<CommnModel> commnModel = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "details_key".tr(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                      widget.customer.customerName,
                      style: GoogleFonts.openSans(color: TextBlackLight, fontWeight: FontWeight.bold, fontSize: 18),
                    )),
                    Text(Utility.getFormatDate1(widget.customer.date),
                        style: GoogleFonts.openSans(
                          color: TextGrey,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "+91 ${widget.customer.mobile}",
                  style: GoogleFonts.openSans(
                    color: TextGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            FutureBuilder<List<CommnModel>>(
                future: getCustomerProduct(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularLoader();
                  }
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "order_summary_key".tr(),
                          style: GoogleFonts.openSans(color: TextBlackLight, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Column(
                          children: List.generate(
                              commnModel.length,
                              (index) => Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        margin: EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5), color: Colors.grey.shade100),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image(
                                              image: NetworkImage(snapshot.data![index].categoryImage.isNotEmpty
                                                  ? snapshot.data![index].categoryImage
                                                  : "assets/images/placeholder.webp"),
                                              height: 45,
                                              width: 45,
                                              fit: BoxFit.contain,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${snapshot.data![index].categoryName}",
                                                          style: GoogleFonts.openSans(
                                                              color: TextBlackLight,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16),
                                                        ),
                                                        Text(
                                                          "₹ ${snapshot.data![index].total}",
                                                          style: GoogleFonts.openSans(
                                                              color: TextBlackLight,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          "",
                                                          style: GoogleFonts.openSans(
                                                              color: TextGrey,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 13),
                                                        ),
                                                        Text(
                                                          "commission_key".tr() +
                                                              ": ${snapshot.data![index].commissionValue}",
                                                          style: GoogleFonts.openSans(
                                                              color: TextGrey,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 13),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // snapshot.data![index].redeemCoins.isEmpty ||
                                      //         double.parse(snapshot.data![index].redeemCoins) == 0
                                      //     ? Container()
                                      //     : Positioned(
                                      //         child: Container(
                                      //           decoration: BoxDecoration(
                                      //             color: ColorPrimary.withOpacity(0.2),
                                      //             borderRadius: BorderRadius.circular(10),
                                      //           ),
                                      //           child: Text(
                                      //             "\t" + "redeemed_key".tr() + "\t",
                                      //             style: GoogleFonts.openSans(color: ColorPrimary),
                                      //           ),
                                      //         ),
                                      //         top: 0,
                                      //         right: 15,
                                      //       )
                                    ],
                                  )),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          "billing_key".tr(),
                          style: GoogleFonts.openSans(color: TextBlackLight, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "totals_order_value_key".tr(),
                              style: GoogleFonts.openSans(color: TextGrey, fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            Text(
                              "₹ ${total.toStringAsFixed(2)}",
                              style: GoogleFonts.openSans(
                                  color: TextBlackLight, fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "customer_amt_paid_key".tr(),
                              style: GoogleFonts.openSans(color: TextGrey, fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            Text(
                              "₹ ${totalPay.toStringAsFixed(2)}",
                              style: GoogleFonts.openSans(
                                  color: TextBlackLight, fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "customer_redemption_key".tr(),
                              style: GoogleFonts.openSans(color: TextGrey, fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            Text(
                              "₹ ${redeemedCoin.toStringAsFixed(2)}",
                              style: GoogleFonts.openSans(
                                  color: TextBlackLight, fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 1,
                          color: TextGrey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "earn_coins_key".tr(),
                              style: GoogleFonts.openSans(
                                  color: TextBlackLight, fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "(",
                                  style: GoogleFonts.openSans(
                                      color: ColorPrimary, fontWeight: FontWeight.w600, fontSize: 20),
                                ),
                                Image(
                                  image: AssetImage("assets/images/point.png"),
                                  width: 15,
                                  height: 15,
                                ),
                                Text(
                                  "${earnCoin.toStringAsFixed(2)})",
                                  style: GoogleFonts.openSans(
                                      color: ColorPrimary, fontWeight: FontWeight.w600, fontSize: 20),
                                ),
                                Text(
                                  " ₹ ${(earnCoin / 3).toStringAsFixed(2)}",
                                  style: GoogleFonts.openSans(
                                      color: ColorPrimary, fontWeight: FontWeight.w600, fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    );
                  }
                  return Container();
                }),
          ],
        ),
      ),
    );
  }

  Future<List<CommnModel>> getCustomerProduct() async {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = {
        "customer_id": "${widget.customer.customerId}",
        "vendor_id": await SharedPref.getIntegerPreference(SharedPref.VENDORID)
      };

      GetCustomerProductResponse response = await apiProvider.getCustomerProduct(input);
      if (response.success) {
        // await Future.forEach(response.data!, (CommnModel common) async {
        //   common.orderType = 0;
        //   commnModel.add(common);
        // });
        await Future.forEach(response.directBilling!, (CommnModel common) {
          common.orderType = 1;
          commnModel.add(common);
        });
        // commnModel.sort((a, b) => b.date.compareTo(a.date));
        ;
        commnModel.forEach((product) {
          totalPay += double.parse(product.amountPaid);
          total += double.parse(product.total);
          redeemedCoin += double.parse(product.redeemCoins);
          earnCoin += double.parse(product.earningCoins);
        });

        return commnModel;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }
}
