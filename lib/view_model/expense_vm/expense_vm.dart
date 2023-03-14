import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surigas/model/expense_model/expense_model.dart';
import 'package:surigas/utils/loader.dart';

class ExpenseVM extends GetxController{

  TextEditingController expenseAmountController = TextEditingController();
  TextEditingController expenseNameController = TextEditingController();


  var expenseList = <ExpenseModel>[].obs;
  List<ExpenseModel> get getExpenseList => expenseList.value;
  set setExpenseList(ExpenseModel val){
    expenseList.value.add(val);
    expenseList.refresh();
  }
  
  
  Future<void>addExpense(String name,num price) async {

    FirebaseFirestore.instance.collection("expense").add({
      "expense_name": name,
      "expense_amount": price,
      "date":Timestamp.now(),
      "dealerId":FirebaseAuth.instance.currentUser!.phoneNumber!.replaceAll("+91", "")
    }).then((value) {
      fetchExpenseList(false);
      Navigator.pop(Get.context!);
    });


  }

  Future<void>fetchExpenseList(isInit) async{
    expenseList.clear();
    FirebaseFirestore.instance.collection("expense").get().then((value) {
      if(value.size!=0){
        value.docs.forEach((element) {
          print(element.data());
          ExpenseModel expenseModel = ExpenseModel.fromJson(element.data());
          print(expenseModel.toJson());
          expenseModel.key = element.id;
          setExpenseList = expenseModel;
        });
      }
    });
  }
  Future<void>fetchExpenseListWithDate(DateTime startDate,endDate) async{
    print("===================date==============");
    
    var _startDate = new DateTime(startDate.year, startDate.month, startDate.day);
    var _endDate = new DateTime(endDate.year, endDate.month, endDate.day);
    expenseList.clear();
    FirebaseFirestore.instance.collection("expense").where("date",isGreaterThanOrEqualTo: _startDate).where("date",isLessThan: _endDate).get().then((value) {
      if(value.size!=0){
        value.docs.forEach((element) {
          print(element.data());
          ExpenseModel expenseModel = ExpenseModel.fromJson(element.data());
          expenseModel.key = element.id;
          setExpenseList = expenseModel;
        });
      }
    });
  }
}