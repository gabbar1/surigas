import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view_model/product_list_vm/product_list_vm.dart';

class EditPrice extends StatefulWidget {

  const EditPrice({Key? key ,this.productName}) : super(key: key);
  final String? productName;


  @override
  State<EditPrice> createState() => _EditPriceState();

}

class _EditPriceState extends State<EditPrice> {
  ProductListVM productListVM = Get.find();
  final _globalFistKey = GlobalKey<FormState>();
  int? colorIndex=0;String? productName;
  String? currentProduct;
  num? originalPrice;

  @override
  void initState() {
    // TODO: implement initState
    productListVM.fetchProductList(true);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Price"),
          centerTitle: true,
        ),
        body: Obx(() => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10),
                  child: SizedBox(
                    height: 80,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: productListVM.getProductList.length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: () {
                                  productListVM.fetchProductPrice(productListVM.getUserKey,  productListVM.getProductList[index].productName);
                                  setState(() {
                                    colorIndex = index;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: colorIndex == index
                                          ? Colors.blue
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border:
                                          Border.all(color: Color(0xFFD5EAFE))),
                                  child: Center(
                                    child: Text(
                                      productListVM
                                          .getProductList[index].productName
                                          .toString(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                )),
                          );
                        })),
                  ),
                ),

                Obx(()=>Form(
                    key: _globalFistKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                         if(productListVM.getIsAddPrice==true&& productListVM.getIsInsertPrice==false)...[
                           productListVM.getProductList.isEmpty  ?SizedBox(): Text("${productListVM.getProductList[colorIndex!].productName}'s orginial price is ${productListVM.getProductList[colorIndex!].productPrice}"),
                           SizedBox(height: 10,),
                           InkWell(
                               onTap: () {
                                 productListVM.setIsInsertPrice=true;
                                 productListVM.productNameController.text = productListVM.getProductList[colorIndex!].productName.toString();
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
                                       "Add Price",
                                       style: TextStyle(color: Colors.white),
                                     )),
                               )),
                           SizedBox(height: 10,),
                         ],
                          if(productListVM.getIsAddPrice==false&&  productListVM.getIsInsertPrice==false)...[
                            TextFormField(
                              readOnly: true,
                              controller: productListVM.productNameController,
                              decoration: InputDecoration(
                                  hintText: (widget.productName.toString()),
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
                              keyboardType: TextInputType.phone,
                              controller: productListVM.productPriceController,
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
                            InkWell(
                                onTap: () {
                                  productListVM.addProductPrice(productListVM.getUserKey,productListVM.productNameController.text,productListVM.productPriceController.text,productListVM
                                      .getProductList[colorIndex!].isReplaceable!).then((value) {
                                    productListVM.setIsAddPrice = false;
                                    productListVM.setIsInsertPrice = false;
                                  });
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
                                        "Update",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                )),
                          ],
                          if(productListVM.getIsInsertPrice==true)...[
                            TextFormField(
                              readOnly: true,
                              controller: productListVM.productNameController,
                              decoration: InputDecoration(
                                  hintText: (widget.productName.toString()),
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
                              keyboardType: TextInputType.phone,
                              controller: productListVM.productPriceController,
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
                            InkWell(
                                onTap: () {
                                 productListVM.addProductPrice(productListVM.getUserKey,productListVM.productNameController.text,productListVM.productPriceController.text,productListVM
                                     .getProductList[colorIndex!].isReplaceable!).then((value) {
                                   productListVM.setIsAddPrice = false;
                                   productListVM.setIsInsertPrice = false;
                                 });

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
                                        "Add",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                )),
                          ]

                        ],
                      ),
                    )))
              ],
            )));
  }


}
