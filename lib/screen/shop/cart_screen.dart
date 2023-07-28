import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice_app/screen/shop/product_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  deleteItem(String id) {
    FirebaseFirestore.instance
        .collection('data')
        .doc(user!.uid)
        .collection('shop')
        .doc(id)
        .delete();
    setState(() {});
  }

  Future<QuerySnapshot> getCartItem() async {
    final result = FirebaseFirestore.instance
        .collection('data')
        .doc(user!.uid)
        .collection('shop')
        .where('uid', isEqualTo: user?.uid)
        .get();
    return result;
  }

  var total = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Cart',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
        future: getCartItem(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          total = 0;
          if (snapshot.hasData) {
            return snapshot.data!.docs.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 550,
                          child: Expanded(
                            flex: 80,
                            child: ListView(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              children: snapshot.data!.docs.map((doc) {
                                var docId = doc.id;
                                var itemCategories = doc['category'];
                                var itemDescription = doc['description'];
                                var itemId = doc['id'];
                                var itemImage = doc['image'];
                                var itemPrice = doc['price'];
                                total += num.tryParse(itemPrice.toString()) ?? 0.0;
                                var itemRatingCount = doc['rating count'];
                                var itemRatingRate = doc['rating rate'];
                                var itemTitle = doc['title'];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.black12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 25,
                                              child: SizedBox(
                                                height: 140,
                                                child: Image(
                                                    image: NetworkImage(
                                                        itemImage)),
                                              )),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            flex: 75,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10),
                                                Text(
                                                  '$itemCategories',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                                const SizedBox(height: 7),
                                                Text(
                                                  'Price: $itemPrice',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Get.to(DetailScreen(
                                                            price: itemPrice,
                                                            title: itemTitle,
                                                            description:
                                                                itemDescription,
                                                            category:
                                                                itemCategories,
                                                            image: itemImage,
                                                            ratingRate:
                                                                itemRatingRate,
                                                            ratingCount:
                                                                itemRatingCount,
                                                            id: itemId));
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: 120,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors.grey),
                                                        child: const Center(
                                                          child: Text(
                                                            'View Details',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 25),
                                                    InkWell(
                                                      onTap: () {
                                                        deleteItem(docId);
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color:
                                                                Colors.black),
                                                        child: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Sub-Total:",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '\$ $total',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Payment Successful'),
                                    duration: Duration(seconds: 2),
                                  )
                                );
                              },
                              child: Container(
                                height: 50,
                                width: Get.width,
                                color: Colors.black54,
                                child: const Center(
                                  child: Text(
                                    'Proceed to Pay',
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: Column(
                      children: [
                        SizedBox(height: 200),
                        Icon(
                          Icons.no_encryption,
                          size: 60,
                          color: Colors.black,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'No Item Found in Cart',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        )
                      ],
                    ),
                  );
          }
          return const Text('No data');
        },
      )),
    );
  }
}
