
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  int? recieved;
  int? deliver;
  int? recievedAmount;
  int? pendingAmount;
  Timestamp? date;
  String? deliveredBy;
  String? deliveredItemCategory;
  String? key;

  HistoryModel(
      {this.recieved,
        this.deliver,
        this.recievedAmount,
        this.pendingAmount,
        this.date,
        this.deliveredBy,
        this.deliveredItemCategory,this.key});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    recieved = json['recieved'];
    deliver = json['deliver'];
    recievedAmount = json['recieved_amount'];
    pendingAmount = json['pending_amount'];
    date = json['date'];
    deliveredBy = json['delivered_by'];
    deliveredItemCategory = json['delivered_item_category'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recieved'] = this.recieved;
    data['deliver'] = this.deliver;
    data['recieved_amount'] = this.recievedAmount;
    data['pending_amount'] = this.pendingAmount;
    data['date'] = this.date;
    data['delivered_by'] = this.deliveredBy;
    data['delivered_item_category'] = this.deliveredItemCategory;
    data['key'] = this.key;
    return data;
  }
}
