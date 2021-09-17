import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_colors_response.dart';
import 'package:vendor/model/product_variant.dart';
import 'package:vendor/model/product_variant_response.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/color_bottom_sheet.dart';

class ProductVariantScreen extends StatefulWidget {
  final List<VariantType> variantType;
  final String categoryId;
  final List<ProductVariantModel> productVariant;
  final bool edit;
  final bool add;

  ProductVariantScreen(
      {required this.variantType, required this.categoryId, required this.productVariant, required this.edit, required this.add});

  @override
  _ProductVariantScreenState createState() => _ProductVariantScreenState();
}

class _ProductVariantScreenState extends State<ProductVariantScreen> {
  List<ProductVariantModel> productVariant = [];
  TextEditingController edtOption = TextEditingController();
  StreamController<List<ProductVariantModel>> controller = StreamController();

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    addVariant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Variant",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: StreamBuilder<List<ProductVariantModel>>(
          stream: controller.stream,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: List.generate(snapshot.data!.length, (index) {
                  return ProductVariantWidget(snapshot.data![index]);
                }),
              );
            }
            return Container();
          },
        ),
      ),
      bottomNavigationBar: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (!widget.add && !widget.edit)
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: MaterialButton(
                      onPressed: () {
                        addVariant();
                        // ProductVariantModel productVariantModel =
                        //     ProductVariantModel(mrp: "0", purchasePrice: "", sellingPrice: "", stock: 0);
                        // productVariantModel.option = [];
                        // widget.variantType.forEach((variantType) {
                        //   VariantOption variant = VariantOption();
                        //   variant.name = variantType.variantName.trim();
                        //   variant.value = "";
                        //   productVariantModel.option.add(variant);
                        // });
                        // productVariant.add(productVariantModel);
                        // Navigator.pop(context, variants);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), side: BorderSide(color: ColorPrimary, width: 1)),
                      height: 50,
                      minWidth: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: ColorPrimary,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Add New Variant",
                            style: TextStyle(color: ColorPrimary),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    width: 0,
                    height: 0,
                  ),
            MaterialButton(
              onPressed: () {
                print(productVariant);
                productVariant.forEach((element) {
                  print(element.toString());
                });

                if (productVariant.isNotEmpty) {
                  for (int j = 0; j < productVariant.length; j++) {
                    if (productVariant[j].option.isNotEmpty) {
                      for (int i = 0; i < productVariant[j].option.length; i++) {
                        if (productVariant[j].option[i].value.isEmpty) {
                          Utility.showToast("Please enter ${productVariant[j].option[i].name}");
                          return;
                        }
                      }
                    }
                    if (productVariant[j].mrp.isEmpty) {
                      Utility.showToast("Please enter mrp");
                      return;
                    }
                    if (productVariant[j].sellingPrice.isEmpty) {
                      Utility.showToast("Please enter selling price");
                      return;
                    }
                    if (productVariant[j].stock.isEmpty) {
                      Utility.showToast("Please enter stock");
                      return;
                    }
                  }
                }

                Navigator.pop(context, productVariant);
              },
              height: 50,
              minWidth: MediaQuery.of(context).size.width,
              shape: RoundedRectangleBorder(),
              color: ColorPrimary,
              child: Text("DONE"),
            ),
          ],
        ),
      ),
    );
  }

  void addVariant() async {
    if (!widget.add && widget.edit) {
      productVariant.addAll(widget.productVariant);
      controller.add(productVariant);
    } /* else if(!widget.add && !widget.edit){
      ProductVariantModel productVariantModel = ProductVariantModel(mrp: "0", purchasePrice: "", sellingPrice: "", stock: 0);
      productVariantModel.option = [];
      widget.variantType.forEach((variantType) {
        VariantOption variant = VariantOption();
        variant.name = variantType.variantName.trim();
        variant.value = "";
        productVariantModel.option.add(variant);
      });
      productVariant.add(productVariantModel);
    }*/
    else {
      ProductVariantModel productVariantModel = ProductVariantModel(mrp: "0", purchasePrice: "", sellingPrice: "", stock: "");
      productVariantModel.option = [];
      widget.variantType.forEach((variantType) {
        VariantOption variant = VariantOption();
        variant.name = variantType.variantName.trim();
        variant.value = "";
        productVariantModel.option.add(variant);
      });
      productVariant.add(productVariantModel);
      controller.add(productVariant);
    }
  }
}

class ProductVariantWidget extends StatefulWidget {
  final ProductVariantModel variant;

  ProductVariantWidget(this.variant);

  @override
  _ProductVariantWidgetState createState() => _ProductVariantWidgetState();
}

class _ProductVariantWidgetState extends State<ProductVariantWidget> {
  StreamController<List<File>> imgController = StreamController();
  ProductVariantModel variantModel = ProductVariantModel();

  // Map variant = HashMap<String,dynamic>();

  @override
  void initState() {
    variantModel = widget.variant;
    // variant.addAll(widget.variant.option);
    // this.variant = widget.variant;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(1)),
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          Text("Add Image"),
          Container(
            height: 100,
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(5)),
                  child: IconButton(
                    onPressed: () {
                      selectImage(context, widget.variant.productImages);
                    },
                    icon: Icon(Icons.linked_camera),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 140,
                    child: StreamBuilder<List<File>>(
                      stream: imgController.stream,
                      initialData: [],
                      builder: (context, snap) {
                        if (snap.hasData && snap.data!.isNotEmpty) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snap.data!.length,
                            itemBuilder: (context, index) {
                              return Stack(children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                        image: FileImage(
                                          snap.data![index],
                                        ),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: InkWell(
                                    child: Container(
                                        width: 25,
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: ColorPrimary),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 15,
                                        )),
                                    onTap: () {
                                      widget.variant.productImages.removeAt(index);
                                      imgController.add(widget.variant.productImages);
                                    },
                                  ),
                                )
                              ]);
                            },
                          );
                        }

                        return Container();
                      },
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          // Text("Add Variant"),
          // TextFormField(
          //   decoration: InputDecoration(labelText: "Size"),
          // ),
          // SizedBox(
          //   height: 10,
          // ),

          Column(
            children: List.generate(variantModel.option.length, (index) {
              return VariantOptionWidget(variantModel.option[index]);
            }),
          ),

          Row(
            children: [
              // Expanded(
              //   child: TextFormField(
              //     decoration: InputDecoration(labelText: "Purchase price"),
              //   ),
              //   flex: 3,
              // ),
              // SizedBox(
              //   width: 15,
              // ),
              Expanded(
                child: TextFormField(
                  initialValue: variantModel.mrp.toString(),
                  decoration: InputDecoration(labelText: "MRP"),
                  onChanged: (text) {
                    variantModel.mrp = text.trim();
                  },
                ),
                flex: 2,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: variantModel.sellingPrice.toString(),
                  decoration: InputDecoration(labelText: "Selling price"),
                  onChanged: (text) {
                    variantModel.sellingPrice = text.trim();
                  },
                ),
                flex: 2,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            initialValue: variantModel.stock.toString(),
            decoration: InputDecoration(labelText: "Stock"),
            onChanged: (text) {
              variantModel.stock = text.trim();
            },
          ),
        ],
      ),
    );
  }

  selectImage(BuildContext context, List<File> productImages) async {
    try {
      XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        print(image.path);
        List<File> images = productImages;
        images.add(File(image.path));
        imgController.add(images);
      }
    } catch (exception) {
      debugPrint("exception-->$exception");
    }
  }

  @override
  void dispose() {
    super.dispose();
    imgController.close();
  }
}

class VariantOptionWidget extends StatefulWidget {
  final VariantOption option;

  VariantOptionWidget(this.option);

  @override
  _VariantOptionWidgetState createState() => _VariantOptionWidgetState();
}

class _VariantOptionWidgetState extends State<VariantOptionWidget> {
  TextEditingController editText = TextEditingController();
  ColorModel? colorModel;

  @override
  void initState() {
    editText.text = widget.option.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.option.name.toLowerCase() == "color"
            ? TextFormField(
                controller: editText,
                readOnly: true,
                // initialValue: widget.option.value,
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SelectColorBottomSheet(onSelect: (color) {
                          editText.text = color.colorName;
                          colorModel = color;
                          widget.option.value = color.colorName;
                          setState(() {});
                        });
                      });
                },
                decoration: InputDecoration(
                    hintText: "Select ${widget.option.name}",
                    labelText: "${widget.option.name}",
                    suffixIcon: Icon(Icons.keyboard_arrow_right),
                    suffixIconConstraints: BoxConstraints(maxHeight: 20, maxWidth: 20)
                    /*suffix: Container(
                      width: 20,
                      height: 20,
                      color: colorModel != null ? Color(int.parse(colorModel!.colorCode.replaceAll("#", "0xff"))) : Colors.transparent,
                    )*/
                    ),
              )
            : TextFormField(
                initialValue: widget.option.value,
                decoration: InputDecoration(hintText: "Enter ${widget.option.name}", labelText: "${widget.option.name}"),
                onChanged: (text) {
                  widget.option.value = text;
                },
              ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
