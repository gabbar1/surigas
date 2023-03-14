import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surigas/view/screens/customer_page/customer_view.dart';

import '../../../view_model/product_list_vm/product_list_vm.dart';
import '../../../view_model/sales_model_view/sale_model_view.dart';

class Sales extends StatefulWidget {
  CollectionReference client = FirebaseFirestore.instance.collection("client");

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  int count = 0;
  SalesModelView salesModelView = Get.put(SalesModelView());

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  ProductListVM productListVM = Get.put(ProductListVM());
  Timer? _debounce;
  @override
  void initState() {
    // TODO: implement initState
    salesModelView.fetchSalesList();
    productListVM.fetchProductList(false);
    super.initState();
  }
  final _globalKey = GlobalKey<FormState>();
  Future<void> showInformationDialog() async {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.only(
                  top: 20,
                  left: 20,right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: _globalKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Add",
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            const Text(
                              "Customer",
                              style: TextStyle(color: Colors.blue, fontSize: 20),
                            ),
                          ],
                        ),

                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: nameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Name';
                        } else if (value.isNum) {
                          return 'Please Enter Valid Name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: "contact person name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: mobileNumberController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Mobile Number';
                        } else if (value!.isAlphabetOnly) {
                          return 'Please Enter Mobile Number';
                        } else if (value.length < 10) {
                          return ' Please Enter  Valid Mobile Number';
                        } else if (value.length > 12) {
                          return 'Please Enter Valid Mobile Number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: "contact No",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: addressController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Address';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: "address ",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_globalKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Processing Data')),
                            );
                            FirebaseFirestore.instance
                                .collection("client")
                                .add({
                              "name": nameController.text,
                              "mobile_number":int.parse(mobileNumberController.text),
                              "address":  addressController.text,
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text("Add Customer"))
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text("Sales Menu"),
        actions: [
          Center(
            child: InkWell(
              onTap: () async {
                await showInformationDialog();
              },
              child: Text(
                "Add Customer",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.blue,
                ),
                hintText: "Search Here...",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              onChanged: (val) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  salesModelView
                      .searchSalesUSer(val.camelCase.toString());
                });
              },
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Expanded(
              child: Obx(() => ListView.builder(
                  itemCount: salesModelView.getSalesModel.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          salesModelView.getSalesModel[index].name.toString()),
                      subtitle: Text(salesModelView
                          .getSalesModel[index].mobileNumber
                          .toString()),
                      onTap: () {
                        productListVM.setUserKey = salesModelView.getSalesModel[index].key.toString();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Customer(name: salesModelView.getSalesModel[index].name,
                              mobileNumber: salesModelView.getSalesModel[index].mobileNumber,
                              address: salesModelView.getSalesModel[index].address,
                              userKey: salesModelView.getSalesModel[index].key,
                            )));
                      },
                    );
                  })))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showInformationDialog();
        },
        elevation: 10.0,
        child: Icon(Icons.add),
      ),
    );
  }
}
