import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_customer_product_response.dart';
import 'package:vendor/model/get_my_customer_response.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;

  const CustomerDetailScreen({required this.customer, Key? key})
      : super(key: key);

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  double totalPay = 0.0;
  double redeemedCoin = 0.0;
  double earnCoin = 0.0;
  double total = 0.0;
  String s = "";

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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey.shade200, width: 1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        widget.customer.customerName,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                      Text(
                        Utility.getFormatDate1(widget.customer.date),
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "+91 ${widget.customer.mobile}",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<CustomerProduct>>(
                future: getCustomerProduct(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Colors.grey.shade200, width: 1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "all_items_key".tr(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          Column(
                            children: List.generate(
                                snapshot.data!.length,
                                (index) => Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.grey.shade100),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image(
                                                image: NetworkImage(snapshot
                                                        .data![index]
                                                        .productImages
                                                        .isNotEmpty
                                                    ? snapshot
                                                        .data![index]
                                                        .productImages
                                                        .first
                                                        .productImage
                                                    : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDIC2m4o5Ff_s_BOIL0-y7uq8m_Kqrn0Yq1Q&usqp=CAU"),
                                                height: 70,
                                                width: 70,
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
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "${snapshot.data![index].productName}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                          ),
                                                          Text(
                                                            "${snapshot.data![index].total}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "${snapshot.data![index].qty} x ${snapshot.data![index].price}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Image(
                                                                image: AssetImage(
                                                                    "assets/images/point.png"),
                                                                width: 15,
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                "${snapshot.data![index].earningCoins}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ],
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
                                        snapshot.data![index].redeemCoins
                                                    .isEmpty ||
                                                snapshot.data![index]
                                                        .redeemCoins ==
                                                    "0"
                                            ? Container()
                                            : Positioned(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: ColorPrimary
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Text(
                                                    "\t" +
                                                        "redeemed_key".tr() +
                                                        "\t",
                                                    style: TextStyle(
                                                        color: ColorPrimary),
                                                  ),
                                                ),
                                                top: 0,
                                                right: 15,
                                              )
                                      ],
                                    )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "total_amount_key".tr(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("₹ ${total.toStringAsFixed(2)}"),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "redeemed_amount_key".tr(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("₹ ${redeemedCoin.toStringAsFixed(2)}"),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "earn_coins_key".tr(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image(
                                    image:
                                        AssetImage("assets/images/point.png"),
                                    width: 15,
                                    height: 15,
                                  ),
                                  Text("${earnCoin.toStringAsFixed(2)}"),
                                ],
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
                                "pay_amount_key".tr(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("₹ ${totalPay.toStringAsFixed(2)}"),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                }),
          ],
        ),
      ),
    );
  }

  Future<List<CustomerProduct>> getCustomerProduct() async {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = {
        "customer_id": widget.customer.customerId,
        "vendor_id": await SharedPref.getIntegerPreference(SharedPref.VENDORID)
      };

      GetCustomerProductResponse response =
          await apiProvider.getCustomerProduct(input);
      if (response.success) {
        response.data!.forEach((product) {
          totalPay += double.parse(product.total);
          total += double.parse(product.price);
          redeemedCoin += double.parse(product.redeemCoins);
          earnCoin += double.parse(product.earningCoins);
        });

        return response.data!;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }
}
