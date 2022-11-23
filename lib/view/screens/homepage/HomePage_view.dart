import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:surigas/view/screens/expanse_page/expanse_view.dart';
import 'package:surigas/view/screens/login/register_form.dart';
import 'package:surigas/view/screens/purchase_page/purchase_view.dart';
import 'package:surigas/view/screens/salespage/sales_view.dart';

import '../product_list_page/product_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    FirebaseFirestore.instance.collection("client").where("mobile_number",isEqualTo: int.parse(FirebaseAuth.instance.currentUser!.phoneNumber!.replaceAll("+91",""))).get().then((value) {
      if(value.docs.isEmpty){
        Get.off(RegisterForm());
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [IconButton(onPressed: (){
        FirebaseAuth.instance.signOut();
      }, icon: Icon(Icons.logout))]),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Wrap(
                  spacing: 20.0,
                  runSpacing: 20.0,
                  children: [
                    InkWell(
                    onTap: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => Sales()));
              },
                    child:SizedBox(
                      width: 162.0,
                      height: 115.0,
                      child: Card(
                        color: Color(0xFFE5F1F8),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                  "assets/images/ri-user-2-fill.svg"),
                              Center(
                                child: Text(
                                  "Sales",
                                  style: TextStyle(
                                    color: Color(0xFF0077B5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),),
                    SizedBox(
                      width: 162.0,
                      height: 115.0,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Purchase()));
                        },
                        child: Card(
                          color: Color(0xFFF8EAE5),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                    "assets/images/ri-git-repository-private-fill.svg"),
                                Center(
                                  child: Text(
                                    "Purchase",
                                    style: TextStyle(
                                      color: Color(0xFFB55700),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 162.0,
                      height: 115.0,
                      child: Card(
                        color: Color(0xFFF8EAE5),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                  "assets/images/ri-inbox-fill.svg"),
                              Center(
                                child: Text(
                                  "Stock",
                                  style: TextStyle(
                                    color: Color(0xFFB51600),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 162.0,
                      height: 115.0,
                      child: Card(
                        color: Color(0xFF90CAF9),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                  "assets/images/Reportlogo.svg"),
                              Center(
                                child: Text(
                                  "Report",
                                  style: TextStyle(
                                    color: Color(0xFF28B446),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 162.0,
                      height: 115.0,
                      child: InkWell( onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> Expanse()));},
                        child: Card(
                          color: Color(0xFFE5F1F8),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                    "assets/images/ri-ship-2-fill.svg"),
                                Center(
                                  child: Text(
                                    "Expanse",
                                    style: TextStyle(
                                      color: Color(0xFF0077B5),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 162.0,
                      height: 115.0,
                      child: Card(
                        color: Color(0xFF90CAF9),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                  "assets/images/ri-bar-chart-box-fill.svg"),
                              Center(
                                child: Text(
                                  "Profit",
                                  style: TextStyle(
                                    color: Color(0xFF020202),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Get.to(ProductListPage());
      },child: Icon(Icons.add)),
    );
  }


}
