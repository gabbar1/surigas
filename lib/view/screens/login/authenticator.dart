import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surigas/view/screens/homepage/HomePage_view.dart';
import 'package:surigas/view/screens/homepage/home_navigator/home_navigator.dart';
import 'package:surigas/view/screens/login/login_view.dart';
class Authenticator extends StatelessWidget {
  const Authenticator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
         if(snapshot.hasData){

           return HomeNavigator();
         }else{
           return LoginPage();
         }
    }));
  }
}
