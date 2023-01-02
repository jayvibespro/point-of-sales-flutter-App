import 'package:cloud_firestore/cloud_firestore.dart';

class SalesModel {
  String? id;
  String? customerName;
  String? customerID;
  Timestamp? time;
  List productsList;
  String? transId;
  int? amountPaid;
  int? totalAmount;
  int? dueAmount;
  int? discountAmount;
  int? itemCount;
  String? paymentType;
  int? year;
  int? month;
  int? day;
  bool isPaid;

  SalesModel({
    required this.id,
    required this.customerName,
    required this.customerID,
    required this.productsList,
    required this.transId,
    required this.paymentType,
    required this.totalAmount,
    required this.dueAmount,
    required this.amountPaid,
    required this.discountAmount,
    required this.itemCount,
    required this.time,
    required this.year,
    required this.month,
    required this.day,
    required this.isPaid,
  });

  factory SalesModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return SalesModel(
      id: doc.id,
      customerID: doc.data()!['customer_id'],
      time: doc.data()!['timestamp'],
      customerName: doc.data()!['customer_name'],
      productsList: doc.data()!['product_list'],
      transId: doc.data()!['trans_id'],
      amountPaid: doc.data()!['amount_paid'],
      totalAmount: doc.data()!['total_amount'],
      discountAmount: doc.data()!['discount_amount'],
      dueAmount: doc.data()!['due_amount'],
      itemCount: doc.data()!['item_count'],
      paymentType: doc.data()!['payment_type'],
      year: doc.data()!['year'],
      month: doc.data()!['month'],
      day: doc.data()!['day'],
      isPaid: doc.data()!['is_paid'],
    );
  }
}
