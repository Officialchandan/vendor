import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/inventory/view_product/search_product.dart';
import 'package:vendor/widget/app_button.dart';
import 'package:vendor/widget/show_catagories_widget.dart';

class SaleReturnScreen extends StatefulWidget {
  @override
  _SaleReturnScreenState createState() => _SaleReturnScreenState();
}

class _SaleReturnScreenState extends State<SaleReturnScreen> {
  TextEditingController edtMobile = TextEditingController();
  TextEditingController edtProducts = TextEditingController();
  TextEditingController edtReason = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Sale Return",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: edtMobile,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 10,
              onChanged: (text) {},
              autofocus: true,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(counterText: "", labelText: "Mobile Number"),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: edtProducts,
              readOnly: true,
              onTap: () {
                selectProduct(context);
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 10,
              onChanged: (text) {},
              autofocus: true,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  hintText: "Choose Product",
                  suffixIcon: Icon(Icons.keyboard_arrow_right_sharp),
                  suffixIconConstraints: BoxConstraints(maxWidth: 15, minWidth: 10, maxHeight: 15, minHeight: 10)),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: edtReason,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 10,
              onChanged: (text) {},
              autofocus: true,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                counterText: "",
                labelText: "Reason (Optional)",
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            AppButton(
              title: "SUBMIT",
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  void selectProduct(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          return IntrinsicHeight(
              child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                    height: 300,
                    child: ListView(
                      children: [
                        SelectCategoryWidget(
                          onSelect: (String? categoryId) {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: SearchProductScreen(
                                      categoryId: categoryId,
                                    ),
                                    type: PageTransitionType.fade));
                          },
                        ),
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(),
                        )),
                  ],
                )
              ],
            ),
          ));
        });
  }
}
