import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice_app/button/round.dart';
import 'package:firebase_practice_app/screen/login/verification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileNoScreen extends StatefulWidget {
  const MobileNoScreen({Key? key}) : super(key: key);

  @override
  State<MobileNoScreen> createState() => _MobileNoScreenState();
}

class _MobileNoScreenState extends State<MobileNoScreen> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  TextEditingController numberController = TextEditingController();
  final phoneKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: phoneKey,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  const Text(
                    'Login with Mobile No.',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: numberController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Mobile No',
                          hintStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Mobile No.';
                          } else if (value.length < 10) {
                            return 'Please Enter Valid No.';
                          }
                          else if(!value.contains('+91')) {
                            return 'Please Enter Country Code +91';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  RoundButton(
                      title: 'Send',
                      loading: loading,
                      onTap: () async {
                        if (phoneKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          await auth.verifyPhoneNumber(
                              phoneNumber: numberController.text,
                              verificationCompleted: (_) {
                                setState(() {
                                  loading = false;
                                  //Get.snackbar('success', 'Verification Completed');
                                });
                              },
                              verificationFailed: (e) {
                                setState(() {
                                  loading = false;
                                  Get.snackbar('Error', 'Verification Failed');
                                });
                              },
                              codeSent: (String verificationId, int? token) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VerificationScreen(
                                                verificationId: verificationId,
                                                phoneNumber: numberController.text)));
                                setState(() {
                                  loading = false;
                                });
                              },
                              codeAutoRetrievalTimeout: (e) {
                                Get.snackbar('Success', 'Check your Inbox');
                                setState(() {
                                  loading = false;
                                });
                              });
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
