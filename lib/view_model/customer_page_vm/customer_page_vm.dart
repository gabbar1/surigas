import 'package:get/get.dart';

class CustomerPageVM extends GetxController{

  var isHideFirstForm = false.obs;
  bool get getIsHideFirstForm => isHideFirstForm.value;
  set setIsHideFirstForm(bool val){
    isHideFirstForm.value = val;
    isHideFirstForm.refresh();
  }
  var isDealder = false.obs;
  bool get getisDealder => isDealder.value;
  set setisDealder(bool val){
    isDealder.value= val;
    isDealder.refresh();
  }
  var  colorIndex = 100.obs;
  int get getColorIndex => colorIndex.value;
  set setColorIndex(int val){
    colorIndex.value = val;
    colorIndex.refresh();
  }
  var  startDate = "Pick a Date".obs;
  String get getStartDate =>  startDate.value;
  set setStartDate(String val){
    startDate.value = val;
    startDate.refresh();
  }
}