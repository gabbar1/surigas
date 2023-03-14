import 'package:flutter/material.dart';
class UserAccess extends StatelessWidget {
  const UserAccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        CircleAvatar(maxRadius: 100,child: Image.asset("assets/icon/logo.png")),
        SizedBox(height: 20,),
        Text("Dear user you are not allowed to use this application, kindly contact your admin for access.",textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
      ],),
    );
  }
}
