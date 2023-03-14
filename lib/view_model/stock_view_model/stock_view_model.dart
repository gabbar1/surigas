import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:surigas/model/stock/stock_model.dart';

class StockViewModel extends GetxController{

  var stockList = <StockModel>[].obs;
  List<StockModel> get getStockList => stockList.value;
  setStockList(StockModel val){
    stockList.add(val);
    stockList.refresh();
  }
  fetStockList(){
    stockList.clear();
    FirebaseFirestore.instance.collection("stock").get().then((value) {
      if(value.size!=0){
        value.docs.forEach((element) {
          StockModel stockModel = StockModel.fromJson(element.data());
          stockModel.key = element.id;
          setStockList(stockModel);
        });
      }
    });
  }
}