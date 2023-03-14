import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:surigas/view/pemding_amount_list/pending_amount_list_view.dart';
import 'package:surigas/view/screens/expanse_page/expanse_view.dart';
import 'package:surigas/view/screens/login/register_form.dart';
import 'package:surigas/view/screens/my_team_page/my_team_view.dart';
import 'package:surigas/view/screens/purchase_page/purchase_view.dart';
import 'package:surigas/view/screens/salespage/sales_view.dart';
import 'package:surigas/view/screens/stock_page/stock_view.dart';
import 'package:surigas/view_model/dashboard_vm/dashboard_vm.dart';

import '../product_list_page/product_list_page.dart';

class HomePage extends StatefulWidget {
  HomePage({
    this.userKey,
    this.name,
  });
  final String? userKey;
  final String? name;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DashboardVM dashboardVM = Get.put(DashboardVM());
  @override
  void initState() {
    // TODO: implement initState
    dashboardVM.fetchUserDetails();
    dashboardVM.fetchTotalStock();
    dashboardVM.fetchTodaySales();
    dashboardVM.fetchPendingAmount();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: Obx(() => Text(dashboardVM.getUserDetails.name.toString())),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.logout)),
          ]),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 340,
                    height: 94,
                    child: Card(
                      color: Color(0xFFF2F8FB),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          SvgPicture.asset("assets/images/today_sale.svg"),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(()=>Text(
                                dashboardVM.getTodaySalesList.isEmpty?"0": dashboardVM.getTodaySalesList.reduce((value, element) => value+element).toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              )),
                              Text(
                                "Today sale",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 20),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 340,
                    height: 94,
                    child: Card(
                      color: Color(0xFFF2F2F2),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          SvgPicture.asset(
                              "assets/images/today_collection.svg"),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(()=>Text(
                                dashboardVM.getTodayCollectionList.isEmpty?"0":  dashboardVM.getTodayCollectionList.reduce((value, element) => value+element).toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              )),
                              Text(
                                "Today collection",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 20),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 340,
                    height: 94,
                    child: Card(
                      color: Color(0xFFFBF3F2),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          SvgPicture.asset("assets/images/cylinder.svg"),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(()=>Text(
                    dashboardVM.getEmptyStockList.isEmpty ? "0": dashboardVM.getEmptyStockList.reduce((value, element) => value+element).toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.red),
                              )),

                              Text(
                                "Empty bottle stock",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 340,
                    height: 94,
                    child: Card(
                      color: Color(0xFFF4FBF6),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          SvgPicture.asset("assets/images/stock.svg"),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(()=>Text(
                    dashboardVM.getAvailableStockList.isEmpty ? "0": dashboardVM.getAvailableStockList.reduce((value, element) => value+element).toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              )),
                              Text(
                                "Available stock",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Get.to(PendingAmountList());
                    },
                    child: SizedBox(
                      width: 340,
                      height: 94,
                      child: Card(
                        color: Color(0xFFFEF7E9),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            SvgPicture.asset("assets/images/rupee.svg"),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               Obx(() => Text(
                      dashboardVM.getPendingAmount.isEmpty ? "0": dashboardVM.getPendingAmount.reduce((value, element) => value+element).toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 25),
                                )),
                                Text(
                                  "Padding amount",
                                  style: TextStyle(
                                      color: Colors.yellow, fontSize: 20),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      /*child: ListView(
          children: [
           Column(
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
                      child:Row(
                        children: [
                          SizedBox(
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
                          ),
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
                        ],
                      ),),

                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Stock()));
                        },
                        child: Row(
                          children: [
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
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyTeam()));
                              },
                              child: SizedBox(
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
                            ),
                          ],
                        ),
                      ),

                      Row(
                        children: [
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
                    ],
                  ),
                ),
              ),
            ],
          ),],
        ),*/
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(dashboardVM.getUserDetails.isDealder==true)
              Get.to(ProductListPage());
            //FirebaseFirestore.instance.collection("client").get().then((value) {
            // value.docs.forEach((element) {
            //  print("==================collection=============");
            //print(element.id);
            //  print(element.data());
            // });
            // });
            //FirebaseFirestore.instance.collection("client").doc("dA0nUKd3AYM5YsIh61zp").get().then((value) {
            //print("==================document=============");
            // print(value.id);
            //  print(value.data());
            // });
          },
          child: Icon(Icons.add)),
    );
  }
}
