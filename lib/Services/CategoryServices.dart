import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryServices {
  String id;
  String category;

  CategoryServices({
    required this.id,
    required this.category,
  });

  createCategory() async {
    try {
      await FirebaseFirestore.instance.collection('categories').add({
        'category': category,
      });
      Get.snackbar("Message", "$category Category successfully created.",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    } catch (e) {}
  }

  editCategory() async {
    try {
      await FirebaseFirestore.instance.collection('categories').doc(id).update({
        'category': category,
      });
      Get.snackbar("Message", "$category Category successfully updated.",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    } catch (e) {}
  }

  deleteCategory() async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(id)
          .delete();
      Get.snackbar("Message", "$category Category successfully deleted.",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    } catch (e) {}
  }
}
