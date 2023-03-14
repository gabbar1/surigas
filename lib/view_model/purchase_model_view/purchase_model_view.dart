import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:surigas/model/purchase_model/purchase_model.dart';

import '../../model/stock/stock_model.dart';

class PurchaseModelView extends GetxController{
  var colorIndex = 0.obs;
  int get getColorIndex => colorIndex.value;
  setColorIndex(int val){
    colorIndex.value=val;
    colorIndex.refresh();
  }
var purchaseModel = <PurchaseModel>[].obs;
  List<PurchaseModel> get getPurchaseModel => purchaseModel.value;
  setPurchaseModel(PurchaseModel val) {
    purchaseModel.value.add(val);
    purchaseModel.refresh();
  }
  fetchPurchaseList(){
    purchaseModel.value.clear();
    purchaseModel.refresh();
    FirebaseFirestore.instance.collection("agent").get().then((value) {
      if(value.docs.isNotEmpty){
        value.docs.forEach((element) {
          PurchaseModel purchaseModel = PurchaseModel.fromJson(element.data());
          purchaseModel.key = element.id;
          setPurchaseModel(purchaseModel);
        });
      }
    });
  }

  SearchPurchaseUser(String query){
    purchaseModel.value.clear();
    purchaseModel.refresh();
    FirebaseFirestore.instance.collection("agent").where("name" ,isGreaterThanOrEqualTo: query).where("name" ,isLessThan: query+"z").get().then((value){
      if(value.docs.isNotEmpty){

        value.docs.forEach((element) {
          PurchaseModel purchaseModel = PurchaseModel.fromJson(element.data());
          purchaseModel.key = element.id;
          setPurchaseModel(purchaseModel);
        });
      }
    });
  }
  
  addPurchase(
      {String? key,
        String? productName,
        String? fullCylinder,
        String? emptyCylinder,
        String? totalAmount,
        Timestamp? orderDate,
        String? rate}){
    FirebaseFirestore.instance.collection("agent").doc(key).collection("purchase_history").add({
      "order_date":orderDate,
      "order_update_date":orderDate,
      "order_type":productName,
      "payment_status":"pending",
      "full_cylinder":fullCylinder,
      "empty_cylinder":emptyCylinder,
      "total_amount":totalAmount,
      "rate":rate
    }).then((value) => Navigator.pop(Get.context!));
  }

  fetchPurchaseDue(
      {String? key, name, fullCylinder, emptyCylinder, totalAmount, rate,Timestamp? orderDate}){
    FirebaseFirestore.instance.collection("agent").doc(key).collection("purchaseDue").doc(name).get().then((value) {
      if(value.exists){
        StockModel stockModel = StockModel.fromJson(value.data()!);
        FirebaseFirestore.instance.collection("agent").doc(key).collection("purchaseDue").doc(name).set(
            {
              "pending_cylinder":int.parse(((stockModel.pendingCylinder!+int.parse(fullCylinder)).toString().replaceAll("-", ""))),
              "empty_cylinder":int.parse(((stockModel.emptyCylinder!+int.parse(emptyCylinder)).toString().replaceAll("-", ""))),
            });
      }else{
        FirebaseFirestore.instance.collection("agent").doc(key).collection("purchaseDue").doc(name).set(
            {



              "pending_cylinder":int.parse(fullCylinder),
              "empty_cylinder":int.parse(emptyCylinder),
            });
      }
    });

    FirebaseFirestore.instance.collection("stock").doc(name).get().then((value) {
      if(value.exists){
        StockModel stockModel = StockModel.fromJson(value.data()!);
        FirebaseFirestore.instance.collection("stock").doc(name).set(
            {
              "pending_cylinder":stockModel.pendingCylinder!+int.parse(fullCylinder),
              "empty_cylinder":stockModel.emptyCylinder!-int.parse(emptyCylinder),
            });
      }else{
        FirebaseFirestore.instance.collection("stock").doc(name).set(
            {
              "pending_cylinder":int.parse(fullCylinder),
              "empty_cylinder":int.parse(emptyCylinder),
            });
      }
    });
    addPurchase(totalAmount: totalAmount,rate: rate,productName: name,fullCylinder: fullCylinder,emptyCylinder: emptyCylinder,key: key,orderDate: orderDate);
  }


  var purchaseDate = "Pick a Date".obs;
  String get getPurchaseDate => purchaseDate.value;
  set setPurchaseDate (String val){
    purchaseDate.value=val;
    purchaseDate.refresh();
  }

}