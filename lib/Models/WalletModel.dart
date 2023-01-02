import 'package:cloud_firestore/cloud_firestore.dart';

import 'CategoryModel.dart';

class WalletModel {
  String? id;
  int? totalIncome;
  int? totalExpenses;
  int? totalDue;
  int? orders;
  List<CategoryCountModel>? categoryCount;

  WalletModel({
    required this.id,
    required this.totalDue,
    required this.totalExpenses,
    required this.totalIncome,
    required this.orders,
    required this.categoryCount,
  });

  factory WalletModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return WalletModel(
      id: doc.id,
      totalDue: doc.data()!['total_due'],
      totalExpenses: doc.data()!['total_expenses'],
      totalIncome: doc.data()!['total_income'],
      orders: doc.data()!['orders'],
      categoryCount: doc.data()!['category_count'],
    );
  }
}

class DayWalletModel {
  String? id;
  int? totalIncome;
  int? totalExpenses;
  int? totalDue;
  String? date;
  int? day;
  int? orders;
  List<CategoryCountModel>? categoryCount;

  DayWalletModel({
    required this.id,
    required this.totalDue,
    required this.totalExpenses,
    required this.totalIncome,
    required this.day,
    required this.orders,
    required this.categoryCount,
    required this.date,
  });

  factory DayWalletModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return DayWalletModel(
      id: doc.id,
      totalDue: doc.data()!['total_due'],
      totalExpenses: doc.data()!['total_expenses'],
      totalIncome: doc.data()!['total_income'],
      day: doc.data()!['day'],
      orders: doc.data()!['orders'],
      categoryCount: doc.data()!['category_count'],
      date: doc.data()!['date'],
    );
  }
}

class MonthWalletModel {
  String? id;
  int? totalIncome;
  int? totalExpenses;
  int? totalDue;
  int? month;
  String? date;
  int? orders;
  List<CategoryCountModel>? categoryCount;

  MonthWalletModel({
    required this.id,
    required this.totalDue,
    required this.totalExpenses,
    required this.totalIncome,
    required this.month,
    required this.orders,
    required this.categoryCount,
    required this.date,
  });

  factory MonthWalletModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return MonthWalletModel(
      id: doc.id,
      totalDue: doc.data()!['total_due'],
      totalExpenses: doc.data()!['total_expenses'],
      totalIncome: doc.data()!['total_income'],
      month: doc.data()!['month'],
      orders: doc.data()!['orders'],
      categoryCount: doc.data()!['category_count'],
      date: doc.data()!['date'],
    );
  }
}

class YearWalletModel {
  String? id;
  int? totalIncome;
  int? totalExpenses;
  int? totalDue;
  int? totalProfit;
  int? year;
  int? orders;
  List<CategoryCountModel>? categoryCount;

  YearWalletModel({
    required this.id,
    required this.totalDue,
    required this.totalExpenses,
    required this.totalIncome,
    required this.totalProfit,
    required this.year,
    required this.orders,
    required this.categoryCount,
  });

  factory YearWalletModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return YearWalletModel(
      id: doc.id,
      totalDue: doc.data()!['total_due'],
      totalExpenses: doc.data()!['total_expenses'],
      totalIncome: doc.data()!['total_income'],
      totalProfit: doc.data()!['total_profit'],
      year: doc.data()!['year'],
      orders: doc.data()!['orders'],
      categoryCount: doc.data()!['category_count'],
    );
  }
}
