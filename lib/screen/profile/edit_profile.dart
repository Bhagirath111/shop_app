import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice_app/button/round.dart';
import 'package:firebase_practice_app/screen/shop/shopping.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> profileKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController updateNameController = TextEditingController();
  TextEditingController updateEmailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  File? image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {

      });
    } else {
      print('No Image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 500,
          child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('data')
                  .where('userId', isEqualTo: user!.uid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    var profileImage = document['profileImage'];
                    var name = document['name'];
                    var email = document['email'];
                    var number = document['phoneNumber'];
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 50),
                            InkWell(
                              onTap: getImageGallery,
                              child: CircleAvatar(
                                backgroundImage: (image == null)
                                    ? NetworkImage(profileImage)
                                    : FileImage(image!) as ImageProvider,
                                radius: 50,
                                child: Visibility(
                                  visible:
                                      image == null && profileImage == '',
                                  child:
                                      const Icon(Icons.add_a_photo_rounded),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: updateNameController..text = name,
                              decoration: const InputDecoration(
                                  hintText: 'Enter your Name',
                                  hintStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: updateEmailController..text = email,
                              decoration: const InputDecoration(
                                hintText: 'Enter Your Email',
                                hintStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: phoneController..text = number,
                              decoration: const InputDecoration(
                                  hintText: 'Enter Mobile No...',
                                  hintStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                            ),
                            const SizedBox(height: 50),
                            RoundButton(
                                title: 'Update',
                                onTap: () async {
                                  if (image != null) {
                                    firebase_storage.Reference ref =
                                        firebase_storage
                                            .FirebaseStorage.instance
                                            .ref(
                                                '/profiles/${DateTime.now().millisecondsSinceEpoch}');
                                    firebase_storage.UploadTask uploadTask =
                                        ref.putFile(image!.absolute);
                                    await Future.value(uploadTask)
                                        .then((value) async {
                                      var newUrl = await ref.getDownloadURL();
                                      FirebaseFirestore.instance
                                          .collection('data')
                                          .doc(user!.uid)
                                          .update({
                                        'profileImage':
                                            newUrl.toString() != null
                                                ? newUrl.toString()
                                                : profileImage,
                                        'email': updateEmailController
                                            .text
                                            .isEmpty
                                            ? email
                                            : updateEmailController.text,
                                        'name': updateNameController
                                            .text
                                            .isEmpty
                                            ? name
                                            : updateNameController.text,
                                      });
                                    });
                                  } else {
                                    await FirebaseFirestore.instance
                                        .collection('data')
                                        .doc(user!.uid)
                                        .set({
                                      'name':
                                          updateNameController.text.isEmpty
                                              ? name
                                              : updateNameController.text,
                                      'email':
                                          updateEmailController.text.isEmpty
                                              ? email
                                              : updateEmailController.text,
                                      'phoneNumber':
                                          phoneController.text.isEmpty
                                              ? number
                                              : phoneController.text
                                    }, SetOptions(merge: true)).then(
                                            (value) => Get.snackbar('Success',
                                                'Update Successfully'));
                                  }
                                  Get.snackbar('Success', 'Update Successfully');
                                  Get.to(const ShoppingScreen());
                                })
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
        ),
      ),
    );
  }
}
