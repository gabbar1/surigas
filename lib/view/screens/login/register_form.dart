import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surigas/view_model/login_auth_vm/login_auth_vm.dart';

import '../../../model/auth/register_form.dart';
import '../../../utils/common_widget.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm({Key? key}) : super(key: key);
  final _globalFistKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _orgController = TextEditingController();
  TextEditingController _refController = TextEditingController();
  LoginAuthVM loginAuthVM = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _globalFistKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonTextInputWithTitle(
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        title: "Email Address",
                        inputController: _emailController,
                        hint: "enter email address"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonTextInputWithTitle(
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.name,
                        title: "Name",
                        inputController: _nameController,
                        hint: "enter name"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonTextInputWithTitle(
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.text,
                        title: "Address",
                        inputController: _addressController,
                        hint: "enter address"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonTextInputWithTitle(
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.number,
                        title: "PinCode",
                        inputController: _pincodeController,
                        hint: "enter pincode"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonTextInputWithTitle(
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.phone,
                        title: "Organization ID",
                        inputController: _orgController,
                        hint: "enter organization id"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CommonTextInputWithTitle(
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.phone,
                  hint: "enter referral id",
                  title: "Referral ID",
                  inputController: _refController),
            ),
            InkWell(
              onTap: () {
                if (_globalFistKey.currentState!.validate()) {
                  RegisterFormModel registerFormModel = RegisterFormModel(
                      name: _nameController.text,
                      address: _addressController.text,
                      email: _emailController.text,
                      mobileNumber: int.parse(FirebaseAuth
                          .instance.currentUser!.phoneNumber!
                          .replaceFirst("+91", "")),
                      orgId: int.parse(_orgController.text),
                      pincode: int.parse(_pincodeController.text),
                      refId:_refController.text.isNotEmpty? int.parse(_refController.text):null,
                    isDealder: _orgController.text == FirebaseAuth.instance.currentUser!.phoneNumber!.replaceAll("+91", "")? true:false,
                    isEnabled: false
                  );
                  loginAuthVM.registerUser(val: registerFormModel);

                }
              },
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    padding: EdgeInsets.all(23),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
