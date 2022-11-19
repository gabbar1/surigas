import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:surigas/model/purchase_model/purchase_model.dart';

class PurchaseModelView extends GetxController{
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
          setPurchaseModel(purchaseModel);
        });
      }
    });
  }
}