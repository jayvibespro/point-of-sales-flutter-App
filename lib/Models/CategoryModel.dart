import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;
  String category;

  CategoryModel({
    required this.id,
    required this.category,
  });

  factory CategoryModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return CategoryModel(
      id: doc.id,
      category: doc.data()!['category'],
    );
  }
}

class CategoryCountModel {
  String? id;
  String? category;
  int? count;

  CategoryCountModel({
    this.id,
    required this.category,
    required this.count,
  });
}
