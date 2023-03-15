import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:surigas/model/bank_details.dart';
import 'package:surigas/view/screens/edit_price.dart';
import 'package:surigas/view/screens/salespage/sales_view.dart';
import 'package:surigas/view_model/customer_page_vm/customer_page_vm.dart';
import 'package:surigas/view_model/dashboard_vm/dashboard_vm.dart';
import '../../../model/pending_product_model/pending_product_model.dart';
import '../../../view_model/pending_product_vm/pending_product_vm.dart';
import '../../../view_model/product_list_vm/product_list_vm.dart';
import 'package:url_launcher/url_launcher.dart';

class Customer extends StatefulWidget {
  Customer({
    this.userKey,
    this.name,
    this.mobileNumber,
    this.address,
  });
  final String? name;
  final int? mobileNumber;
  final String? address;
  final String? userKey;

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  var firestoreDB = FirebaseFirestore.instance
      .collection("client")
      .doc()
      .collection("dues")
      .snapshots();
  TextEditingController fullCylinderController = TextEditingController();
  TextEditingController emptyCylinderController = TextEditingController();
  TextEditingController receivedCylinderController = TextEditingController();
  final _globalFistKey = GlobalKey<FormState>();
  final _globalSecondKey = GlobalKey<FormState>();
  CustomerPageVM customerPageVM = Get.put(CustomerPageVM());
  DashboardVM dashboardVM = Get.put(DashboardVM());
  ProductListVM productListVM = Get.put(ProductListVM());
  PendingProductVM pendingProductVM = Get.put(PendingProductVM());

  clearForm() {
    fullCylinderController.clear();
    emptyCylinderController.clear();
    receivedCylinderController.clear();
  }

  Timer? _debounce;

  Future<void> showInformationDialog() async {
    productListVM.fetchClientProductList(widget.userKey!);
    customerPageVM.setIsHideFirstForm = false;
    pendingProductVM.setPendingProductList(PendingProductModel());
    pendingProductVM.setOriginalPrice = 0;
    pendingProductVM.setOriginalCylinder = 0;
    customerPageVM.setColorIndex = 0;
    customerPageVM.setStartDate ="Pick a Date" ;
    DateTime? _startDateTime = DateTime.now();
    clearForm();

    void _showDatePicker() async {
      _startDateTime = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2021),
          lastDate: DateTime.now());
      if (_startDateTime == null) {
        return;
      } else {
          customerPageVM.setStartDate = "${_startDateTime!.day}/${_startDateTime!.month}/${_startDateTime!.year}";

      }
    }

    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (BuildContext context) {
          return Obx(() {
            if (productListVM.getProductList.length == 0) {
              return Container(
                  height: MediaQuery.of(context).size.height - 100,
                  child: Center(child: Text("No data")));
            } else {
              return Padding(
                padding: EdgeInsets.all(15.0),
                child: Obx(() => Column(
                      children: [
                        Row(
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
                                  "Entery",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 20.0),
                                ),
                                SizedBox(
                                  width: 200,
                                ),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(Icons.clear_rounded),
                                      onPressed: () =>
                                    ))
                              ],
                            )
                          ],
                        ),
                        SizedBox(
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
                                        pendingProductVM.setOriginalPrice = 0;
                                        pendingProductVM.setOriginalCylinder =
                                            0;
                                        clearForm();
                                        customerPageVM.setColorIndex = index;
                                        pendingProductVM
                                            .fetchPendingProductList(
                                                widget.userKey.toString(),
                                                productListVM
                                                    .getProductList[index]
                                                    .productName);
                                      },
                                      child: Obx(() => Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: customerPageVM.getColorIndex ==
                                                        index
                                                    ? Colors.blue
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: Color(0xFFD5EAFE))),
                                            child: Center(
                                              child: Text(
                                                productListVM
                                                    .getProductList[index]
                                                    .productName
                                                    .toString(),
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                          ))),
                                );
                              })),
                        ),
                        if (customerPageVM.getIsHideFirstForm != true)
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Obx(() => Row(
                                  children: [
                                    SizedBox(
                                      height: 108.0,
                                      // width: 140.0,
                                      child: Card(
                                        color: Color(0xFFF8EAE5),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                pendingProductVM
                                                    .getOriginalCylinder
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 30.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      "assets/images/CylinderRed.svg"),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "Due Cylinder",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    SizedBox(
                                      height: 108.0,
                                      //width: 140.0,
                                      child: Card(
                                        color: Color(0xFFBBDEFB),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Obx(() => Text(
                                                    pendingProductVM
                                                        .getOriginalPrice
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 30.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                  )),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      "assets/images/CylinderBlue.svg"),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "Due Amount",
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 15),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        InkWell(
                          onTap: _showDatePicker,
                          child: Container(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            height: 60,
                            child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(()=>Text(customerPageVM.getStartDate)),

                                Icon(Icons.arrow_drop_down),
                              ],
                            )),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFF2F2F2),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (customerPageVM.getIsHideFirstForm == false)
                          Form(
                            key: _globalFistKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: fullCylinderController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onChanged: (value) {
                                    pendingProductVM.calculateFullCylinderPrice(
                                        value.isBlank! ? 0 : int.parse(value),
                                        productListVM
                                            .getProductList[
                                                customerPageVM.getColorIndex]
                                            .productPrice!
                                            .toInt());
                                  },
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
                                      hintText: "Full Cylinder",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: emptyCylinderController,
                                  decoration: InputDecoration(
                                      hintText: "Empty Cylinder",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please Enter Empty Cylinder";
                                    } else if (value!.isAlphabetOnly) {
                                      return "Please Enter Valid Number";
                                    } else if (value!.length > 4) {
                                      return "Please Enter Valid Number";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                    onTap: () {
                                      if (_globalFistKey.currentState!
                                          .validate()) {
                                        customerPageVM.setIsHideFirstForm =
                                            true;
                                        pendingProductVM.calculateCylinder(
                                            int.parse(fullCylinderController
                                                .text
                                                .toString()),
                                            int.parse(
                                                emptyCylinderController.text));
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.grey.shade500)),
                                      child: Center(
                                          child: Text(
                                        "Next",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    )),
                              ],
                            ),
                          ),
                        if (customerPageVM.getIsHideFirstForm == true)
                          Form(
                            key: _globalSecondKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Obx(() => Row(
                                        children: [
                                          SizedBox(
                                            height: 108.0,
                                            child: Card(
                                              color: Color(0xFFF8EAE5),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      pendingProductVM
                                                          .getOriginalCylinder
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 30.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            "assets/images/CylinderRed.svg"),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "Due Cylinder",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 15),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                            height: 108.0,
                                            child: Card(
                                              color: Color(0xFFBBDEFB),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      pendingProductVM
                                                          .getOriginalPrice
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 30.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            "assets/images/CylinderBlue.svg"),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "Due Amount",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 15),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  onChanged: (val) {
                                    print(val.runtimeType);

                                    if (_debounce?.isActive ?? false)
                                      _debounce!.cancel();
                                    _debounce = Timer(
                                        const Duration(milliseconds: 1000), () {
                                      // do something with query
                                      pendingProductVM.calculatePendingAmount(
                                          val.isBlank! ? 0 : int.parse(val),
                                          int.parse(
                                              fullCylinderController.text),
                                          productListVM
                                              .getProductList[
                                                  customerPageVM.getColorIndex]
                                              .productPrice!
                                              .toInt());
                                    });
                                  },
                                  controller: receivedCylinderController,
                                  decoration: InputDecoration(
                                      hintText: "Received Amount",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please Enter Valid Amount";
                                    } else if (value!.isAlphabetOnly) {
                                      return "Please Enter Valid Amount";
                                    } //else if (value!.length < 4) {
                                    // return "Please Enter Valid Amount";}
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: InkWell(
                                            onTap: () {
                                              customerPageVM
                                                  .setIsHideFirstForm = false;
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors
                                                          .grey.shade500)),
                                              child:
                                                  Center(child: Text("Back")),
                                            ))),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                        child: InkWell(
                                            onTap: () {
                                              pendingProductVM
                                                  .addDelivery(
                                                      key: widget.userKey,
                                                      pendingMoney: pendingProductVM
                                                          .getOriginalPrice,
                                                      pending: pendingProductVM
                                                          .getOriginalCylinder,
                                                      name: productListVM
                                                          .getProductList[
                                                              customerPageVM
                                                                  .getColorIndex]
                                                          .productName,
                                                      historyModel: HistoryModel(
                                                          date: Timestamp.fromDate(_startDateTime!),
                                                          deliver: int.parse(
                                                              fullCylinderController
                                                                  .text),
                                                          recieved: int.parse(
                                                              emptyCylinderController
                                                                  .text),
                                                          deliveredBy: FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .phoneNumber!
                                                              .replaceAll(
                                                                  "+91", ""),
                                                          deliveredItemCategory:
                                                              productListVM
                                                                  .getProductList[customerPageVM.getColorIndex]
                                                                  .productName
                                                                  .toString(),
                                                          pendingAmount: pendingProductVM.getOriginalPrice,
                                                          recievedAmount: int.parse(receivedCylinderController.text)))
                                                  .then((value) {
                                                pendingProductVM
                                                    .fetchHistoryList(
                                                        widget.userKey!);
                                              });
                                              if (_globalSecondKey.currentState!
                                                  .validate()) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Data Added')));
                                                customerPageVM
                                                    .setIsHideFirstForm = true;
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors
                                                          .grey.shade500)),
                                              child: Center(
                                                  child: Text(
                                                "Submit",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ))),
                                  ],
                                )
                              ],

                            ),
                          ),
                      ],
                    )),
              );
            }
          });
        });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Edit Amount':
        Get.to(EditPrice());
        break;
      case 'Remove Customer':
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    pendingProductVM.fetchHistoryList(widget.userKey!);
    pendingProductVM.fetchDueList(widget.userKey!);
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
        actions: [
          if(dashboardVM.getUserDetails.isDealder==true)
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Edit Amount', 'Remove Customer'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Contact",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10.0,
                ),
                const Text(
                  "Details",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () => launch("tel:${widget.mobileNumber.toString()}"),
                  child: Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Direct Call"),
                    Text(widget.mobileNumber.toString())
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Icon(
                  Icons.message,
                  color: Colors.blue,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Direct Message"),
                    Text(widget.mobileNumber.toString())
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.person_pin_circle,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Google Map"),
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            child: Text(widget.address.toString())),
                      ],
                    ),
                  ],
                ),
                Image(image: AssetImage("assets/images/GoogleMapLogo.png"))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 108.0,
                  // width: 140.0,
                  child: Card(
                    color: Color(0xFFF8EAE5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => Text(
                                pendingProductVM.getTotalDueCylinder.toString(),
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              )),
                          Row(
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              SvgPicture.asset("assets/images/CylinderRed.svg"),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Due Cylinder",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 15),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 108.0,
                  //width: 140.0,
                  child: Card(
                    color: Color(0xFFBBDEFB),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => Text(
                                pendingProductVM.getTotalDuePrice.toString(),
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              )),
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              SvgPicture.asset("assets/images/rupee.svg",
                                  height: 30),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Due Amount",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 15),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Delivered",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Cylinder",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blue),
                          ),
                        ],
                      ),
                      Text(
                        "Download All",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Obx(() => Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ListView.builder(
                    itemCount: pendingProductVM.getHistoryList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(pendingProductVM.getHistoryList[index]!.deliveredItemCategory!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                  Text(pendingProductVM.getHistoryList[index]!.recievedAmount.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ],
                              ),
                                  Row(
                                    children: [
                                      Text("Full Cylinder"),
                                      SizedBox(width: 28,),
                                      Text(pendingProductVM.getHistoryList[index]!.deliver.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Empty Cylinder"),
                                      SizedBox(width: 10,),
                                      Text(pendingProductVM.getHistoryList[index]!.recieved.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                    ],
                                  ),
                              Text(DateTime.parse(pendingProductVM.getHistoryList[index]!.date!.toDate().toString()).toString()),
                              SizedBox(
                                height: 15,
                              ),
                              Divider()
                            ]),
                      );
                    },
                  ),
                )))
           ],
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showInformationDialog();
        },
        child: Icon(Icons.add),
      ),

    );
  }
}
