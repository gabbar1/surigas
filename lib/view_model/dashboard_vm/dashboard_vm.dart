import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:surigas/model/pending_product_model/pending_product_model.dart';

import '../../model/bank_details.dart';
import '../../model/stock/stock_model.dart';
import '../../model/user_model/user_model.dart';

class DashboardVM extends GetxController{

  var userDetails = UserDetailsModel().obs;
  UserDetailsModel get getUserDetails => userDetails.value;
  set setUserDetails(UserDetailsModel val){
    userDetails.value = val;
    userDetails.refresh();
  }
  
  fetchUserDetails(){
    print("=================fetch============");
    print(FirebaseAuth.instance.currentUser!.phoneNumber!.replaceAll("+91", ""));
    FirebaseFirestore.instance.collection("dealer").where("mobile_number",isEqualTo: int.parse(FirebaseAuth.instance.currentUser!.phoneNumber!.replaceAll("+91", ""))).get().then((value) {
      if(value.size!=0){
        print(value.docs);
        UserDetailsModel userDetailsModel = UserDetailsModel.fromJson(value.docs.first.data());
        userDetailsModel.key = value.docs.first.id;
        setUserDetails = userDetailsModel;
      }
    });
  }
  var availableStockList = <int>[].obs;
  List<int> get getAvailableStockList => availableStockList.value;
  var emptyStockList = <int>[].obs;
  List<int> get getEmptyStockList => emptyStockList.value;
   setStockList(int available,int empty  ){
    availableStockList.add(available);
    emptyStockList.add(empty);
    availableStockList.refresh();
    emptyStockList.refresh();
  }
  fetchTotalStock(){
    availableStockList.clear();
    emptyStockList.clear();
    FirebaseFirestore.instance.collection("stock").get().then((value) {
      value.docs.forEach((element) {
        StockModel stockModel = StockModel.fromJson(element.data());
        setStockList(stockModel.pendingCylinder!,stockModel.emptyCylinder!);
      });

    });
  }
  var pendingAmount = <int>[].obs;
  List<int> get getPendingAmount => pendingAmount.value;
  var pendingAmountList = <PendingProductModel>[].obs;
  List<PendingProductModel> get getPendingAmountList => pendingAmountList.value;
  setPendingAmountList(int pending,PendingProductModel val){
    pendingAmount.add(pending);
    pendingAmountList.add(val);
    pendingAmount.refresh();
    pendingAmountList.refresh();
  }
  fetchPendingAmount(){
    pendingAmount.clear();
    pendingAmountList.clear();
    FirebaseFirestore.instance.collection("client").get().then((value) {
      value.docs.forEach((element) {
        print("=======================getPendingAmountList====================");
        print(element.data());
        FirebaseFirestore.instance.collection("client").doc(element.id).collection("dues").get().then((value1) {
          value1.docs.forEach((element1){
            PendingProductModel pendingProductModel = PendingProductModel.fromJson(element1.data());
            pendingProductModel.key = element.get("name");
            setPendingAmountList(pendingProductModel.pendingMoney!,pendingProductModel);
          });
        });
      });
    });

  }
  var todaySalesList = <int>[].obs;
  List<int> get getTodaySalesList => todaySalesList.value;
  var todayCollectionList = <int>[].obs;
  List<int> get getTodayCollectionList => todayCollectionList.value;
  setSalesList(int sales,int collection){
    todaySalesList.add(sales);
    todayCollectionList.add(collection);
    todaySalesList.refresh();
    todayCollectionList.refresh();
  }
  fetchTodaySales(){
    todaySalesList.clear();
    todayCollectionList.clear();
     FirebaseFirestore.instance.collection("client").get().then((value) {
       print("==========================client-------------------");

       value.docs.forEach((element) {
         print("===================id================");
         print(element.id);
         FirebaseFirestore.instance.collection("client").doc(element.id).collection("history").where("date",isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))).get().then((value) {
           value.docs.forEach((element) {
             print("=========================date======================");
             print(element.id);
             HistoryModel historyModel = HistoryModel.fromJson(element.data());
             setSalesList(historyModel.deliver!, historyModel.recievedAmount!,);
           });
         });
       });
     });
  }
}