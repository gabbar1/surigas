import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:surigas/model/my_team_model/my_team_model.dart';

class MyTeamVM extends GetxController{
  
  var myTeamModel = <MyTeamModel>[].obs;

  List<MyTeamModel> get getMyTeamModel => myTeamModel.value;
  
  setMyTeamModel(MyTeamModel val){
    myTeamModel.value.add(val);
    myTeamModel.refresh();
  }
  fetchMyTeamList(){
    myTeamModel.value.clear();
    myTeamModel.refresh();
    FirebaseFirestore.instance.collection("dealer").get().then((value) {
      if(value.docs.isNotEmpty){
        value.docs.forEach((element) {
          MyTeamModel myTeamModel = MyTeamModel.fromJson(element.data());
          myTeamModel.key = element.id;
          setMyTeamModel(myTeamModel);
        });
      }
    });
  }
  updateStatus(String key,bool status){
    FirebaseFirestore.instance.collection("dealer").doc(key).update({
      "isEnabled":status
    }).then((value) {
      fetchMyTeamList();
    });
  }

SearchMyTeamUser(String query){
    myTeamModel.value.clear();
    myTeamModel.refresh();
    FirebaseFirestore.instance.collection("dealer").where("name",isGreaterThanOrEqualTo: query).where("name",isLessThan: query+"z").get().then((value) {
      if(value.docs.isNotEmpty){
        value.docs.forEach((element) {
          MyTeamModel myTeamModel = MyTeamModel.fromJson(element.data());
          myTeamModel.key = element.id;
          setMyTeamModel(myTeamModel);
        });
      }
    });
}



}