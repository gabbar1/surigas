import 'package:get/get.dart';

class CustomerPageVM extends GetxController{

  var isHideFirstForm = false.obs;
  bool get getIsHideFirstForm => isHideFirstForm.value;
  set setIsHideFirstForm(bool val){
    isHideFirstForm.value = val;
    isHideFirstForm.refresh();
  }
}