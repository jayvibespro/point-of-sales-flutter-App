import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  String productName;
  String productBrand;
  String productImage;
  String package;
  int buyPrice;
  int sellPrice;
  int stockCount;
  DateTime time;

  ProductModel({
    required this.id,
    required this.productImage,
    required this.package,
    required this.productName,
    required this.productBrand,
    required this.buyPrice,
    required this.sellPrice,
    required this.stockCount,
    required this.time,
  });

  factory ProductModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return ProductModel(
      id: doc.id,
      productName: doc.data()!['product_name'],
      buyPrice: doc.data()!['buy_price'],
      sellPrice: doc.data()!['sell_price'],
      productBrand: doc.data()!['product_brand'],
      stockCount: doc.data()!['stock_count'],
      time: doc.data()!['timestamp'],
      package: doc.data()!['package'],
      productImage: doc.data()!['product_image'],
    );
  }
}
