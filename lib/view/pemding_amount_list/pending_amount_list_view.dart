import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surigas/view/screens/stock_page/stock_view.dart';
import 'package:surigas/view_model/dashboard_vm/dashboard_vm.dart';
import 'package:surigas/view_model/pending_product_vm/pending_product_vm.dart';
import 'package:surigas/view_model/product_list_vm/product_list_vm.dart';
import 'package:surigas/view_model/sales_model_view/sale_model_view.dart';

import '../screens/customer_page/customer_view.dart';


class PendingAmountList extends StatefulWidget {
  const PendingAmountList({Key? key}) : super(key: key);

  @override
  State<PendingAmountList> createState() => _PendingAmountListState();
}

class _PendingAmountListState extends State<PendingAmountList> {
  PendingProductVM pendingProductVM = Get.put(PendingProductVM());
  SalesModelView salesModelView = Get.put(SalesModelView());
  ProductListVM productListVM = Get.put(ProductListVM());
  DashboardVM dashboardVM = Get.put(DashboardVM());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("PendingAmountList"),
      ),
      body: Obx(()=>ListView.separated(
        shrinkWrap: true,
          itemCount: dashboardVM.getPendingAmountList.length,
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (context, index){
            return  Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        // onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=> ));},
                        title:
                   Text(dashboardVM.getPendingAmountList[index]!.key.toString(),style: TextStyle(fontSize: 20),),
                   // Icon(Icons.arrow_forward_outlined),
                   subtitle: Text(dashboardVM.getPendingAmountList[index]!.pendingMoney.toString(),style: TextStyle(fontSize: 20),),),



                    ),
                  ],
                ),

            );
          }
          )),
    );
  }
}
