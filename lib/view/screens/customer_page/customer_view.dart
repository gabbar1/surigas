import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:surigas/view/screens/salespage/sales_view.dart';
import 'package:surigas/view_model/customer_page_vm/customer_page_vm.dart';

class Customer extends StatefulWidget {
  Customer({Key? key, this.name, this.mobileNumber, this.address})
      : super(key: key);
  final String? name;
  final int? mobileNumber;
  final String? address;
  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  TextEditingController fullCylinderController = TextEditingController();
  TextEditingController emptyCylinderController = TextEditingController();
  TextEditingController receivedCylinderController = TextEditingController();
  final _globalFistKey = GlobalKey<FormState>();
  final _globalSecondKey = GlobalKey<FormState>();
  CustomerPageVM customerPageVM = Get.put(CustomerPageVM());
  Future<void> showInformationDialog() async {
    return showModalBottomSheet(
      isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.all(15.0),
            child: Obx(()=>Column(
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
                          style:
                          TextStyle(color: Colors.blue, fontSize: 20.0),
                        ),
                        SizedBox(
                          width: 230,
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(Icons.clear_rounded),
                              onPressed: () => Navigator.of(context).pop(),
                            ))
                      ],
                    )
                  ],
                ),
                if(customerPageVM.getIsHideFirstForm==false)
                Form(
                  key: _globalFistKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: fullCylinderController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Cylinder';
                          } else if (value!.isAlphabetOnly) {
                            return "Please Enter Valid Number";
                          } else if (value!.length > 4) {
                            return "Please Enter Valid Number";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Full Cylinder",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: emptyCylinderController,
                        decoration: InputDecoration(
                            hintText: "Empty Cylinder",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      SizedBox(height: 10,),
                      InkWell(
                          onTap: () {
                            if(_globalFistKey.currentState!.validate()){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                              customerPageVM.setIsHideFirstForm = true;
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
                            child: Center(child: Text("Next",style: TextStyle(color: Colors.white),)),
                          )),
                    ],
                  ),
                ),
                if(customerPageVM.getIsHideFirstForm==true)
                Form(
                  key: _globalSecondKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 108.0,
                              width: 160.0,
                              child: Card(
                                color: Color(0xFFF8EAE5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "20",
                                      style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
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
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              height: 108.0,
                              width: 160.0,
                              child: Card(
                                color: Color(0xFFBBDEFB),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "1220",
                                      style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 25,
                                        ),
                                        SvgPicture.asset(
                                            "assets/images/CylinderBlue.svg"),
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
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: receivedCylinderController,
                        decoration: InputDecoration(
                            hintText: "Received Amount",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(
                              child: InkWell(
                                  onTap: () {

                                      customerPageVM.setIsHideFirstForm = false;

                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey.shade500)),
                                    child: Center(child: Text("Back")),
                                  ))),
                          SizedBox(width: 20,),
                          Expanded(
                              child: InkWell(
                                  onTap: () {
                                    if(_globalSecondKey.currentState!.validate()){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Added')));
                                      customerPageVM.setIsHideFirstForm = true;
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
                                            color: Colors.grey.shade500)),
                                    child: Center(child: Text("Submit",style: TextStyle(color: Colors.white),)),
                                  ))),

                        ],
                      )
                    ],
                  ),
                ),
              ],
            )),
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
        title: Text(widget.name.toString()),
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
                )
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Icon(
                  Icons.call,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("direct call"),
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
                    const Text("direct Message"),
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
                        const Text("Google map"),
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
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  SizedBox(
                    height: 108.0,
                    width: 160.0,
                    child: Card(
                      color: Color(0xFFF8EAE5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "20",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
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
                  SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 108.0,
                    width: 160.0,
                    child: Card(
                      color: Color(0xFFBBDEFB),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "1220",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              SvgPicture.asset(
                                  "assets/images/CylinderBlue.svg"),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
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
            )
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
