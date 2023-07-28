import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice_app/button/round.dart';
import 'package:firebase_practice_app/screen/shop/shopping.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const VerificationScreen({Key? key,required this.verificationId, required this.phoneNumber}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool loading = false;
  TextEditingController otpController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final otpKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: otpKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Text(
                  'Verify with otp',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    hintText: 'Enter OTP',
                    hintStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                    ),
                  ),
                  validator: (otp) {
                    if(otp!.isEmpty) {
                      return 'Please Enter OTP';
                    }
                    if(otp.length < 6) {
                      return 'Please Enter Valid OTP';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                RoundButton(
                    title: 'Verify',
                    loading: loading,
                    onTap: () async {
                      if(otpKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        final credential = PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: otpController.text.toString()
                        );
                        try{
                          await auth.signInWithCredential(credential);
                          User? user = FirebaseAuth.instance.currentUser;
                          await FirebaseFirestore.instance
                          .collection('data')
                          .doc(user!.uid)
                          .set({
                            'email': '',
                            'name': '',
                            'phoneNumber': widget.phoneNumber,
                            'createdAt': DateTime.now(),
                            'userId': user.uid
                          });
                          Get.to(const ShoppingScreen());
                        }
                        catch(e){
                          setState(() {
                            loading = false;
                          });
                          Get.snackbar('Error', 'Something Wrong');
                        }
                      }
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
