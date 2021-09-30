import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/inventory/purchase_return/select_product_to_retrun.dart';
import 'package:vendor/widget/show_catagories_widget.dart';

class PurchaseReturnScreen extends StatefulWidget {
  @override
  _PurchaseReturnScreenState createState() => _PurchaseReturnScreenState();
}

class _PurchaseReturnScreenState extends State<PurchaseReturnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Purchase Return",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextFormField(
              readOnly: true,
              onTap: () async {
                selectCategory(context);
              },
              onChanged: (text) {},
              autofocus: false,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  hintText: "Choose Product",
                  suffixIcon: Icon(Icons.keyboard_arrow_right_sharp),
                  suffixIconConstraints: BoxConstraints(maxWidth: 15, minWidth: 10, maxHeight: 15, minHeight: 10)),
            ),
          ],
        ),
      ),
    );
  }

  void selectCategory(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          return IntrinsicHeight(
              child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(15),
                    height: 300,
                    child: ListView(
                      children: [
                        SelectCategoryWidget(
                          onSelect: (String? categoryId) {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: SelectProductToReturn(
                                      categoryId: categoryId,
                                    ),
                                    type: PageTransitionType.fade));
                          },
                        ),
                      ],
                    )),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Close",
                            style: TextStyle(),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ));
        });
  }
}
