import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surigas/view_model/product_list_vm/product_list_vm.dart';

class ProductListPage extends StatefulWidget {
  ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _globalFistKey = GlobalKey<FormState>();

  ProductListVM productListVM = Get.put(ProductListVM());

  TextEditingController productPriceController = TextEditingController();

  TextEditingController productNameController = TextEditingController();
 @override
  void initState() {
    // TODO: implement initState
   productListVM.fetchProductList(false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        centerTitle: true,
      ),
      body: Obx(() =>
         ListView.builder(
          itemCount: productListVM.getProductList.length,
          itemBuilder: ((context, index) {
            return InkWell(
              onTap: (){
                showEditProductDialog(productListVM.getProductList[index].productName.toString(),productListVM.getProductList[index].key,productListVM.getProductList[index].productPrice,productListVM.getProductList[index]?.isReplaceable);
              },
              child: ListTile(
                title: Text(
                    productListVM.getProductList[index].productName.toString(),style: TextStyle(),),
                subtitle: Text(
                    productListVM.getProductList[index].productPrice.toString()),
              ),
            );
          }))),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddProductDialog();
          },
          child: Icon(Icons.add)),
    );
  }

  Future<void> showAddProductDialog() async {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: Get.context!,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.all(15.0),
            child: Obx(() => Form(
                  key: _globalFistKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Add",
                                style: TextStyle(fontSize: 20.0),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Product",
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 20.0),
                              ),
                            ],
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(Icons.clear_rounded),
                                onPressed: () => Navigator.of(context).pop(),
                              ))
                        ],
                      ),
                      TextFormField(
                        controller: productNameController,
                        decoration: InputDecoration(
                            hintText: "Product Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: productPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Product Price",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CheckboxListTile(
                          title: Text("Is Replacable"),
                          value: productListVM.getIsCheck,
                          onChanged: (val) {
                            productListVM.setIsCheck = val!;
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                          onTap: () {
                            if (_globalFistKey.currentState!.validate()) {
                              productListVM
                                  .addProduct(productNameController.text,
                                      num.parse(productPriceController.text))
                                  .then((value) {
                                productPriceController.clear();
                                productNameController.clear();
                                productListVM.setIsCheck = false;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.grey.shade500)),
                            child: Center(
                                child: Text(
                              "Next",
                              style: TextStyle(color: Colors.white),
                            )),
                          )),
                    ],
                  ),
                )),
          );
        });
  }
  Future<void> showEditProductDialog(String name,key,num? price,bool? isCheck) async {
    productNameController.text = name;
    productPriceController.text = price.toString();
    productListVM.setIsCheck = isCheck!;
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: Get.context!,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.all(15.0),
            child: Obx(() => Form(
                  key: _globalFistKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Edit",
                                style: TextStyle(fontSize: 20.0),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Product",
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 20.0),
                              ),
                            ],
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(Icons.clear_rounded),
                                onPressed: () => Navigator.of(context).pop(),
                              ))
                        ],
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: productNameController,
                        decoration: InputDecoration(
                            hintText: "Product Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: productPriceController,
                        decoration: InputDecoration(
                            hintText: "Product Price",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CheckboxListTile(
                          title: Text("Is Replacable"),
                          value: productListVM.getIsCheck,
                          onChanged: (val) {
                            productListVM.setIsCheck = val!;
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                          onTap: () {
                            if (_globalFistKey.currentState!.validate()) {
                              productListVM
                                  .editProduct(key,
                                      num.parse(productPriceController.text))
                                  .then((value) {
                                productPriceController.clear();
                                productNameController.clear();
                                productListVM.setIsCheck = false;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.grey.shade500)),
                            child: Center(
                                child: Text(
                              "Next",
                              style: TextStyle(color: Colors.white),
                            )),
                          )),
                    ],
                  ),
                )),
          );
        });
  }
}
