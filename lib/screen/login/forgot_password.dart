import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice_app/button/round.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signin.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  TextEditingController emailController = TextEditingController();

  forgotPassword() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim()
    ).then((value) {
      Get.snackbar('Success', 'Password reset email send');
      Get.to(const SignInScreen());
      emailController.clear();
    }).onError((error, stackTrace) {
      Get.snackbar('Failed', 'This email is not registered');
    });
  }

  @override
  Widget build(BuildContext context) {
    final passwordKey = GlobalKey<FormState>();
    return Scaffold(
      body: Form(
        key: passwordKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 90),
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                const SizedBox(height: 50),
                const Text(
                  'Receive an email to reset your Password',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black
                  ),
                ),
                const SizedBox(height: 60),
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black12
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter email',
                        hintStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                        ),
                      ),
                      validator: (email) {
                        if(email!.isEmpty) {
                          return 'Please Enter Email';
                        }
                        else if(!email.contains('@')){
                          return 'Please Enter Valid Email';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                RoundButton(
                    title: 'Send',
                    onTap: () async {
                      if(passwordKey.currentState!.validate()) {
                        await forgotPassword();
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
