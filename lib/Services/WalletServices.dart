import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../Models/CategoryModel.dart';

class WalletServices {
  String? id;
  int? totalIncome;
  int? totalExpenses;
  int? totalDue;
  int? orders;
  List<CategoryCountModel>? categoryCount;

  String? dayId;
  String? dayTotalIncome;
  String? dayTotalExpenses;
  String? dayTotalDue;
  int? day;
  String? dayDate;
  int? dayOrders;
  List<CategoryCountModel>? dayCategoryCount;

  String? monthId;
  int? monthTotalIncome;
  int? monthTotalExpenses;
  int? monthTotalDue;
  int? month;
  String? monthDate;
  int? monthOrders;
  List<CategoryCountModel>? monthCategoryCount;

  String? yearId;
  int? yearTotalIncome;
  int? yearTotalExpenses;
  int? yearTotalDue;
  int? yearOrders;
  int? year;
  List<CategoryCountModel>? yearCategoryCount;

  createWallet() async {
    var db = FirebaseFirestore.instance;

    try {
      await db.collection('wallet').add({
        'total_income': 0,
        'total_expenses': 0,
        'total_due': 0,
        'orders': 0,
        'category_count': [],
      });
    } catch (e) {}

    try {
      await db.collection('day_wallet').add({
        'total_income': 0,
        'total_expenses': 0,
        'total_due': 0,
        'orders': 0,
        'category_count': [],
        'date': int.parse(DateFormat('EEE').format(DateTime.now())),
        'day': int.parse(DateFormat('yyyMMdd').format(DateTime.now())),
      });
    } catch (e) {}

    try {
      await db.collection('month_wallet').add({
        'total_income': 0,
        'total_expenses': 0,
        'total_due': 0,
        'orders': 0,
        'category_count': [],
        'date': int.parse(DateFormat('MMM').format(DateTime.now())),
        'day': int.parse(DateFormat('yyyMM').format(DateTime.now())),
      });
    } catch (e) {}

    try {
      await db.collection('year_wallet').add({
        'total_income': 0,
        'total_expenses': 0,
        'total_due': 0,
        'orders': 0,
        'category_count': [],
        'day': int.parse(DateFormat('yyy').format(DateTime.now())),
      });
    } catch (e) {}
  }
}
