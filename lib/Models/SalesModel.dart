import 'package:cloud_firestore/cloud_firestore.dart';

class SalesModel {
  String id;
  String productName;
  String productBrand;
  String productId;
  String customerName;
  String customerID;
  int sellPrice;
  int stockCount;
  DateTime time;

  SalesModel({
    required this.id,
    required this.productId,
    required this.customerName,
    required this.productName,
    required this.stockCount,
    required this.productBrand,
    required this.customerID,
    required this.sellPrice,
    required this.time,
  });

  factory SalesModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return SalesModel(
      id: doc.id,
      productName: doc.data()!['product_name'],
      customerID: doc.data()!['customer_id'],
      sellPrice: doc.data()!['sell_price'],
      productBrand: doc.data()!['product_brand'],
      time: doc.data()!['timestamp'],
      customerName: doc.data()!['Customer_name'],
      stockCount: doc.data()!['stock_count'],
      productId: doc.data()!['product_id'],
    );
  }
}
