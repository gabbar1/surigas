import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surigas/view/screens/expanse_page/expanse_view.dart';
import 'package:surigas/view/screens/homepage/HomePage_view.dart';
import 'package:surigas/view/screens/login/register_form.dart';
import 'package:surigas/view/screens/login/user_access.dart';
import 'package:surigas/view/screens/my_team_page/my_team_view.dart';
import 'package:surigas/view/screens/purchase_page/purchase_view.dart';
import 'package:surigas/view/screens/salespage/sales_view.dart';
import 'package:surigas/view/screens/stock_page/stock_view.dart';
import 'package:surigas/view_model/customer_page_vm/customer_page_vm.dart';
import 'package:surigas/view_model/dashboard_vm/dashboard_vm.dart';
import 'package:upgrader/upgrader.dart';
import '../../../../model/auth/register_form.dart';

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({Key? key}) : super(key: key);

  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}
Widget pages(int _currentIndex){
  switch (_currentIndex){
    case 0 : return HomePage();
    case 1 : return Sales();
    case 2 : return Purchase();
    case 3 : return Stock();
    case 4 : return Expanse();
    case 5 : return MyTeam();
    default : return HomePage();
  }
  }
int _currentIndex=0;
//final bool? isDealder = false ;


class _HomeNavigatorState extends State<HomeNavigator> {
  DashboardVM dashboardVM = Get.put(DashboardVM());
  @override
  void initState() {
    // TODO: implement initState
    UpgradeAlert(
        child: Scaffold(
          appBar: AppBar(title: Text('Upgrader Example')),
          body: Center(child: Text('Checking...')),
        ));
    FirebaseFirestore.instance.collection("dealer").where("mobile_number", isEqualTo: int.parse(FirebaseAuth.instance.currentUser!.phoneNumber!.replaceAll("+91", ""))).get().then((value) {
      if (value.docs.isEmpty) {
        Get.off(RegisterForm());
      }
      else{
        print("============================CheckUser details==================");
          dashboardVM.fetchUserDetails();
          RegisterFormModel registerFormModel = RegisterFormModel.fromJson( value.docs.first.data());
          if(registerFormModel.isEnabled !=true){
            Get.to(UserAccess());
          }
       
       
      }
    });
    super.initState();
  }

  @override
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop:()async{
        if(_currentIndex!=0){
          setState(() {
            _currentIndex =  0;
          });
         return await false;
        }else{
          return await true;
        }
      } ,
      child: Obx(()=>Scaffold(
        body: pages(_currentIndex),
        bottomNavigationBar:BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _onTap,
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.blue,
          selectedFontSize: 13,
          unselectedFontSize: 13,
          iconSize: 40,
          items: [
            BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/home.png")), label: "Home",),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/sales.png")), label: "Sales",),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/purchase.png")), label: "Purchase"),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/stock.png")), label: "Stock"),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/report.png")), label: "Expanse"),
           if(dashboardVM.getUserDetails.isDealder==true) BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/more.png")), label: "My Team"),
          ],
        ),
      )),
    );

  }
}
