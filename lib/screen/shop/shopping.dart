import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice_app/screen/shop/cart_screen.dart';
import 'package:firebase_practice_app/screen/shop/product_details.dart';
import 'package:firebase_practice_app/screen/profile/profile.dart';
import 'package:firebase_practice_app/model/shop_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    getData();
    super.initState();
  }

  List<ShopModel> shopList = [];

  getData() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (kDebugMode) {
      print(response);
    }
    if (response.statusCode == 200) {
      var convertedData = json.decode(response.body);
      List<dynamic> body = convertedData;
      shopList = body.map((dynamic item) => ShopModel.fromJson(item)).toList();
      if (kDebugMode) {
        print(shopList);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Shop'),
        leading: IconButton(
          onPressed: () {
            Get.to(const ProfileScreen());
          },
          icon: const Icon(Icons.person),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const CartScreen());
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: shopList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 25,
                          child: SizedBox(
                            height: 140,
                            child: Image(
                                image: NetworkImage(
                                    shopList[index].image.toString())
                            ),
                          )),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 75,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              shopList[index].category.toString(),
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(height: 7),
                            Text(
                                'Price: ${shopList[index].price.toString()}'
                            ),
                            const SizedBox(height: 15),
                            InkWell(
                              onTap: () async {
                                Get.to(DetailScreen(
                                  id: shopList[index].id.toString(),
                                  title: shopList[index].title.toString(),
                                  price: shopList[index].price.toString(),
                                  description: shopList[index].description.toString(),
                                  category: shopList[index].category.toString(),
                                  image: shopList[index].image.toString(),
                                  ratingRate: shopList[index].rating?.rate.toString() ?? '',
                                  ratingCount: shopList[index].rating?.count.toString() ?? '',
                                ));
                              },
                              child: Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey
                                ),
                                child: const Center(
                                  child: Text(
                                    'View Details',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
