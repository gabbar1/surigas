import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../view/screens/homepage/HomePage_view.dart';

class LoginAuthVM extends GetxController{


   Future<User?> loginUsingEmailPassword(
      {required String email, required String password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      if(userCredential!=null){
        Get.offAll(HomePage());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No User found for that email");
      }
    }
    return user;
  }
}