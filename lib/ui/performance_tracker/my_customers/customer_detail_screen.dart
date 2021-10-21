import 'package:flutter/material.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';

class CustomerDetailScreen extends StatefulWidget {
  const CustomerDetailScreen({Key? key}) : super(key: key);

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Details",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.shade200, width: 1)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        "Customer name",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                      Text(
                        "7 oct 2021 - 04:50 PM",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "+91 1231231231",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.shade200, width: 1)),
              child: Column(
                children: [
                  const Text(
                    "All items",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Column(
                    children: List.generate(
                        5,
                        (index) => Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.shade200, width: 1)),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image(
                                    image: NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDIC2m4o5Ff_s_BOIL0-y7uq8m_Kqrn0Yq1Q&usqp=CAU"),
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.contain,
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
                                                "Product Name",
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                                              ),
                                              Text(
                                                "₹ 2000",
                                                style: TextStyle(color: Colors.black, fontSize: 14),
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
                                                "5 * ₹400",
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                                              ),
                                              Row(
                                                children: [
                                                  Image(
                                                    image: AssetImage("assets/images/point.png"),
                                                    width: 15,
                                                    height: 15,
                                                  ),
                                                  Text(
                                                    "500",
                                                    style: TextStyle(color: Colors.black, fontSize: 14),
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
                            )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
