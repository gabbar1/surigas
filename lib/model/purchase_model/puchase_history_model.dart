import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseHistoryModel {
  Timestamp? orderDate;
  Timestamp? orderUpdateDate;
  String? orderType;
  String? paymentStatus;
  String? fullCylinder;
  String? emptyCylinder;
  String? totalAmount;
  String? rate;
  String? key;

  PurchaseHistoryModel(
      {this.orderDate,
        this.orderUpdateDate,
        this.orderType,
        this.paymentStatus,
        this.fullCylinder,
        this.emptyCylinder,
        this.totalAmount,
        this.rate,
        this.key
      });

  PurchaseHistoryModel.fromJson(Map<String, dynamic> json) {
    orderDate = json['order_date'];
    orderUpdateDate = json['order_update_date'];
    orderType = json['order_type'];
    paymentStatus = json['payment_status'];
    fullCylinder = json['full_cylinder'];
    emptyCylinder = json['empty_cylinder'];
    totalAmount = json['total_amount'];
    rate = json['rate'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_date'] = this.orderDate;
    data['order_update_date'] = this.orderUpdateDate;
    data['order_type'] = this.orderType;
    data['payment_status'] = this.paymentStatus;
    data['full_cylinder'] = this.fullCylinder;
    data['empty_cylinder'] = this.emptyCylinder;
    data['total_amount'] = this.totalAmount;
    data['rate'] = this.rate;
    data['key'] = this.key;
    return data;
  }
}
