import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  final String price;
  final String title;
  final String description;
  final String category;
  final String image;
  final String ratingRate;
  final String ratingCount;

  const DetailScreen({Key? key, required this.price, required this.title, required this.description, required this.category, required this.image, required this.ratingRate, required this.ratingCount, required this.id}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Item Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                    height: 200,
                    child: Image(
                        image: NetworkImage(widget.image))
                ),
              ),
              const SizedBox(height: 30),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'MRP: ${widget.price}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Category: ${widget.category}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 15),
              Text(
                widget.description
              ),
              const SizedBox(height: 20),
              Text(
                  'Ratings: ${widget.ratingRate}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Total Ratings: ${widget.ratingCount}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: InkWell(
                  onTap: () async {
                    await FirebaseFirestore.instance
                        .collection('data')
                        .doc(user!.uid)
                        .collection('shop')
                        .add({
                      'id': widget.id.toString(),
                      'title': widget.title.toString(),
                      'price': widget.price.toString(),
                      'description': widget.description.toString(),
                      'category': widget.category.toString(),
                      'image': widget.image.toString(),
                      'rating rate': widget.ratingRate.toString(),
                      'rating count': widget.ratingCount.toString(),
                      'uid': user!.uid
                    }).then((value) => Get.snackbar('Success', '${widget.title} add to cart Successfully',duration: const Duration(seconds: 2)));
                  },
                  child: Container(
                    height: 50,
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.lightBlue
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.add_shopping_cart_outlined,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
