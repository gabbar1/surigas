import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/product_price_model/product_price_model.dart';
import '../../model/purchase_model/puchase_history_model.dart';
import '../../utils/loader.dart';
import '../pending_product_vm/pending_product_vm.dart';

class ProductListVM extends GetxController{

  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  var isCheck =false.obs;
  bool get getIsCheck => isCheck.value;
  set setIsCheck(bool val){
    isCheck.value = val;
    isCheck.refresh();
  }
  var productList = <ProductPriceModel>[].obs;
  List<ProductPriceModel> get getProductList => productList.value;
  set setProductList(ProductPriceModel val){
    productList.value.add(val);
    productList.refresh();

  }

  Future<void>addProduct(String name,num price) async{
    showLoader();
    FirebaseFirestore.instance.collection("products").where("product_name",isEqualTo: name).get().then((value) {
      if(value.size!=0){
        closeLoader();
        Get.snackbar("Alert", "This Product is already there!!");
      }else{
        FirebaseFirestore.instance.collection("products").add({
          "product_name":name,
          "product_price":price,
          "isReplaceable":getIsCheck
        }).then((value) {
          closeLoader();
          fetchProductList(false);
          Navigator.pop(Get.context!);
        }).onError((error, stackTrace) {
          closeLoader();
        });
      }
    });
  }
  Future<void>editProduct(String key,num price) async{
    showLoader();
    FirebaseFirestore.instance.collection("products").doc(key)
        .update({
    "product_price":price,
    "isReplaceable":getIsCheck
    }).then((value) {
    closeLoader();
    fetchProductList(false);
    Navigator.pop(Get.context!);
    }).onError((error, stackTrace) {
    closeLoader();
    });

  }
  Future<void>fetchProductList(bool isInit,{String? key}) async{
    print("=================key============");
    print(key);
    productList.clear();
    FirebaseFirestore.instance.collection("products").get().then((value) {
      if(value.size!=0){

        value.docs.forEach((element) {
          print("===============products");
          print(element.data());
          ProductPriceModel productPriceModel =  ProductPriceModel.fromJson(element.data());
          productPriceModel.key = element.id;
          setProductList = productPriceModel;


          print(jsonEncode(getProductList));
        });
        if(isInit == true){
          setShowLoader =true;
          fetchPurchaseHistory(key!,getProductList[0].productName);
        }
      }
    });
  }
  PendingProductVM pendingProductVM = Get.put(PendingProductVM());
  Future<void>fetchClientProductList(String key) async{
    print("======================fetch=");
    print(key);
    productList.clear();
    FirebaseFirestore.instance.collection("client").doc(key).collection("products").get().then((value) {
      print("====================TToB8TJlDnyb0nAqAeGV========;");
      print(value);
      if(value.size!=0){
        value.docs.forEach((element) async{
          print(element.data());
          ProductPriceModel productPriceModel =  ProductPriceModel.fromJson(element.data());
          productPriceModel.key = element.id;
          setProductList = productPriceModel;
         await pendingProductVM.fetchPendingProductList(
              key,
              getProductList[0].productName);

          print(jsonEncode(getProductList));
        });
      }
    });
  }

  var clientProductPrice = ProductPriceModel().obs;
  ProductPriceModel get getClientProductPrice => clientProductPrice.value;
  set setClientProductPrice(ProductPriceModel val){
    clientProductPrice.value = val;
    clientProductPrice.refresh();
  }
  var isAddPrice = false.obs;
  bool get getIsAddPrice => isAddPrice.value;
  set setIsAddPrice(bool val){
    isAddPrice.value = val;
    isAddPrice.refresh();
  }
  var isInsertPrice = false.obs;
  bool get getIsInsertPrice => isInsertPrice.value;
  set setIsInsertPrice(bool val){
    isInsertPrice.value = val;
    isInsertPrice.refresh();
  }

  var userKey = "".obs;
  String get getUserKey => userKey.value;
  set setUserKey(String val){
    userKey.value = val;
    userKey.refresh();
  }
  Future<void> fetchProductPrice(String key,productName) async{
    setIsAddPrice = false;
    FirebaseFirestore.instance.collection("client").doc(key).collection("products").where("product_name",isEqualTo: productName).get().then((value) {
      if(value.size!=0){
        print("==================not null=================");
        print( value.docs.first.data());
        ProductPriceModel _productPriceModel = ProductPriceModel.fromJson( value.docs.first.data());
        _productPriceModel.key = value.docs.first.id;
        setClientProductPrice = _productPriceModel;
        productNameController.text = _productPriceModel.productName.toString();
        productPriceController.text = _productPriceModel.productPrice.toString();
      }else{
        print("==================null=================");
        setIsAddPrice = true;

      }
    });
  }
  Future<void> addProductPrice(String key,productName,productPrice,bool isRepeatable) async{
    setIsAddPrice = false;
    FirebaseFirestore.instance.collection("client").doc(key).collection("products").where("product_name",isEqualTo: productName).get().then((value) {
      if(value.size!=0){
        FirebaseFirestore.instance.collection("client").doc(key).collection("products").doc(getClientProductPrice.key).update({
          "isReplaceable":isRepeatable,
          "product_name":productName,
          "product_price":productPrice
        }).then((value) {
          fetchProductPrice(key,productName);
        });
      }else{
        FirebaseFirestore.instance.collection("client").doc(key).collection("products").add({
          "isReplaceable":isRepeatable,
          "product_name":productName,
          "product_price":productPrice
        }).then((value) {
          fetchProductPrice(key,productName);
        });
      }
    });

  }

  var purchaseHistoryList = <PurchaseHistoryModel>[].obs;
  List<PurchaseHistoryModel> get getPurchaseHostoryList => purchaseHistoryList.value;
  set setPurchaseHistoryList(PurchaseHistoryModel val){
    purchaseHistoryList.value.add(val);
    purchaseHistoryList.refresh();
  }

  var showLoader = true.obs;
  bool get getShowLoader => showLoader.value;
  set setShowLoader(bool val){
    showLoader.value = val;
    showLoader.refresh();
  }
  fetchPurchaseHistory(String key,name){
    purchaseHistoryList.clear();
    FirebaseFirestore.instance.collection("agent").doc(key).collection("purchase_history").where("order_type",isEqualTo: name).orderBy("order_update_date").get().then((value) {
      print("========================size==================");
      print(value.size);
      print(key);
      print(name);
      if(value.size !=0){
        value.docs.forEach((element) {
          PurchaseHistoryModel purchaseHistoryModel = PurchaseHistoryModel.fromJson(element.data());
          purchaseHistoryModel.key = element.id;
          setPurchaseHistoryList = purchaseHistoryModel;
          setShowLoader =false;
        });
      }else{
        setShowLoader = false;
      }
    });
  }
}