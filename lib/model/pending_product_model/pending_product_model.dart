import 'package:cloud_firestore/cloud_firestore.dart';

class PendingProductModel {
  int? pendingMoney;
  int? pendingCylinder;
  Timestamp? date;
  String? key;


  PendingProductModel({this.pendingMoney, this.pendingCylinder,  this.date,this.key});

  PendingProductModel.fromJson(Map<String, dynamic> json) {
    pendingMoney = json['pending_money'];
    pendingCylinder = json['pending'];
    date = json['date'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pending_money'] = this.pendingMoney;
    data['pending'] = this.pendingCylinder;
    data['date'] = this.date;
    data['key'] = this.key;
    return data;
  }
}
