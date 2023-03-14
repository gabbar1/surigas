import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../model/bank_details.dart';
import '../../model/pending_product_model/pending_product_model.dart';
import '../../model/sales_model/sales_model.dart';

class PendingProductVM extends GetxController{

    var pendingProductModel = PendingProductModel().obs;
    PendingProductModel get getPendingProductModel => pendingProductModel.value;
    setPendingProductList(PendingProductModel val) {
        pendingProductModel.value = val;
        pendingProductModel.refresh();
    }
    fetchPendingProductList(String key,name) async{
        FirebaseFirestore.instance.collection("client").doc(key).collection("dues").doc(name).get().then((value) {
            if(value.exists){
                print(value.data());
                PendingProductModel pendingProductModel = PendingProductModel.fromJson(value.data()!);
                setPendingProductList(pendingProductModel);
                setOriginalPrice = pendingProductModel.pendingMoney!;
                setOriginalCylinder = pendingProductModel.pendingCylinder!;
            }
        });
    }

    var originalPrice = 0.obs;
    int get getOriginalPrice => originalPrice.value;
    set setOriginalPrice(int val){
        originalPrice.value = val;
        originalPrice.refresh();
    }
    var originalCylinder = 0.obs;
    int get getOriginalCylinder => originalCylinder.value;
    set setOriginalCylinder(int val){
        originalCylinder.value = val;
        originalCylinder.refresh();
    }
    calculatePendingAmount(int price,int receivedCylinder,int receivedCylinderPrice){
        print("==============insert-------------");
        print(price);
        setOriginalPrice = getPendingProductModel.pendingMoney==null? receivedCylinder*receivedCylinderPrice: getPendingProductModel.pendingMoney!+(receivedCylinder*receivedCylinderPrice);
        if(price.isNullOrBlank!){

        }else{
            int cylinder =(getOriginalPrice) - price;
            print(cylinder);
            if(cylinder<=-1){
                setOriginalPrice = 0;
            }else{
                setOriginalPrice = cylinder;
            }
            print(getOriginalPrice);
        }
       // PendingProductModel pendingProductModel = PendingProductModel(key: getPendingProductModel.key,pendingCylinder: getPendingProductModel.pendingCylinder);


    }
    calculateCylinder(int full,int empty){

        setOriginalCylinder = getPendingProductModel.pendingCylinder==null ? 0:getPendingProductModel.pendingCylinder!;
        int cylinder =(getOriginalCylinder)! +full-empty;
        if(cylinder<=-1){
            setOriginalCylinder = 0;
        }else{
            setOriginalCylinder = cylinder;
        }
        print(cylinder);

    }
    calculateFullCylinderPrice(int cylinder,int cylinderPrice){
        setOriginalPrice = getPendingProductModel.pendingMoney==null? 0: getPendingProductModel.pendingMoney!;
        setOriginalPrice = getOriginalPrice + cylinder*cylinderPrice;
    }

    Future<void>addDelivery(
        {String? key,
      name,
      int? pending,
      pendingMoney,
      HistoryModel? historyModel}) async{
        print("=====================key==========================");
        print(key);
        FirebaseFirestore.instance.collection("client").doc(key).collection("dues").doc(name).set({
            "pending":pending,
            "pending_money":pendingMoney
        }, SetOptions(merge: true));
        FirebaseFirestore.instance.collection("client").doc(key).collection("history").add(historyModel!.toJson());
        stockUpdate(name, historyModel.deliver!, historyModel.recieved!);
    }


    stockUpdate(String name,int fullCylinder,int emptyCylinder){
        FirebaseFirestore.instance.collection("stock").doc(name).get().then((value) {
           if(value.exists){
               print("================value.get()===================");
               print(name);
               print(value.data());
               print(value.get("pending_cylinder"));
               FirebaseFirestore.instance.collection("stock").doc(name).update({
                  "pending_cylinder":value.get("pending_cylinder")-fullCylinder,
                  "empty_cylinder":value.get("empty_cylinder")+emptyCylinder,
               });
           }else{
               FirebaseFirestore.instance.collection("stock").doc(name).set({
                   "pending_cylinder":fullCylinder,
                   "empty_cylinder":emptyCylinder,
               });
           }
        });
    }

    var historyList = <HistoryModel>[].obs;
    List<HistoryModel> get getHistoryList => historyList.value;
    set setHistoryList(HistoryModel val){
        historyList.value.add(val);
        historyList.refresh();
    }

    fetchHistoryList(String key){
        historyList.clear();
        FirebaseFirestore.instance.collection("client").doc(key).collection("history").get().then((value) {
           if(value.size!=0){
               value.docs.forEach((element) {
                   HistoryModel historyModel = HistoryModel.fromJson(element.data());
                   historyModel.key = element.id;
                   setHistoryList = historyModel;
               });
           }
        });
    }

    var totalDuePriceList = <int>[].obs;
    List<int> get getTotalDuePriceList => totalDuePriceList.value;
    var totalDueCylinderList = <int>[].obs;
    List<int> get getTotalDueCylinderList => totalDueCylinderList.value;
     setTotalDueList(int price, int amount){
         totalDuePriceList.value.add(price);
         totalDuePriceList.refresh();
         totalDueCylinderList.value.add(amount);
         totalDueCylinderList.refresh();
    }

    var totalDuePrice = 0.obs;
    int get getTotalDuePrice => totalDuePrice.value;
    var totalDueCylinder = 0.obs;
    int get getTotalDueCylinder => totalDueCylinder.value;
    setTotalDue(int price, int amount){
        totalDuePrice.value= price;
        totalDuePrice.refresh();
        totalDueCylinder.value = amount;
        totalDueCylinder.refresh();
    }
    fetchDueList(String userKey){
        totalDuePriceList.clear();
        totalDueCylinderList.clear();
        totalDuePrice.value = 0;
        totalDueCylinder.value =0;
        FirebaseFirestore.instance.collection("client").doc(userKey).collection("dues").get().then((value) {
            print("===================size==================");
            print(value.size);
            value.docs.forEach((element) {
                print(element.data());
                PendingProductModel pendingProductModel = PendingProductModel.fromJson(element.data());
                pendingProductModel.key = element.id;
                print(pendingProductModel.pendingCylinder);
                print(pendingProductModel.pendingMoney);
                setTotalDueList(pendingProductModel.pendingMoney==null?0:pendingProductModel.pendingMoney!,pendingProductModel.pendingCylinder==null ?0:pendingProductModel.pendingCylinder!);
                print(jsonEncode(getTotalDueCylinderList));
                setTotalDue(getTotalDuePriceList.reduce((value, element) => value+element),getTotalDueCylinderList.reduce((value, element) => value+element));
            });
        });
    }

}