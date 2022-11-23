import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/product_price_model/product_price_model.dart';
import '../../utils/loader.dart';

class ProductListVM extends GetxController{

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
          fetchProductList();
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
    fetchProductList();
    Navigator.pop(Get.context!);
    }).onError((error, stackTrace) {
    closeLoader();
    });

  }
  Future<void>fetchProductList() async{
    productList.clear();

    FirebaseFirestore.instance.collection("products").get().then((value) {
      if(value.size!=0){
        value.docs.forEach((element) {
          print(element.data());
          ProductPriceModel productPriceModel =  ProductPriceModel.fromJson(element.data());
          productPriceModel.key = element.id;
          setProductList = productPriceModel;
          print(jsonEncode(getProductList));
        });
      }
    });
  }
}