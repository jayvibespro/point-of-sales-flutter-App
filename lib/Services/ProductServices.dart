import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductService {
  String id;
  String productName;
  String productBrand;
  String productImage;
  String package;
  int buyPrice;
  int sellPrice;
  int stockCount;
  DateTime time;

  ProductService({
    required this.id,
    required this.productName,
    required this.productBrand,
    required this.productImage,
    required this.package,
    required this.buyPrice,
    required this.sellPrice,
    required this.stockCount,
    required this.time,
  });

  createProduct() async {
    try {
      await FirebaseFirestore.instance.collection('products').add({
        'product_name': productName,
        'product_brand': productBrand,
        'package': package,
        'product_image': productImage,
        'buy_price': buyPrice,
        'sell_price': sellPrice,
        'stock_count': stockCount,
        'timestamp': time,
      });
      Get.snackbar("Message", "Product added successfully.",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    } catch (e) {}
  }

  editProduct() async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(id).update({
        'product_name': productName,
        'product_brand': productBrand,
        'package': package,
        'product_image': productImage,
        'buy_price': buyPrice,
        'sell_price': sellPrice,
        'stock_count': stockCount,
        'timestamp': time,
      });
    } catch (e) {}
  }

  deleteProduct() async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(id).delete();
    } catch (e) {}
  }
}
