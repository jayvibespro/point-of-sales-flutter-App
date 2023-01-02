import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? id;
  String? productName;
  String? productBrand;
  String? productImage;
  String? package;
  String? category;
  int? buyPrice;
  int? sellPrice;
  int? stockCount;
  // DateTime time;

  ProductModel({
    required this.id,
    required this.productImage,
    required this.package,
    required this.productName,
    required this.productBrand,
    required this.buyPrice,
    required this.category,
    required this.sellPrice,
    required this.stockCount,
    // required this.time,
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
      // time: doc.data()!['timestamp'],
      category: doc.data()!['category'],
      package: doc.data()!['package'],
      productImage: doc.data()!['product_image'],
    );
  }
}

class ProductsTempModel {
  bool? value;
  String? id;
  String? productName;
  String? productBrand;
  String? productImage;
  String? package;
  int? price;
  int? itemCount;
  int? stockCount;
  String? category;

  ProductsTempModel({
    required this.value,
    required this.id,
    required this.productName,
    required this.productBrand,
    required this.productImage,
    required this.package,
    required this.price,
    required this.itemCount,
    required this.stockCount,
    required this.category,
  });
}
