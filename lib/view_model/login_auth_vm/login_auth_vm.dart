import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surigas/model/auth/register_form.dart';
import 'package:surigas/view/screens/homepage/home_navigator/home_navigator.dart';

import '../../utils/loader.dart';
import '../../view/screens/homepage/HomePage_view.dart';
import '../../view/screens/login/authenticator.dart';
import '../../view/screens/login/register_form.dart';

class LoginAuthVM extends GetxController{

   String? phoneNo,verficationId;
   bool codeSent = false;
   bool isLogin=false;
   var isOtp = false.obs;
   bool get getIsOtp => isOtp.value;
   set setIsOtp(bool val){
     isOtp.value = val;
     isOtp.refresh();
   }
   Future<User?> loginUsingEmailPassword({required String email, required String password}) async {
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

   Future<void> login({required String phone}) async {
     this.phoneNo = phone;
     try{
       showLoader();
       verifyPhone("+91 ${phone}");
     }catch(e){
       closeLoader();
       Get.snackbar("Error", e.toString());
       throw e;
     }

   }

   Future<void> verifyPhone(phoneNo) async {
     final PhoneVerificationCompleted verified = (AuthCredential authResult) {};
     final PhoneVerificationFailed verificationFailed =
         (FirebaseAuthException authException) {

       Get.snackbar("Error Code 1 : ", authException.message.toString());
     };

     final PhoneCodeSent smsSent = (String verId, [int? forceResend]) {
       this.codeSent = true;
       this.verficationId = verId;

       if (codeSent==true) {
         setIsOtp = true;
         closeLoader();
         // Get.to(VerifyOtpScreen());
       } else {
         Get.snackbar("Error", "Code not sent");
       }
       //Fluttertoast.showToast(msg: verficationId.toString());
     };

     final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
       this.verficationId = verId;
     };
     await FirebaseAuth.instance.verifyPhoneNumber(
         phoneNumber: phoneNo,
         timeout: const Duration(seconds: 60),
         verificationCompleted: verified,
         verificationFailed: verificationFailed,
         codeSent: smsSent,
         codeAutoRetrievalTimeout: autoTimeout).then((value) {
       isLogin = true;
     });
   }
   Future<void> loginUser({required String otp,required BuildContext context}) async {
     try{
       showLoader();
       FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(
         verificationId: verficationId.toString(),
         smsCode: otp,
         //8160137998
       )).then((value) async{
         closeLoader();
         if(value.additionalUserInfo!.isNewUser) {
           Get.offAll(RegisterForm());
         }
         else{
           Get.offAll(Authenticator());
          // Get.offAll(HomeNavigator());
          // final prefs = await SharedPreferences.getInstance();
           //String fcm = await FirebaseMessaging.instance.getToken();
          // prefs.setString("fcm",fcm);

          /* FirebaseFirestore.instance.collection("user_details").doc(FirebaseAuth.instance.currentUser!.phoneNumber!.replaceAll("+91", "")).update({
             "fcm_token":fcm
           });*/


         }
       });
     } on Exception catch(e){
       closeLoader();
       Get.snackbar("Error", e.toString());

     }
   }
   Future<void> registerUser({required RegisterFormModel val})async{
     try{
       showLoader();
       FirebaseFirestore.instance.collection("dealer").add(val.toJson()).then((value) {
         Get.offAll(HomeNavigator());
         closeLoader();
       });
     }on Exception catch(e){
       closeLoader();
       Get.snackbar("Error", e.toString());
     }
   }
}