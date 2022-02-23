import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/inventory/suggested_product/bloc/suggested_product_bloc.dart';
import 'package:vendor/ui/inventory/suggested_product/bloc/suggested_product_event.dart';
import 'package:vendor/ui/inventory/suggested_product/bloc/suggested_product_state.dart';

class SuggestedProductList extends StatefulWidget {
  final List<ProductModel> products;

  SuggestedProductList(this.products);

  @override
  _SuggestedProductListState createState() => _SuggestedProductListState();
}

class _SuggestedProductListState extends State<SuggestedProductList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 10,
          );
        },
        itemBuilder: (context, index) {
          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        image: NetworkImage(
                            "http://vendor.tekzee.in/images/product_image/01631711435.jpg"),
                        height: MediaQuery.of(context).size.width * 0.20,
                        width: MediaQuery.of(context).size.width * 0.20,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${widget.products[index].productName}\n",
                              style: TextStyle(color: Colors.black)),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        "₹${widget.products[index].sellingPrice}\t\t",
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: "${widget.products[index].mrp}",
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.black))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<SuggestedProductBloc, SuggestedProductState>(
                      builder: (context, state) {
                        if (state is CheckState) {
                          // widget.products[state.index].check = state.check;
                        }
                        return Checkbox(
                          value: widget.products[index].check,
                          onChanged: (value) {
                            BlocProvider.of<SuggestedProductBloc>(context)
                                .add(CheckEvent(index: index, check: value!));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ));
        },
        itemCount: widget.products.length,
      ),
    );
  }
}
