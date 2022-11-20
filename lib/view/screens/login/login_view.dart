import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:surigas/view_model/login_auth_vm/login_auth_vm.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(17),
    borderSide: const BorderSide(color: Colors.blue));

class _LoginPageState extends State<LoginPage> {

 bool isSecured =true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  LoginAuthVM loginAuthVM = Get.put(LoginAuthVM());
  @override
  Widget build(BuildContext context) {


    return KeyboardSizeProvider(
      child: Consumer<ScreenHeight>(builder: (context,_res,child){
        return Scaffold(
          body: Stack(children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15,15,15,0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40.0,),
                      Center(child: SvgPicture.asset("assets/images/undraw_login_re_4vu2 1.svg")),
                      SizedBox(height: 20.0,),
                      Row(
                        children: [
                          Text(
                            "Welcome ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Back ",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.0,),
                      Obx(()=>TextField(
                        readOnly: loginAuthVM.getIsOtp,

                        textInputAction: TextInputAction.done,
                        controller: _emailController,
                        keyboardType: TextInputType.phone,
                        onSubmitted: (_){
                          loginAuthVM.login(phone:_emailController.text);
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Phone Number",
                            hintStyle: TextStyle(fontWeight: FontWeight.bold),
                            enabledBorder: border,
                            focusedBorder: border,
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.blue,
                            )),
                      )),
                      Obx(()=> SizedBox(height: (loginAuthVM.getIsOtp)==true?15.0:0.0,),),
                      Obx(()=>(loginAuthVM.getIsOtp)==true?TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: _passwordController,
                        obscureText: isSecured,
                        decoration: InputDecoration(
                            hintText: "OTP",
                            hintStyle: TextStyle(fontWeight: FontWeight.bold),
                            enabledBorder: border,
                            focusedBorder: border,
                            prefixIcon: Icon(
                              Icons.lock_outline_sharp,
                              color: Colors.blue,
                            ),

                        ),

                      ):SizedBox()),
                      Obx(()=> SizedBox(height:(loginAuthVM.getIsOtp)==true? 50.0:10.0,)),
                      Obx(()=>Container(
                        width: double.infinity,
                        child: RawMaterialButton(
                          fillColor: Colors.blue,
                          elevation: 0.0,
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          onPressed: () async {
                            if(loginAuthVM.getIsOtp){
                              loginAuthVM.loginUser(otp: _passwordController.text,context: context);
                            }else{
                              loginAuthVM.login(phone:_emailController.text);
                            }

                          },
                          child: Text(
                           loginAuthVM.getIsOtp==false? "Login":"Verify",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      )),
                      SizedBox(height: 110.0,)
                    ],
                  ),
                ),
              ),
            ),
            Positioned(right: 0,child: Container(child: Image(image: AssetImage("assets/images/Group 28.png"),),),
            ),
            _res.isOpen ? SizedBox():Positioned(bottom: 0,child: Container(child: Image(image: AssetImage("assets/images/Group 29.png"),),),
            ),
          ]),
        );
      },),
    );
  }
}
