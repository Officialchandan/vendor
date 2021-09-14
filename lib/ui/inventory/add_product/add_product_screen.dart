import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/UI/inventory/add_product/bloc/add_product_state.dart';
import 'package:vendor/model/get_sub_category_response.dart';
import 'package:vendor/UI/custom_widget/app_bar.dart';
import 'package:vendor/UI/inventory/add_product/bloc/add_product_bloc.dart';
import 'package:vendor/UI/inventory/add_product/bloc/add_product_event.dart';

import 'package:vendor/UI/inventory/product_varient/product_varient_screen.dart';
import 'package:vendor/UI/inventory/select_sub_category.dart';
import 'package:vendor/model/product_variant.dart';
import 'package:vendor/model/product_variant_response.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/inventory/add_product/bloc/add_product_bloc.dart';
import 'package:vendor/ui/inventory/add_product/bloc/add_product_event.dart';
import 'package:vendor/ui/inventory/add_product/bloc/add_product_state.dart';
import 'package:vendor/ui/inventory/product_varient/product_varient_screen.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/UnitBottomSheet.dart';
import 'package:vendor/widget/category_bottom_sheet.dart';
import 'package:vendor/widget/selection_bottom_sheet.dart';
import 'package:vendor/widget/varient_type_bottom_sheet.dart';

class AddProductScreen extends StatefulWidget {
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
          print("add product bloc state-->$state");
          if (state is SelectImageState) {
            variantModel.productImages = imageList;
            imageList.add(state.image);
            imgController.add(imageList);
          }

          if (state is AddProductFailureState) {
            variantImage.clear();
          }

          if (state is UploadImageFailureState) {
            print("variant image 4-> $variantImage");
            variantImage.removeAt(0);
            print("variant image 5-> $variantImage");
            if (variantImage.isNotEmpty) {
              addProductBloc.add(UploadImageEvent(
                  variantId: variantImage.first.variantId!, images: variantImage.first.images!, productId: productId));
            } else {
              EasyLoading.dismiss();
            }
          }
          if (state is UploadImageSuccessState) {
            print("variant image 2-> $variantImage");
            variantImage.removeAt(0);
            print("variant image 3-> $variantImage");
            if (variantImage.isNotEmpty) {
              addProductBloc.add(UploadImageEvent(
                  variantId: variantImage.first.variantId!, images: variantImage.first.images!, productId: productId));
            } else {
              EasyLoading.dismiss();
            }
          }

          if (state is AddProductSuccessState) {
            productId = state.responseData.productId;
            for (int i = 0; i < state.responseData.variantId.length; i++) {
              variantImage[i].variantId = state.responseData.variantId[i];
            }

            print("variant image 1-> $variantImage");

            addProductBloc.add(
                UploadImageEvent(variantId: variantImage.first.variantId!, images: variantImage.first.images!, productId: productId));
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Add Product",
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add Products Image"),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(5)),
                        child: IconButton(
                          onPressed: () {
                            addProductBloc.add(SelectImageEvent(context: context));
                          },
                          icon: Icon(Icons.linked_camera),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      StreamBuilder<List<File>>(
                        stream: imgController.stream,
                        initialData: [],
                        builder: (context, snap) {
                          if (snap.hasData && snap.data!.isNotEmpty) {
                            return Row(
                              children: List.generate(snap.data!.length, (index) {
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
                                        imageList.removeAt(index);
                                        variantModel.productImages.removeAt(index);
                                        imgController.add(imageList);
                                      },
                                    ),
                                  )
                                ]);
                              }),
                            );
                          }

                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
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
                TextFormField(
                  controller: edtProductName,
                  decoration: InputDecoration(
                    labelText: "Product name",
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
                        builder: (context) {
                          return CategoryBottomSheet(onSelect: (category) {
                            categoryId = category.id;
                            edtCategory.text = category.categoryName!;
                          });
                        });
                  },
                  controller: edtCategory,
                  decoration: InputDecoration(
                      labelText: "Category",
                      hintText: "Select category",
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Purchase price"),
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
                        decoration: InputDecoration(labelText: "MRP"),
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
                        decoration: InputDecoration(labelText: "Selling price"),
                        onChanged: (text) {
                          variantModel.sellingPrice = text;
                        },
                      ),
                      flex: 3,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Stock"),
                        onChanged: (text) {
                          variantModel.stock = text;
                        },
                      ),
                      flex: 2,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: edtUnit,
                        onTap: () {
                          if (categoryId.isEmpty) {
                            Utility.showToast("Please select category first.");
                            return;
                          }

                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return UnitBottomSheet(
                                    categoryId: categoryId,
                                    onSelect: (unit) {
                                      unitId = unit.id;
                                      edtUnit.text = unit.unitName;
                                    });
                              });
                        },
                        decoration: InputDecoration(
                            labelText: "Unit",
                            suffixIcon: Icon(Icons.keyboard_arrow_right_sharp),
                            suffixIconConstraints: BoxConstraints(minWidth: 20, maxWidth: 21, minHeight: 20, maxHeight: 21)),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  readOnly: true,
                  controller: edtOptions,
                  onTap: () {
                    if (edtCategory.text.isEmpty)
                      Utility.showToast("Please select category");
                    else
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return VariantTypeBottomSheet(
                              categoryId: categoryId,
                              onSelect: (List<VariantType> variants) async {
                                print("on variant type select -> $variants");

                                if (variants.isEmpty) {
                                  Utility.showToast("Please select at least one option");
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
                      labelText: "options",
                      hintText: "Select options",
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
                            Utility.showToast("Please select at least one option");
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

                              addProductBloc.add(AddProductVariantEvent(productVariant: variants));
                            }
                          }
                        },
                        title: Text("Add Product Variants"),
                        subtitle: Text("Color, Size etc."),
                        contentPadding: EdgeInsets.only(right: 0, left: 10),
                        trailing: Icon(Icons.keyboard_arrow_right_sharp),
                      );
                    } else {
                      return Column(
                        children: [
                          Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Expanded(
                              child: Text(
                                "Product Variants",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showBottomSheet(
                                    context: context,
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
                          Column(),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: productVariant.length,
                              itemBuilder: (context, index) {
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
                                                ),
                                                Text(
                                                  "Stock : ${variant.stock}",
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
                                                        List<ProductVariantModel> variants = result as List<ProductVariantModel>;
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
                                                      addProductBloc.add(DeleteProductVariantEvent(productVariant: variant));
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
                              })
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
            child: MaterialButton(
              onPressed: () {
                addProduct(context);
              },
              height: 50,
              shape: RoundedRectangleBorder(),
              color: ColorPrimary,
              child: Text("ADD PRODUCT"),
            ),
          ),
        ),
      ),
    );
  }

  void addProduct(BuildContext context) async {
    variantImage.clear();
    if (edtProductName.text.trim().isEmpty) {
      Utility.showToast("Please enter product name");
      return;
    }
    if (edtCategory.text.isEmpty || categoryId.isEmpty) {
      Utility.showToast("Please select product category");
      return;
    }

    if (variantModel.purchasePrice.isEmpty) {
      Utility.showToast("Please enter purchase price");
      return;
    }
    if (variantModel.sellingPrice.isEmpty) {
      Utility.showToast("Please enter selling price");
      return;
    }
    if (variantModel.mrp.isEmpty) {
      Utility.showToast("Please enter mrp");
      return;
    }
    if (edtUnit.text.isEmpty) {
      Utility.showToast("Please select unit");
      return;
    }
    if (variantModel.stock.isEmpty) {
      Utility.showToast("Stock can not be empty");
      return;
    }
    if (variantModel.option.isNotEmpty) {
      for (int i = 0; i < variantModel.option.length; i++) {
        if (variantModel.option[i].value.isEmpty) {
          Utility.showToast("Please enter ${variantModel.option[i].name}");
          return;
        }
      }
    }

    Map<String, dynamic> input = HashMap<String, dynamic>();

    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["category_id"] = categoryId;
    input["product_name"] = edtProductName.text.trim();
    input["unit"] = unitId;

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

    print("input add product api -> ${jsonEncode(input)}");

    variantImage.add(VariantImage(images: variantModel.productImages));
    productVariant.forEach((element) {
      variantImage.add(VariantImage(images: element.productImages));
    });

    print("AddProductApiEvent-->");
    addProductBloc.add(AddProductApiEvent(input: input));
  }
}

class VariantImage {
  String? variantId;
  List<File>? images;

  VariantImage({this.variantId, this.images});
}
