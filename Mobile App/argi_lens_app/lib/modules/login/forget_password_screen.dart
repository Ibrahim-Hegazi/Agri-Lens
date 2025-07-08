import 'package:agre_lens_app/modules/login/verify_account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../layout/app_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import 'login_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _emailController = TextEditingController();
  var formkey = GlobalKey<FormState>();
  var scafoldkey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset()async{
    try{
      FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('If this email is registered, a password reset link will be sent to you.'),
            backgroundColor: ColorManager.greenColor,
        )
      );
      await Future.delayed(Duration(seconds: 1));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );

    }on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message.toString()))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: scafoldkey,
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorManager.whiteColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/login_bg.png',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(
                    top: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        'assets/images/Login_logo.png',
                        height: 180,
                        width: 202,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: Color(0xFF414042),
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 26,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Transform.scale(
                        scale: 1,
                        child: SvgPicture.asset(
                          'assets/icons/ep_back.svg',
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'No worries! Enter your email address below and we will send you a password reset link.',
                  style: TextStyle(
                    color: Color(0xFF000113),
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      defaultFormField(
                        context: context,
                        controller: _emailController,
                        labelText: 'Email',
                        type: TextInputType.emailAddress,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 50,),
                      defaultButton(
                          onTap: (){
                            if(formkey.currentState!.validate()){
                              passwordReset();
                            }
                          },
                          colorButton: ColorManager.greenColor,
                          textColorButton: Colors.white,
                          text: Text(
                            'Send Password Reset Link',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
