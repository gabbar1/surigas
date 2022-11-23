import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surigas/view/screens/agent_page/agent_view.dart';

import '../../../view_model/purchase_model_view/purchase_model_view.dart';

class Purchase extends StatefulWidget {
  CollectionReference agent = FirebaseFirestore.instance.collection("agent");

  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  int count = 0;
  PurchaseModelView purchaseModelView = Get.put(PurchaseModelView());
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController itemtController = TextEditingController();
  Timer? _debounce;
  @override
  void initState() {
    purchaseModelView.fetchPurchaseList();
    super.initState();
  }

  final _globalthreeKey = GlobalKey<FormState>();
  Future<void> showInformationDialog() async {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Form(
                key: _globalthreeKey,
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
                              width: 10,
                            ),
                            const Text(
                              "Dealer",
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
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Name";
                        } else if (value!.isNum) {
                          return "Please Enter Valid Name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: "Dealer Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: mobileNumberController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Mobile Number";
                        } else if (value!.isAlphabetOnly) {
                          return "Please Enter Mobile Number";
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
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: addressController,
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
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: itemtController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter amount';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: "Item",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_globalthreeKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')));
                            FirebaseFirestore.instance.collection("agent").add({
                              "name": nameController.text,
                              "mobile_number":
                                  int.parse(mobileNumberController.text),
                              "address": addressController.text,
                              "item": itemtController.text,
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Add Customer'))
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
        title: const Text("Purchase Menu"),
        actions: [
          Center(
            child: InkWell(
              onTap: () async {
                await showInformationDialog();
              },
              child: Text(
                "Add Dealer",
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
                prefixIcon: Icon(
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
                  purchaseModelView.SearchPurchaseUser(
                      val.capitalizeFirst.toString());
                });
              },
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Expanded(
              child: Obx(() => ListView.builder(
                  itemCount: purchaseModelView.getPurchaseModel.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(purchaseModelView.getPurchaseModel[index].name
                          .toString()),
                      subtitle: Text(purchaseModelView
                          .getPurchaseModel[index].mobileNumber
                          .toString()),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => agent(
                                  name: purchaseModelView
                                      .getPurchaseModel[index].name,
                                )));
                      },
                    );
                  })))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          await showInformationDialog();
        } ,
        elevation: 10,
        child: Icon(Icons.add),
      ),
    );
  }
}
