import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surigas/view_model/my_team_vm/my_team_vm.dart';


class MyTeam extends StatefulWidget {
  CollectionReference dealer = FirebaseFirestore.instance.collection("dealer");


  @override
  State<MyTeam> createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  MyTeamVM myTeamVM = Get.put(MyTeamVM());
  @override
  void initState(){
    myTeamVM.fetchMyTeamList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text("My Team"),
        centerTitle:
         true,
      ),
      body: Obx(() => ListView.separated(
          shrinkWrap: true,
          itemCount: myTeamVM.getMyTeamModel.length,
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(myTeamVM.getMyTeamModel[index].name
                        .toString()),
                    subtitle: Text(myTeamVM
                        .getMyTeamModel[index].mobileNumber
                        .toString()),
                  ),
                ),
                Switch(

                      value: myTeamVM.getMyTeamModel[index].isEnabled!, onChanged: (val){
                    myTeamVM..updateStatus(myTeamVM.getMyTeamModel[index].key!,!myTeamVM.getMyTeamModel[index].isEnabled!);
                  }),

              ],
            );
          })),
    );
  }
}
