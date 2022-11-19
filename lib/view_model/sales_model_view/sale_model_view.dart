import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:surigas/model/sales_model/sales_model.dart';

class SalesModelView extends GetxController{

  var salesModel = <SalesModel>[].obs;
  List<SalesModel> get getSalesModel => salesModel.value;

  setSalesModel(SalesModel val){
    salesModel.value.add(val);
    salesModel.refresh();
  }

  fetchSalesList() {
    salesModel.value.clear();
    salesModel.refresh();
    FirebaseFirestore.instance.collection("client").get().then((value) {
      if(value.docs.isNotEmpty){
        value.docs.forEach((element) {
          SalesModel salesModel = SalesModel.fromJson(  element.data());
          setSalesModel(salesModel);

        });

      }
    });
  }
  
  searchSalesUSer(String query){
    salesModel.value.clear();
    salesModel.refresh();
    FirebaseFirestore.instance.collection("client").where("name",isGreaterThanOrEqualTo: query).where("name",isLessThan: query+"z").get().then((value) {
      if(value.docs.isNotEmpty){
        value.docs.forEach((element) {
          SalesModel salesModel = SalesModel.fromJson(  element.data());
          setSalesModel(salesModel);
        });
      }
    });
  }

}