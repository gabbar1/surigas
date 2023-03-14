import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surigas/utils/loader.dart';
import 'package:surigas/view_model/purchase_model_view/purchase_model_view.dart';
import '../../../view_model/product_list_vm/product_list_vm.dart';

class Agent extends StatefulWidget {
  Agent({this.keys, this.name});
  final String? name;
  final String? keys;
  @override
  State<Agent> createState() => _AgentState();
}

class _AgentState extends State<Agent> {
  TextEditingController fullController = TextEditingController();
  TextEditingController emptyController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  PurchaseModelView purchaseModelView = Get.put(PurchaseModelView());
  final _globalagentKey = GlobalKey<FormState>();
  Future<void> showInformationDialog() {
    fullController.clear();
    emptyController.clear();
    rateController.clear();
    amountController.clear();
    DateTime? _startDateTime = DateTime.now();
    void _showDatePicker() async {
      _startDateTime = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2021),
          lastDate: DateTime.now());
      if (_startDateTime == null) {
        return;
      } else {
        purchaseModelView.setPurchaseDate = "${_startDateTime!.day}/${_startDateTime!.month}/${_startDateTime!.year}";

      }
    }

    return showModalBottomSheet(
      isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Place",
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Order",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 20),
                            )
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.close))
                      ],
                    ),
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
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
                                      setState(() {
                                        purchaseModelView.setColorIndex( index );
                                      });
                                    },
                                    child: Obx(()=>Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: purchaseModelView.getColorIndex == index
                                              ? Colors.blue
                                              : Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Color(0xFFD5EAFE))),
                                      child: Center(
                                        child: Text(
                                          productListVM
                                              .getProductList[index].productName
                                              .toString(),
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ))),
                              );
                            })),
                      ),
                    ),
                  ),
                  Form(
                    key: _globalagentKey,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                    children: [
                      InkWell(
                        onTap: _showDatePicker,
                        child: Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          height: 60,
                          child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(()=>Text(purchaseModelView.getPurchaseDate)),

                                  Icon(Icons.arrow_drop_down),
                                ],
                              )),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFF2F2F2),
                          ),
                        ),
                      ),
                        SizedBox(height: 10,),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: fullController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Cylinder';
                            } else if (value!.isAlphabetOnly) {
                              return "Please Enter Valid Number";
                            } else if (value!.length > 5) {
                              return "Please Enter Valid Number";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: "Full cylinder",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: emptyController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Empty Cylinder";
                            } else if (value!.isAlphabetOnly) {
                              return "Please Enter Valid Number";
                            } else if (value!.length > 5) {
                              return "Please Enter Valid Number";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: "Empty cylinder",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: rateController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter rate';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: "Rate",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: amountController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter amount';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: "Amount",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      InkWell(
                        onTap: (){
                          if (_globalagentKey.currentState!.validate()){
                            purchaseModelView.fetchPurchaseDue(
                              key: widget.keys,
                                orderDate: Timestamp.fromDate(_startDateTime!),
                              emptyCylinder: emptyController.text,
                              fullCylinder: fullController.text,
                              rate: rateController.text,
                              totalAmount: amountController.text,
                              name: productListVM.getProductList[purchaseModelView.getColorIndex].productName,
                            );

                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey.shade500)),
                          child: Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                      ))
                ],
              ),
            ),
          );
        });
  }

  ProductListVM productListVM = Get.put(ProductListVM());

  int colorIndex2 = 0;
  @override
  void initState() {
    // TODO: implement initState
    productListVM.fetchProductList(true,key: widget.keys!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(widget.name.toString()),
      ),
      body: Column(
        children: [
          Obx(
            () => Padding(
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
                              productListVM.fetchPurchaseHistory(widget.keys!,productListVM.getProductList[index].productName);
                              productListVM.setShowLoader = true;
                              setState(() {
                                colorIndex2 = index;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: colorIndex2 == index
                                      ? Colors.blue
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Color(0xFFD5EAFE))),
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
          ),
          Obx((){
            if(productListVM.getShowLoader==true){
              return Expanded(child: Center(child: CircularProgressIndicator()));
            }else{
              return Expanded(child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: productListVM.getPurchaseHostoryList.length,itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("${productListVM.getPurchaseHostoryList[index].fullCylinder!} Cylinder",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
                              ],
                            ),
                            SizedBox(height: 5,),
                            Text(DateTime.parse(productListVM.getPurchaseHostoryList[index].orderDate!.toDate().toString()).toString(),),
                          ],),
                        Text(productListVM.getPurchaseHostoryList[index].totalAmount!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                      ],
                    ),
                  );
                },),
              ));
            }
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showInformationDialog();
        },
        elevation: 10,
        child: Icon(Icons.add),
      ),
    );
  }
}
