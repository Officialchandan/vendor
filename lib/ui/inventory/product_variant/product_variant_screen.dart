import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_colors_response.dart';
import 'package:vendor/model/product_variant.dart';
import 'package:vendor/model/product_variant_response.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/color_bottom_sheet.dart';
import 'package:vendor/widget/select_image_bottom_sheet.dart';

class ProductVariantScreen extends StatefulWidget {
  final List<VariantType> variantType;
  final String categoryId;
  final List<ProductVariantModel> productVariant;
  final bool edit;
  final bool add;

  ProductVariantScreen(
      {required this.variantType,
      required this.categoryId,
      required this.productVariant,
      required this.edit,
      required this.add});

  @override
  _ProductVariantScreenState createState() => _ProductVariantScreenState();
}

class _ProductVariantScreenState extends State<ProductVariantScreen> {
  List<ProductVariantModel> productVariant = [];
  TextEditingController edtOption = TextEditingController();
  StreamController<List<ProductVariantModel>> controller = StreamController();

  ScrollController _scrollController = ScrollController();

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
        title: widget.edit != true ? "add_variant_key".tr() : "edit_variant_key".tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: StreamBuilder<List<ProductVariantModel>>(
          stream: controller.stream,
          initialData: [],
          builder: (context, snapshot) {
            if(productVariant.isEmpty){
              return Center(child: Text("Click button to add new variant"),);
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ProductVariantWidget(
                      snapshot.data![index],
                      onDelete: () {
                        productVariant.removeAt(index);
                        controller.add(productVariant);
                      },
                    );
                  });
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
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent + 400,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 500),
                        );
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
                            "add_new_variant_key".tr(),
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
            Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: MaterialButton(
                onPressed: () {
                  if (productVariant.isNotEmpty) {
                    for (int j = 0; j < productVariant.length; j++) {
                      if (productVariant[j].option.isNotEmpty) {
                        for (int i = 0; i < productVariant[j].option.length; i++) {
                          if (productVariant[j].option[i].value.isEmpty) {
                            Utility.showToast(
                                msg: "please_enter_key".tr() + " ${productVariant[j].option[i].name}".tr());
                            return;
                          }
                        }
                      }
                      if (productVariant[j].mrp.isEmpty) {
                        Utility.showToast(msg: "please_enter_mrp_key".tr());
                        return;
                      }
                      if (productVariant[j].mrp == "0") {
                        Utility.showToast(msg: "please_enter_valid_mrp_key".tr());
                        return;
                      }
                      if (productVariant[j].sellingPrice.isEmpty) {
                        Utility.showToast(msg: "please_enter_selling_price_key".tr());
                        return;
                      }
                      if (productVariant[j].sellingPrice == "0") {
                        Utility.showToast(msg: "please_enter_valid_selling_price_key".tr());
                        return;
                      }
                      if (double.parse(productVariant[j].sellingPrice.trim()) >
                          double.parse(productVariant[j].mrp.trim())) {
                        Utility.showToast(msg: "selling_price_cannot_be_more_than_mrp_key".tr());
                        return;
                      }

                      if (productVariant[j].stock.isEmpty) {
                        Utility.showToast(msg: "please_enter_stock_key".tr());
                        return;
                      }
                      if (int.parse(productVariant[j].stock) <= 0) {
                        Utility.showToast(msg: "stock_can_not_be_zero_key".tr());
                        return;
                      }
                    }
                  }
                  Navigator.pop(context, productVariant);
                  FocusScope.of(context).unfocus();
                },
                height: 50,
                minWidth: MediaQuery.of(context).size.width,
                shape: RoundedRectangleBorder(),
                color: ColorPrimary,
                child: Text(
                  "done_key".tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
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
    }
    /* else if(!widget.add && !widget.edit){
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
      ProductVariantModel productVariantModel =
          ProductVariantModel(mrp: "", purchasePrice: "", sellingPrice: "", stock: "");
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
  final Function onDelete;

  ProductVariantWidget(this.variant, {required this.onDelete});

  @override
  _ProductVariantWidgetState createState() => _ProductVariantWidgetState();
}

class _ProductVariantWidgetState extends State<ProductVariantWidget> {
  StreamController<List<File>> imgController = StreamController();
  ProductVariantModel variantModel = ProductVariantModel();

  List<File> imageList = [];

  // Map variant = HashMap<String,dynamic>();

  @override
  void initState() {
    variantModel = widget.variant;
    imageList.addAll(widget.variant.productImages);
    imgController.add(imageList);
    // variant.addAll(widget.variant.option);
    // this.variant = widget.variant;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "add_product_key".tr(),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              // Container(
              //   height: 100,
              //   child: Row(
              //     children: [
              //       Container(
              //         width: 80,
              //         height: 80,
              //         decoration: BoxDecoration(
              //             color: Colors.grey.shade100,
              //             borderRadius: BorderRadius.circular(5)),
              //         child: IconButton(
              //           onPressed: () {
              //             selectImage(context, widget.variant.productImages);
              //           },
              //           icon: Icon(
              //             Icons.linked_camera,
              //             size: 40,
              //           ),
              //         ),
              //       ),
              //       Container(
              //           width: MediaQuery.of(context).size.width - 140,
              //           child: StreamBuilder<List<File>>(
              //             stream: imgController.stream,
              //             initialData: imageList,
              //             builder: (context, snap) {
              //               if (snap.hasData && snap.data!.isNotEmpty) {
              //                 return ListView.builder(
              //                   scrollDirection: Axis.horizontal,
              //                   itemCount: snap.data!.length,
              //                   itemBuilder: (context, index) {
              //                     return Stack(children: [
              //                       Container(
              //                         width: 80,
              //                         height: 80,
              //                         margin: EdgeInsets.symmetric(
              //                             vertical: 10, horizontal: 10),
              //                         decoration: BoxDecoration(
              //                             borderRadius:
              //                                 BorderRadius.circular(5),
              //                             image: DecorationImage(
              //                               image: FileImage(
              //                                 snap.data![index],
              //                               ),
              //                               fit: BoxFit.cover,
              //                             )),
              //                       ),
              //                       Positioned(
              //                         right: 0,
              //                         top: 0,
              //                         child: InkWell(
              //                           child: Container(
              //                               width: 25,
              //                               padding: EdgeInsets.all(3),
              //                               decoration: BoxDecoration(
              //                                   shape: BoxShape.circle,
              //                                   color: ColorPrimary),
              //                               child: Icon(
              //                                 Icons.delete,
              //                                 color: Colors.white,
              //                                 size: 15,
              //                               )),
              //                           onTap: () {
              //                             imageList.removeAt(index);
              //                             imgController.add(imageList);
              //                           },
              //                         ),
              //                       )
              //                     ]);
              //                   },
              //                 );
              //               }
              //
              //               return Container();
              //             },
              //           )),
              //     ],
              //   ),
              // ),
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
                      keyboardType: priceKeyboardType,
                      maxLength: PRICE_TEXT_LENGTH,
                      inputFormatters: priceInputFormatter,
                      decoration: InputDecoration(labelText: "mrp_key".tr() + "*", counter: Container()),
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
                      keyboardType: priceKeyboardType,
                      maxLength: PRICE_TEXT_LENGTH,
                      inputFormatters: priceInputFormatter,
                      decoration: InputDecoration(labelText: "selling_price_key".tr() + "*", counter: Container()),
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
                keyboardType: priceKeyboardType,
                maxLength: PRICE_TEXT_LENGTH,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                initialValue: variantModel.stock.toString(),
                decoration: InputDecoration(labelText: "stock_key".tr() + "*", counter: Container()),
                onChanged: (text) {
                  variantModel.stock = text.trim();
                },
              ),
            ],
          ),
        ),
        Positioned(
          right: 15,
          top: -12,
          child: ElevatedButton(
            onPressed: () {
              widget.onDelete();
            },
            child: Text(
              "delete_key".tr(),
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(60, 22)),
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
          ),
        )
      ],
    );
  }

  selectImage(BuildContext context, List<File> productImages) async {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => SelectImageBottomSheet(
              openGallery: () {
                pickImage(context, ImageSource.gallery, productImages);
              },
              openCamera: () {
                pickImage(context, ImageSource.camera, productImages);
              },
            ));
  }

  pickImage(BuildContext context, ImageSource source, List<File> productImages) async {
    try {
      List<XFile> imgList = [];
      if (source == ImageSource.gallery) {
        List<XFile>? images = await imagePicker.pickMultiImage();
        if (images != null) {
          imgList = images;
        }
      } else {
        XFile? image = await imagePicker.pickImage(source: source);
        if (image != null) {
          imgList = [image];
        }
      }
      if (imgList.isNotEmpty) {
        // files.addAll(productImages);
        imgList.forEach((element) {
          imageList.add(File(element.path));
          print(element.path);
        });

        imgController.add(imageList);
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )),
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
                    hintText: "select_key".tr() + " ${widget.option.name}",
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
                maxLength: 30,
                decoration: InputDecoration(
                    counter: SizedBox.shrink(),
                    hintText: "please_enter_key".tr() + " ${widget.option.name}".tr(),
                    labelText: "${widget.option.name}".tr()),
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
