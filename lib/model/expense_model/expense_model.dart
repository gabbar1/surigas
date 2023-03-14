import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  String? expenseName;
  int? expenseAmount;
  Timestamp? date;
  String? key;

  ExpenseModel({this.expenseName, this.expenseAmount,  this.date,this.key});

  ExpenseModel.fromJson(Map<String, dynamic> json) {
    expenseName = json['expense_name'];
    expenseAmount = json['expense_amount'];
    date = json['date'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expense_name'] = this.expenseName;
    data['expense_amount'] = this.expenseAmount;
    data['date'] = this.date;
    data['key'] = this.key;
    return data;
  }
}
