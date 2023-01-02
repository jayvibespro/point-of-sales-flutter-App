import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerServices {
  String id;
  String customerName;
  String phoneNumber;
  DateTime time;

  CustomerServices({
    required this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.time,
  });

  createCustomer() async {
    try {
      await FirebaseFirestore.instance.collection('customers').add({
        'customer_name': customerName,
        "phone_number": phoneNumber,
        'timestamp': time,
      });
      Get.snackbar("Message",
          "$customerName successfully added in customers collection.",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    } catch (e) {}
  }

  editCustomer() async {
    try {
      await FirebaseFirestore.instance.collection('customers').doc(id).update({
        'customer_name': customerName,
        "phone_number": phoneNumber,
        'timestamp': time,
      });
      Get.snackbar("Message", "$customerName details successfully updated.",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    } catch (e) {}
  }

  deleteCustomer() async {
    try {
      await FirebaseFirestore.instance.collection('customers').doc(id).delete();
    } catch (e) {}
  }
}
