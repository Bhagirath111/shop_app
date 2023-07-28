import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practice_app/screen/profile/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice_app/button/round.dart';
import 'package:firebase_practice_app/screen/login/signin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loadings = false;
  User? profileUser = FirebaseAuth.instance.currentUser;

  signOut() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: SizedBox(
            height: Get.height,
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('data')
                  .where('userId', isEqualTo: profileUser!.uid)
                  .get(),
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((document) {
                    var profileImage = document['profileImage'];
                    var userName = document['name'];
                    var userEmail = document['email'];
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          CircleAvatar(
                            backgroundImage: NetworkImage(profileImage),
                            radius: 40,
                            child: Visibility(
                              visible: profileImage == '',
                                child: const Icon(Icons.no_photography)),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '$userName',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '$userEmail',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            height: Get.height,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black12
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      Get.to(const EditProfileScreen());
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 30,
                                          color: Colors.black,
                                        ),
                                        SizedBox(width: 25),
                                        Text(
                                          'Profile',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  child: Column(
                                                    children: [
                                                      const Text(
                                                        'Are You Sure!!! You Want To Sign out???',
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.black
                                                        ),
                                                      ),
                                                      const SizedBox(height: 25),
                                                      RoundButton(
                                                          title: 'Sign Out',
                                                          loading: loadings,
                                                          onTap: () {
                                                            setState(() {
                                                              loadings = true;
                                                            });
                                                            signOut();
                                                            Navigator.of(context).pushAndRemoveUntil(
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                    const SignInScreen()),
                                                                    (Route<dynamic> route) => false);
                                                            setState(() {
                                                              loadings = false;
                                                            });
                                                          }),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            );
                                          }
                                      );
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(Icons.logout_outlined,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          'Sign Out',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
                },
            ),
          )
      ),
    );
  }
}
