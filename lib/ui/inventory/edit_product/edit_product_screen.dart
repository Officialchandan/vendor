import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/model/product_variant.dart';
import 'package:vendor/model/product_variant_response.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/inventory/add_product/bloc/add_product_bloc.dart';
import 'package:vendor/ui/inventory/add_product/bloc/add_product_event.dart';
import 'package:vendor/ui/inventory/add_product/bloc/add_product_state.dart';
import 'package:vendor/ui/inventory/edit_product/bloc/edit_product_bloc.dart';
import 'package:vendor/ui/inventory/edit_product/bloc/edit_product_event.dart';
import 'package:vendor/ui/inventory/edit_product/bloc/edit_product_state.dart';
import 'package:vendor/ui/inventory/product_variant/product_variant_screen.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/UnitBottomSheet.dart';
import 'package:vendor/widget/category_bottom_sheet.dart';
import 'package:vendor/widget/select_image_bottom_sheet.dart';
import 'package:vendor/widget/variant_type_bottom_sheet.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel product;

  EditProductScreen({required this.product});

  @override
  EditProductScreenState createState() => EditProductScreenState();
}

class EditProductScreenState extends State<EditProductScreen> {
  EditProductBloc editProductBloc = EditProductBloc();
  AddProductBloc addProductBloc = AddProductBloc();
  List<ProductImage> imageList = [];
  StreamController<List<ProductImage>> imgController = StreamController();
  bool showOnline = true;
  ProductVariantModel variantModel = ProductVariantModel();
  TextEditingController edtProductName = TextEditingController();
  TextEditingController edtCategory = TextEditingController();
  TextEditingController edtSubCategoryCategory = TextEditingController();
  TextEditingController edtUnit = TextEditingController();
  TextEditingController edtOptions = TextEditingController();
  String unitId = "";
  List<VariantType> variantType = [];
  String categoryId = "";

  @override
  void dispose() {
    super.dispose();
    imgController.close();
  }

  @override
  void initState() {
    super.initState();
    imageList = widget.product.productImages;
    imgController.add(imageList);
    edtProductName.text = widget.product.productName;
    edtUnit.text = widget.product.unit;
    unitId = widget.product.unit;
    edtCategory.text = widget.product.categoryName;
    categoryId = widget.product.categoryId;
    variantModel.mrp = widget.product.mrp;
    variantModel.sellingPrice = widget.product.sellingPrice;
    variantModel.purchasePrice = widget.product.purchasePrice;
    variantModel.stock = widget.product.stock.toString();

    if (widget.product.productOption.isNotEmpty) {
      String options = "";
      List<VariantOption> variantOptions = [];

      for (int i = 0; i < widget.product.productOption.length; i++) {
        VariantType variant = VariantType(
            id: widget.product.productOption[i].productOptionId.toString(),
            categoryName: widget.product.productOption[i].optionName,
            variantName: widget.product.productOption[i].optionName);

        VariantOption variantOption =
            VariantOption(name: widget.product.productOption[i].optionName, value: widget.product.productOption[i].value);
        variantType.add(variant);
        variantOptions.add(variantOption);
        if (i == widget.product.productOption.length - 1) {
          options += widget.product.productOption[i].optionName + "";
        } else {
          options += widget.product.productOption[i].optionName + ", ";
        }
      }
      variantModel.option = variantOptions;
      edtOptions.text = options;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => editProductBloc),
        BlocProvider(create: (context) => addProductBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddProductBloc, AddProductState>(
            listener: (context, state) {
              if (state is SelectImageState) {
                addProductBloc
                    .add(UploadImageEvent(productId: widget.product.productId, variantId: widget.product.id, images: state.image));
              }
              if (state is UploadImageSuccessState) {
                state.image.forEach((element) {
                  ProductImage productImage = ProductImage();
                  productImage.id = element.id;
                  productImage.variantId = element.variantId;

                  element.productImage.forEach((image) {
                    productImage.productImage = image;
                    imageList.add(productImage);
                  });
                });

                imgController.add(imageList);
              }
            },
          ),
          BlocListener<EditProductBloc, EditProductState>(
            listener: (context, state) {
              if (state is DeleteProductImageState) {
                imageList.remove(state.image);

                imgController.add(imageList);
              }
              if (state is UpdateProductState) {
                Navigator.pop(context);
              }
            },
          )
        ],
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Edit Product",
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            showCupertinoModalPopup(
                                context: context,
                                builder: (context) => SelectImageBottomSheet(
                                      openGallery: () {
                                        addProductBloc.add(SelectImageEvent(context: context, source: ImageSource.gallery));
                                      },
                                      openCamera: () {
                                        addProductBloc.add(SelectImageEvent(context: context, source: ImageSource.camera));
                                      },
                                    ));
                          },
                          icon: Icon(Icons.linked_camera),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      StreamBuilder<List<ProductImage>>(
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
                                          image: NetworkImage(
                                            snap.data![index].productImage,
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
                                        editProductBloc.add(DeleteImageEvent(image: snap.data![index]));
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: widget.product.purchasePrice,
                        decoration: InputDecoration(labelText: "Purchase price"),
                        onChanged: (text) {
                          widget.product.purchasePrice = text;
                        },
                      ),
                      flex: 3,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: widget.product.mrp,
                        decoration: InputDecoration(labelText: "MRP"),
                        onChanged: (text) {
                          widget.product.mrp = text;
                        },
                      ),
                      flex: 2,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: widget.product.sellingPrice,
                        decoration: InputDecoration(labelText: "Selling price"),
                        onChanged: (text) {
                          widget.product.sellingPrice = text;
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
                        initialValue: widget.product.stock.toString(),
                        decoration: InputDecoration(labelText: "Stock"),
                        onChanged: (text) {
                          widget.product.stock = int.parse(text);
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
                              selectedVariants: variantType,
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
              ],
            ),
          ),
          bottomNavigationBar: Container(
            child: MaterialButton(
              onPressed: () {
                update(context);
              },
              height: 50,
              shape: RoundedRectangleBorder(),
              color: ColorPrimary,
              child: Text("UPDATE"),
            ),
          ),
        ),
      ),
    );
  }

  void update(BuildContext context) async {
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
    if (double.parse(variantModel.sellingPrice.trim()) > double.parse(variantModel.mrp.trim())) {
      Utility.showToast("Selling Price cannot be more than MRP");
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
    input["id"] = widget.product.id;
    input["product_id"] = widget.product.productId;
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

    productVariantMap["variant_price"] = price;
    productVariantMap["product_option_variant_id"] = optionIds;
    productVariantMap["variant_value"] = variantValue;

    productVariantMap["stock"] = variantModel.stock;
    productVariantList.add(productVariantMap);

    input["product_variants"] = productVariantList;

    print("input add product api -> ${jsonEncode(input)}");

    print("AddProductApiEvent-->");
    editProductBloc.add(EditProductApiEvent(input: input));
  }
}
