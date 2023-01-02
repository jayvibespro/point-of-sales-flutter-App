import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String id;
  String customerName;
  String phoneNumber;
  // DateTime time;

  CustomerModel({
    required this.id,
    required this.customerName,
    required this.phoneNumber,
    // required this.time,
  });

  factory CustomerModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return CustomerModel(
      id: doc.id,
      customerName: doc.data()!['customer_name'],
      phoneNumber: doc.data()!['phone_number'],
      // time: doc.data()!['timestamp'],
    );
  }
}
