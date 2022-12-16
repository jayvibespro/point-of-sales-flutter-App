import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesService {
  String id;
  String productName;
  String productBrand;
  String productId;
  String customerName;
  String customerID;
  int sellPrice;
  int stockCount;
  DateTime time;

  SalesService({
    required this.id,
    required this.productName,
    required this.productBrand,
    required this.productId,
    required this.customerName,
    required this.sellPrice,
    required this.customerID,
    required this.stockCount,
    required this.time,
  });

  sell() async {
    try {
      await FirebaseFirestore.instance.collection('sales').add({
        'product_name': productName,
        'product_brand': productBrand,
        'customer_name': customerName,
        'customer_id': customerID,
        'product_id': productId,
        'sell_price': sellPrice,
        'stock_count': stockCount,
        'timestamp': time,
      });
      Get.snackbar(
          "Message", "$productName successfully sold to $customerName.",
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
      await FirebaseFirestore.instance.collection('sales').doc(id).update({
        'product_name': productName,
        'product_brand': productBrand,
        'customer_name': customerName,
        'customer_id': customerID,
        'product_id': productId,
        'sell_price': sellPrice,
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
