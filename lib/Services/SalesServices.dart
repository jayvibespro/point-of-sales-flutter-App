import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesService {
  String? id;
  String? transId;
  String? customerName;
  String? customerID;
  Timestamp? time;
  int? totalAmount;
  int? dueAmount;
  List productsList;
  String? paymentType;
  int? amountPaid;
  int? discountAmount;
  int? itemCount;
  int? year;
  int? month;
  int? day;
  bool? isPaid;

  SalesService({
    required this.id,
    required this.isPaid,
    required this.transId,
    required this.customerName,
    required this.customerID,
    required this.productsList,
    required this.dueAmount,
    required this.totalAmount,
    required this.paymentType,
    required this.itemCount,
    required this.time,
    required this.discountAmount,
    required this.amountPaid,
    required this.year,
    required this.month,
    required this.day,
  });

  sell() async {
    try {
      await FirebaseFirestore.instance.collection('sales').add({
        'customer_name': customerName,
        'customer_id': customerID,
        'is_paid': isPaid,
        'product_list': productsList,
        'item_count': itemCount,
        'payment_type': paymentType,
        'trans_id': transId,
        'amount_paid': amountPaid,
        'discount_amount': discountAmount,
        'total_amount': totalAmount,
        'due_amount': dueAmount,
        'timestamp': time,
        'year': year,
        'month': month,
        'day': day,
      });
      Get.snackbar("Message", "Products successfully sold to $customerName.",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    } catch (e) {}
  }

  editSales() async {
    try {
      await FirebaseFirestore.instance.collection('sales').doc(id).update({
        'customer_name': customerName,
        'customer_id': customerID,
        'product_list': productsList,
        'item_count': itemCount,
        'payment_type': paymentType,
        'trans_id': transId,
        'amount_paid': amountPaid,
        'discount_amount': discountAmount,
        'total_amount': totalAmount,
        'due_amount': dueAmount,
        'timestamp': time,
      });
      Get.snackbar("Message", "Sales Details successfully updated.",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    } catch (e) {}
  }

  deleteSales() async {
    try {
      await FirebaseFirestore.instance.collection('sales').doc(id).delete();
      Get.snackbar("Message", "The sale record has been deleted successfully.",
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
