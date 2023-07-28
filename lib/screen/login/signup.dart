import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice_app/button/round.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signin.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();
  bool loading = false;

  signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ).then((value) async {
        User? user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance
            .collection('data')
            .doc(user!.uid)
            .set({
          'name': nameController.text,
          'email': emailController.text,
          'phoneNumber': '',
          'profileImage': '',
          'createdAt': DateTime.now(),
          'userId': user.uid,
        });
      });
      Get.to(const SignInScreen());
    } on FirebaseAuthException catch(e) {
      if(e.code == 'email-already-in-use'){
        print('account already in use');
        Get.snackbar('Error', 'This email already in use');
      }
      else if(e.code == 'Weak Password'){
        print('Password is too weak');
        Get.snackbar('Error', 'Password is too weak');
      }
    }
    catch (error){
      print(error);
    }
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: signUpKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 100),
                const Text(
                  'Sign up',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
                const SizedBox(height: 30),
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black12
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Name',
                          hintStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black
                          )
                      ),
                      validator: (name) {
                        if(name!.isEmpty) {
                          return 'Please Enter Name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Email',
                          hintStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)
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
                const SizedBox(height: 25),
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      validator: (password) {
                        if(password!.isEmpty) {
                          return 'Please enter password';
                        }
                        else if(password.length < 6){
                          return 'Password is too short';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                RoundButton(
                    title: 'Sign up',
                    loading: loading,
                    onTap: () async {
                      if(signUpKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        await signUp();
                        setState(() {
                          loading = false;
                        });
                      }
                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
