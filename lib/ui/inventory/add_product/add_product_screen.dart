import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/model/get_sub_category_response.dart';
import 'package:vendor/model/product_variant.dart';
import 'package:vendor/model/product_variant_response.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/inventory/add_product/bloc/add_product_bloc.dart';
import 'package:vendor/ui/inventory/add_product/bloc/add_product_event.dart';
import 'package:vendor/ui/inventory/add_product/bloc/add_product_state.dart';
import 'package:vendor/ui/inventory/product_variant/product_variant_screen.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/string.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/category_bottom_sheet.dart';
import 'package:vendor/widget/selection_bottom_sheet.dart';
import 'package:vendor/widget/variant_type_bottom_sheet.dart';

class AddProductScreen extends StatefulWidget {
  final int? status;
  AddProductScreen({this.status});
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  List<File> imageList = [];
  AddProductBloc addProductBloc = AddProductBloc();
  StreamController<List<File>> imgController = StreamController();
  bool showOnline = true;
  TextEditingController edtProductName = TextEditingController();
  TextEditingController edtCategory = TextEditingController();
  TextEditingController edtSubCategoryCategory = TextEditingController();
  TextEditingController edtUnit = TextEditingController();
  TextEditingController edtOptions = TextEditingController();
  TextEditingController edtPurchasePrice = TextEditingController();
  TextEditingController edtMrp = TextEditingController();
  TextEditingController edtSellingPrice = TextEditingController();
  TextEditingController edtStock = TextEditingController();
  String categoryId = "";
  String unitId = "";
  List<SubCategoryModel> subCategories = [];
  List<ProductVariantModel> productVariant = [];
  List<VariantType> variantType = [];
  ProductVariantModel variantModel = ProductVariantModel();
  List<VariantImage> variantImage = [];
  String productId = "";

  @override
  void dispose() {
    super.dispose();
    imgController.close();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddProductBloc>(
      create: (context) => addProductBloc,
      child: BlocListener<AddProductBloc, AddProductState>(
        listener: (context, state) {
          if (state is SelectImageState) {
            imageList.addAll(state.image);
            variantModel.productImages = imageList;
            imgController.add(imageList);
          }
          if (state is AddProductFailureState) {
            variantImage.clear();
          }
          if (state is UploadImageFailureState) {
            variantImage.removeAt(0);

            if (variantImage.isNotEmpty) {
              addProductBloc.add(UploadImageEvent(
                  variantId: variantImage.first.variantId!, images: variantImage.first.images!, productId: productId));
            } else {
              Utility.showToast(tr(MString.product_added_successfully));
              EasyLoading.dismiss();
              variantImage = [];
              variantModel = ProductVariantModel();
              variantType = [];
              productId = "";
              imageList = [];
              productVariant = [];
              categoryId = "";
              unitId = "";
              edtProductName.clear();
              edtCategory.clear();
              edtSubCategoryCategory.clear();
              edtUnit.clear();
              edtOptions.clear();
              edtPurchasePrice.clear();
              edtMrp.clear();
              edtSellingPrice.clear();
              edtStock.clear();
              imgController.add(imageList);
              Navigator.pop(context);
            }
          }
          if (state is UploadImageSuccessState) {
            variantImage.removeAt(0);

            if (variantImage.isNotEmpty) {
              addProductBloc.add(UploadImageEvent(
                  variantId: variantImage.first.variantId!, images: variantImage.first.images!, productId: productId));
            } else {
              Utility.showToast(tr(MString.product_added_successfully));
              EasyLoading.dismiss();
              variantImage = [];
              variantModel = ProductVariantModel();
              variantType = [];
              productId = "";
              imageList = [];
              productVariant = [];
              categoryId = "";
              unitId = "";
              edtProductName.clear();
              edtCategory.clear();
              edtSubCategoryCategory.clear();
              edtUnit.clear();
              edtOptions.clear();
              edtPurchasePrice.clear();
              edtMrp.clear();
              edtSellingPrice.clear();
              edtStock.clear();
              imgController.add(imageList);
              Navigator.pop(context);
            }
          }

          if (state is AddProductSuccessState) {
            productId = state.responseData.productId;
            for (int i = 0; i < state.responseData.variantId.length; i++) {
              variantImage[i].variantId = state.responseData.variantId[i];
            }

            addProductBloc.add(UploadImageEvent(
                variantId: variantImage.first.variantId!, images: variantImage.first.images!, productId: productId));
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(title: "add_product_key".tr()),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "add_products_image_key".tr(),
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                // ),
                //
                // SizedBox(
                //   height: 10,
                // ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
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
                //             showCupertinoModalPopup(
                //                 context: context,
                //                 builder: (context) => SelectImageBottomSheet(
                //                       openGallery: () {
                //                         addProductBloc.add(SelectImageEvent(
                //                             context: context,
                //                             source: ImageSource.gallery));
                //                       },
                //                       openCamera: () {
                //                         addProductBloc.add(SelectImageEvent(
                //                             context: context,
                //                             source: ImageSource.camera));
                //                       },
                //                     ));
                //           },
                //           icon: Icon(Icons.linked_camera, size: 40),
                //         ),
                //       ),
                //       SizedBox(
                //         width: 10,
                //       ),
                //       StreamBuilder<List<File>>(
                //         stream: imgController.stream,
                //         initialData: [],
                //         builder: (context, snap) {
                //           if (snap.hasData && snap.data!.isNotEmpty) {
                //             return Row(
                //               children:
                //                   List.generate(snap.data!.length, (index) {
                //                 return Stack(children: [
                //                   Container(
                //                     width: 80,
                //                     height: 80,
                //                     margin: EdgeInsets.symmetric(
                //                         vertical: 10, horizontal: 10),
                //                     // decoration: BoxDecoration(
                //                     //     borderRadius: BorderRadius.circular(5),
                //                     //     image: DecorationImage(
                //                     //       image: FileImage(
                //                     //         snap.data![index],
                //                     //       ),
                //                     //       fit: BoxFit.cover,
                //                     //     )),
                //
                //                     child: ClipRRect(
                //                       borderRadius: BorderRadius.circular(5),
                //                       child: Image(
                //                         image: FileImage(
                //                           snap.data![index],
                //                         ),
                //                         loadingBuilder: (BuildContext context,
                //                             Widget child,
                //                             ImageChunkEvent? loadingProgress) {
                //                           if (loadingProgress == null) {
                //                             return child;
                //                           }
                //                           return Center(
                //                             child: CircularProgressIndicator(
                //                                 // value: loadingProgress.expectedTotalBytes != null
                //                                 //     ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                //                                 //     : null,
                //                                 ),
                //                           );
                //                         },
                //                         fit: BoxFit.cover,
                //                       ),
                //                     ),
                //                   ),
                //                   Positioned(
                //                     right: 0,
                //                     top: 0,
                //                     child: InkWell(
                //                       child: Container(
                //                           width: 25,
                //                           padding: EdgeInsets.all(3),
                //                           decoration: BoxDecoration(
                //                               shape: BoxShape.circle,
                //                               color: Colors.red),
                //                           child: Icon(
                //                             Icons.delete,
                //                             color: Colors.white,
                //                             size: 15,
                //                           )),
                //                       onTap: () {
                //                         debugPrint("index $index");
                //
                //                         imageList.removeAt(index);
                //
                //                         debugPrint("imageList $imageList");
                //                         imgController.add(imageList);
                //                         variantModel.productImages = imageList;
                //                       },
                //                     ),
                //                   )
                //                 ]);
                //               }),
                //             );
                //           }
                //
                //           return Container();
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                // BlocBuilder<AddProductBloc, AddProductState>(
                //   builder: (context, state) {
                //     if (state is ShowOnlineShopState) {
                //       showOnline = state.online;
                //     }
                //
                //     return SwitchListTile(
                //       value: showOnline,
                //       onChanged: (value) {
                //         addProductBloc.add(ShowOnlineShopEvent(online: value));
                //       },
                //       title: Text("Show Online"),
                //       contentPadding: EdgeInsets.all(0),
                //     );
                //   },
                // ),

                const SizedBox(
                  height: 15,
                ),
                Text(
                  "add_product_key".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),

                TextFormField(
                  maxLength: 40,
                  controller: edtProductName,
                  decoration: InputDecoration(
                    counter: SizedBox.shrink(),
                    labelText: "product_name_key".tr() + " *",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  readOnly: true,
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        )),
                        isDismissible: false,
                        builder: (context) {
                          return CategoryBottomSheet(onSelect: (category) {
                            categoryId = category.id;
                            edtCategory.text = category.categoryName!;
                          });
                        }).then((value) {});
                  },
                  controller: edtCategory,
                  decoration: InputDecoration(
                      labelText: "category_key".tr() + "*",
                      hintText: "select_category_key".tr(),
                      suffixIcon: Icon(Icons.keyboard_arrow_right_sharp),
                      suffixIconConstraints: BoxConstraints(minWidth: 20, maxWidth: 21, minHeight: 20, maxHeight: 21)),
                ),
                const SizedBox(
                  height: 15,
                ),
                // TextFormField(
                //   readOnly: true,
                //   controller: edtSubCategoryCategory,
                //   maxLines: 3,
                //   minLines: 1,
                //   onTap: () async {
                //     if (categoryId.isEmpty) {
                //       Utility.showToast("Please select category first.");
                //       return;
                //     }
                //
                //     var result = await Navigator.push(
                //         context,
                //         PageTransition(
                //             child: SelectSubCategory(
                //               categoryId: categoryId,
                //             ),
                //             type: PageTransitionType.fade));
                //
                //     print("add_product_screen result --> $result");
                //
                //     if (result != null) {
                //       subCategories = result as List<SubCategoryModel>;
                //       String subCategory = "";
                //       subCategories.forEach((element) {
                //         subCategory = subCategory + element.subCatName + ", ";
                //       });
                //       edtSubCategoryCategory.text = subCategory;
                //     }
                //   },
                //   decoration: InputDecoration(
                //       hintText: "Select subcategory",
                //       labelText: "Subcategory",
                //       suffixIcon: Icon(Icons.keyboard_arrow_right_sharp),
                //       suffixIconConstraints: BoxConstraints(minWidth: 20, maxWidth: 21, minHeight: 20, maxHeight: 21)),
                // ),
                // const SizedBox(
                //   height: 15,
                // ),
                BlocBuilder<AddProductBloc, AddProductState>(builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: edtPurchasePrice,
                          decoration: InputDecoration(
                            labelText: "purchase_price_key".tr(),
                            counter: Container(),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          autofocus: false,
                          keyboardType: priceKeyboardType,
                          maxLength: PRICE_TEXT_LENGTH,
                          inputFormatters: priceInputFormatter,
                          onChanged: (text) {
                            variantModel.purchasePrice = text;
                          },
                        ),
                        flex: 3,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: edtMrp,
                          keyboardType: priceKeyboardType,
                          maxLength: PRICE_TEXT_LENGTH,
                          inputFormatters: priceInputFormatter,
                          decoration: InputDecoration(labelText: "mrp_key".tr() + "*", counter: Container()),
                          onChanged: (text) {
                            variantModel.mrp = text;
                          },
                        ),
                        flex: 2,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: edtSellingPrice,
                          keyboardType: priceKeyboardType,
                          maxLength: PRICE_TEXT_LENGTH,
                          inputFormatters: priceInputFormatter,
                          decoration: InputDecoration(labelText: "selling_price_key".tr() + "*", counter: Container()),
                          onChanged: (text) {
                            variantModel.sellingPrice = text;
                          },
                        ),
                        flex: 3,
                      ),
                    ],
                  );
                }),
                const SizedBox(
                  height: 15,
                ),
                BlocBuilder<AddProductBloc, AddProductState>(builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: edtStock,
                          keyboardType: TextInputType.phone,
                          maxLength: 8,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(labelText: "stock_key".tr() + "*", counter: SizedBox.shrink()),
                          onChanged: (text) {
                            variantModel.stock = text;
                          },
                        ),
                        flex: 2,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      // Expanded(
                      //   child: TextFormField(
                      //     readOnly: true,
                      //     controller: edtUnit,
                      //     onTap: () {
                      //       if (categoryId.isEmpty) {
                      //         Utility.showToast(
                      //             "please_select_category_first_key".tr());
                      //         return;
                      //       }
                      //
                      //       showModalBottomSheet(
                      //           context: context,
                      //           builder: (context) {
                      //             return UnitBottomSheet(
                      //                 categoryId: categoryId,
                      //                 onSelect: (unit) {
                      //                   unitId = unit.id;
                      //                   edtUnit.text = unit.unitName;
                      //                 });
                      //           });
                      //     },
                      //     decoration: InputDecoration(
                      //         labelText: "unit_key".tr(),
                      //         suffixIcon:
                      //             Icon(Icons.keyboard_arrow_right_sharp),
                      //         suffixIconConstraints: BoxConstraints(
                      //             minWidth: 20,
                      //             maxWidth: 21,
                      //             minHeight: 20,
                      //             maxHeight: 21)),
                      //   ),
                      //   flex: 2,
                      // ),
                    ],
                  );
                }),

                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  readOnly: true,
                  controller: edtOptions,
                  onTap: () {
                    if (edtCategory.text.isEmpty)
                      Utility.showToast("please_select_category_key".tr());
                    else
                      showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                          builder: (context) {
                            return VariantTypeBottomSheet(
                              categoryId: categoryId,
                              selectedVariants: variantType,
                              onSelect: (List<VariantType> variants) async {
                                if (variants.isEmpty) {
                                  Utility.showToast("please_select_at_least_one_option_key".tr());
                                } else {
                                  variantType = variants;
                                  List<VariantOption> options = [];
                                  String variantName = "";
                                  for (int i = 0; i < variantType.length; i++) {
                                    options.add(VariantOption(name: variantType[i].variantName, value: ""));
                                    if (i == variantType.length - 1)
                                      variantName = variantName + variantType[i].variantName;
                                    else
                                      variantName = variantName + variantType[i].variantName + " / ";
                                  }
                                  ProductVariantModel model = variantModel;
                                  model.option = options;
                                  edtOptions.text = variantName;
                                  print(model.toString());
                                  addProductBloc.add(SelectVariantOptionEvent(variant: model));
                                }
                              },
                            );
                          });
                  },
                  decoration: InputDecoration(
                      labelText: "options_key".tr(),
                      hintText: "select_options_key".tr(),
                      suffixIcon: Icon(Icons.keyboard_arrow_right),
                      suffixIconConstraints: BoxConstraints(minWidth: 20, maxWidth: 21, minHeight: 20, maxHeight: 21)),
                ),
                const SizedBox(
                  height: 15,
                ),
                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: "Select color",
                //   ),
                // ),
                // const SizedBox(
                //   height: 15,
                // ),
                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: "Select size",
                //   ),
                // ),
                BlocBuilder<AddProductBloc, AddProductState>(
                  builder: (context, state) {
                    if (state is SelectVariantOptionState) {
                      variantModel = state.variant;
                    }
                    return Column(
                      children: List.generate(variantModel.option.length, (index) {
                        return VariantOptionWidget(variantModel.option[index]);
                      }),
                    );
                  },
                ),

                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: "Product description",
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<AddProductBloc, AddProductState>(
                  builder: (context, state) {
                    if (state is AddProductVariantState) {
                      productVariant.addAll(state.productVariant);
                    }
                    if (state is UpdateProductVariantState) {
                      productVariant = state.productVariant;
                    }
                    if (state is UpdateSingleProductVariantState) {
                      productVariant[state.index] = state.productVariant;
                    }
                    if (state is DeleteProductVariantState) {
                      productVariant.remove(state.productVariant);
                    }
                    if (productVariant.isEmpty) {
                      return ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.black, width: 1)),
                        onTap: () async {
                          if (variantType.isEmpty) {
                            Utility.showToast("please_select_at_least_one_option_key".tr());
                          } else {
                            var result = await Navigator.push(
                                context,
                                PageTransition(
                                    child: ProductVariantScreen(
                                        variantType: variantType,
                                        categoryId: categoryId,
                                        productVariant: productVariant,
                                        edit: false,
                                        add: false),
                                    type: PageTransitionType.bottomToTop));
                            if (result != null) {
                              List<ProductVariantModel> variants = result as List<ProductVariantModel>;

                              debugPrint("variants---->$variants");

                              addProductBloc.add(AddProductVariantEvent(productVariant: variants));
                            }
                          }
                        },
                        title: Text(
                          "add_product_variants_key".tr(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("color_size_etc_key".tr()),
                        contentPadding: EdgeInsets.only(right: 0, left: 10),
                        trailing: Icon(Icons.keyboard_arrow_right_sharp),
                      );
                    } else {
                      return Column(
                        children: [
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "product_variants_key".tr(),
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    SystemChannels.textInput.invokeMethod("TextInput.hide");

                                    showBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        )),
                                        builder: (context) {
                                          return SelectionBottomSheet(onEdit: () async {
                                            var result = await Navigator.push(
                                                context,
                                                PageTransition(
                                                    child: ProductVariantScreen(
                                                        variantType: variantType,
                                                        categoryId: categoryId,
                                                        productVariant: productVariant,
                                                        edit: true,
                                                        add: false),
                                                    type: PageTransitionType.bottomToTop));
                                            if (result != null) {
                                              List<ProductVariantModel> variants = result as List<ProductVariantModel>;

                                              addProductBloc.add(UpdateProductVariantEvent(productVariant: variants));
                                            }
                                          }, onAdd: () async {
                                            var result = await Navigator.push(
                                                context,
                                                PageTransition(
                                                  child: ProductVariantScreen(
                                                      variantType: variantType,
                                                      categoryId: categoryId,
                                                      productVariant: productVariant,
                                                      edit: false,
                                                      add: true),
                                                  type: PageTransitionType.bottomToTop,
                                                ));
                                            if (result != null) {
                                              List<ProductVariantModel> variants = result as List<ProductVariantModel>;
                                              addProductBloc.add(AddProductVariantEvent(productVariant: variants));
                                            }
                                          });
                                        });
                                  },
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.more_vert),
                                  splashRadius: 12,
                                  iconSize: 20,
                                  constraints: BoxConstraints(maxHeight: 20, maxWidth: 20),
                                ),
                              ]),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: List.generate(productVariant.length, (index) {
                              ProductVariantModel variant = productVariant[index];
                              String variantName = "";
                              for (int i = 0; i < variant.option.length; i++) {
                                if (i == variant.option.length - 1)
                                  variantName = variantName + variant.option[i].value;
                                else
                                  variantName = variantName + variant.option[i].value + " / ";
                              }

                              return Container(
                                margin: EdgeInsets.only(bottom: 15),
                                width: MediaQuery.of(context).size.width,
                                // height: 100,
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 50, right: 10, bottom: 10, top: 10),
                                      margin: EdgeInsets.only(left: 20),
                                      constraints: BoxConstraints(minHeight: 80),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.black, width: 1)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "$variantName",
                                              ),
                                              Text(
                                                "₹ ${variant.sellingPrice}",
                                                style: TextStyle(color: ColorPrimary),
                                              ),
                                              Text(
                                                "stock_key".tr() + ": ${variant.stock}".tr(),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              IconButton(
                                                  onPressed: () async {
                                                    var result = await Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          child: ProductVariantScreen(
                                                              variantType: variantType,
                                                              categoryId: categoryId,
                                                              productVariant: [variant],
                                                              edit: true,
                                                              add: false),
                                                          type: PageTransitionType.bottomToTop,
                                                        ));
                                                    if (result != null) {
                                                      List<ProductVariantModel> variants =
                                                          result as List<ProductVariantModel>;
                                                      addProductBloc.add(UpdateSingleProductVariantEvent(
                                                          productVariant: variants.first, index: index));
                                                    }
                                                  },
                                                  padding: EdgeInsets.all(0),
                                                  splashRadius: 15,
                                                  iconSize: 20,
                                                  icon: Image.asset(
                                                    "assets/images/edit.png",
                                                    fit: BoxFit.contain,
                                                    width: 20,
                                                    height: 20,
                                                  )),
                                              IconButton(
                                                  onPressed: () {
                                                    addProductBloc
                                                        .add(DeleteProductVariantEvent(productVariant: variant));
                                                  },
                                                  padding: EdgeInsets.all(0),
                                                  splashRadius: 15,
                                                  iconSize: 20,
                                                  icon: Image.asset(
                                                    "assets/images/delete.png",
                                                    fit: BoxFit.contain,
                                                    width: 20,
                                                    height: 20,
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: productVariant[index].productImages.isNotEmpty
                                              ? Image.file(
                                                  productVariant[index].productImages.first,
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.contain,
                                                )
                                              : Image.asset(
                                                  "assets/images/suggested.png",
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.contain,
                                                ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      );
                    }
                  },
                  bloc: addProductBloc,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: MaterialButton(
              onPressed: () async {
                if (await Network.isConnected()) {
                  addProduct(context);
                } else {
                  Utility.showToast(Constant.INTERNET_ALERT_MSG);

                  // EasyLoading.showError(Constant.INTERNET_ALERT_MSG);
                }
              },
              height: 50,
              shape: RoundedRectangleBorder(),
              color: ColorPrimary,
              child: Text(
                "add_product_key".tr().toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void addProduct(BuildContext context) async {
    variantImage.clear();
    if (edtProductName.text.trim().isEmpty) {
      Utility.showToast("please_enter_product_name_key".tr());
      return;
    }
    if (edtCategory.text.isEmpty || categoryId.isEmpty) {
      Utility.showToast("please_select_product_category_key".tr());
      return;
    }

    // if (variantModel.purchasePrice.isEmpty) {
    //   Utility.showToast("please_enter_purchase_price_key".tr());
    //   return;
    // }
    if (variantModel.sellingPrice.isEmpty) {
      Utility.showToast("please_enter_selling_price_key".tr());
      return;
    }
    if (variantModel.sellingPrice == "0") {
      Utility.showToast("please_enter_valid_mrp_key".tr());
      return;
    }
    if (variantModel.mrp.isEmpty) {
      Utility.showToast("please_enter_mrp_key".tr());
      return;
    }
    if (variantModel.mrp == "0") {
      Utility.showToast("please_enter_valid_mrp_key".tr());
      return;
    }
    if (double.parse(variantModel.sellingPrice.trim()) > double.parse(variantModel.mrp.trim())) {
      Utility.showToast("selling_price_cannot_be_more_than_mrp_key".tr());
      return;
    }

    // if (edtUnit.text.isEmpty) {
    //   Utility.showToast("please_select_unit_key".tr());
    //   return;
    // }
    if (variantModel.stock.isEmpty) {
      Utility.showToast("stock_can_not_be_empty_key".tr());
      return;
    }
    if (int.parse(variantModel.stock) <= 0) {
      Utility.showToast("stock_can_not_be_zero_key".tr());
      return;
    }
    if (variantModel.option.isNotEmpty) {
      for (int i = 0; i < variantModel.option.length; i++) {
        if (variantModel.option[i].value.isEmpty) {
          Utility.showToast("please_enter_key".tr() + " ${variantModel.option[i].name}");
          return;
        }
      }
    }

    Map<String, dynamic> input = HashMap<String, dynamic>();

    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["category_id"] = categoryId;
    input["product_name"] = edtProductName.text.trim();
    // input["unit"] = unitId;

    List<Map<String, dynamic>> productVariantList = [];
    Map<String, dynamic> productVariantMap = HashMap<String, dynamic>();
    String optionIds = "";
    String variantValue = "";
    for (int i = 0; i < variantType.length; i++) {
      if (i == variantType.length - 1) {
        optionIds += variantType[i].id;
        variantValue += variantModel.option[i].value;
      } else {
        optionIds += variantType[i].id + ",";
        variantValue += variantModel.option[i].value + ",";
      }
    }
    Map<String, dynamic> price = HashMap<String, dynamic>();
    price["purchase_price"] = variantModel.purchasePrice;
    price["mrp"] = variantModel.mrp;
    price["selling_price"] = variantModel.sellingPrice;
    productVariantMap["option_id"] = optionIds;
    productVariantMap["variant_value"] = variantValue;
    productVariantMap["variant_price"] = price;
    productVariantMap["stock"] = variantModel.stock;
    productVariantList.add(productVariantMap);

    if (productVariant.isNotEmpty) {
      productVariant.forEach((element) {
        Map<String, dynamic> productVariantMap = HashMap<String, dynamic>();
        String optionIds = "";
        String variantValue = "";
        for (int i = 0; i < element.option.length; i++) {
          if (i == element.option.length - 1) {
            optionIds += variantType[i].id;
            variantValue += element.option[i].value;
          } else {
            optionIds += variantType[i].id + ",";
            variantValue += element.option[i].value + ",";
          }
        }
        Map<String, dynamic> price = HashMap<String, dynamic>();
        price["purchase_price"] = element.purchasePrice;
        price["mrp"] = element.mrp;
        price["selling_price"] = element.sellingPrice;
        productVariantMap["option_id"] = optionIds;
        productVariantMap["variant_value"] = variantValue;
        productVariantMap["variant_price"] = price;
        productVariantMap["stock"] = element.stock;

        productVariantList.add(productVariantMap);
      });
    }
    input["product_variants"] = productVariantList;

    variantImage.add(VariantImage(images: variantModel.productImages));
    productVariant.forEach((element) {
      variantImage.add(VariantImage(images: element.productImages));
    });

    addProductBloc.add(AddProductApiEvent(input: input));
  }
}

class VariantImage {
  String? variantId;
  List<File>? images;

  VariantImage({this.variantId, this.images});
}
