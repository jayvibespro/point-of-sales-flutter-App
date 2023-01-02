import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pointofsales/Services/SalesServices.dart';

import '../../Models/CategoryModel.dart';

class SalesDetails extends StatelessWidget {
  SalesDetails({
    Key? key,
    required this.customerName,
    required this.dueAmount,
    required this.totalAmount,
    required this.discountAmount,
    required this.amountPaid,
    required this.transId,
    required this.paymentType,
    required this.itemCount,
    required this.productsList,
    required this.id,
    required this.customerID,
    required this.year,
    required this.month,
    required this.day,
    required this.isPaid,
  }) : super(key: key);

  String? id;
  String? customerName;
  String? customerID;
  bool isPaid;
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

  final TextEditingController _dueAmountController = TextEditingController();

  deleteSaleBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Warning',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'You are about to delete this Sale record from you collection. Do you want to proceed?',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'No',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          SalesService(
                            id: id,
                            transId: transId,
                            isPaid: isPaid,
                            customerName: customerName,
                            customerID: customerID,
                            productsList: productsList,
                            dueAmount: dueAmount,
                            totalAmount: totalAmount,
                            paymentType: paymentType,
                            itemCount: itemCount,
                            discountAmount: discountAmount,
                            amountPaid: amountPaid,
                            time: time,
                            year: year,
                            month: month,
                            day: day,
                          ).deleteSales();

                          var _db = FirebaseFirestore.instance;
                          // ********* UPDATING WALLET INFORMATION*******

                          String walletId = '';
                          int totalWalletIncome = 0;
                          int totalWalletDue = 0;
                          int totalWalletOrders = 0;
                          List<CategoryCountModel> walletCategoryCount = [];

                          await _db.collection('wallet').get().then((value) {
                            value.docs.forEach((element) {
                              walletId = element.id;
                              totalWalletIncome =
                                  element.data()['total_income'] - totalAmount;
                              totalWalletDue =
                                  element.data()['total_due'] - dueAmount;
                              totalWalletOrders = element.data()['orders'] - 1;
                            });
                          });
                          await _db.collection('wallet').doc(walletId).update({
                            'total_income': totalWalletIncome,
                            'total_due': totalWalletDue,
                            'orders': totalWalletOrders,
                          });

                          // ********* UPDATING DAY WALLET INFORMATION*******

                          String dayWalletId = '';
                          int dayWalletIncome = 0;
                          int dayWalletDue = 0;
                          int dayWalletOrders = 0;
                          List<CategoryCountModel> dayCategoryCount = [];

                          await _db
                              .collection('day_wallet')
                              .where('day', isEqualTo: day)
                              .get()
                              .then((value) async {
                            value.docs.forEach((element) {
                              dayWalletId = element.id;
                              dayWalletIncome =
                                  element.data()['total_income'] - totalAmount;
                              dayWalletDue =
                                  element.data()['total_due'] - dueAmount;
                              dayWalletOrders = element.data()['orders'] - 1;
                            });
                            await _db
                                .collection('day_wallet')
                                .doc(dayWalletId)
                                .update({
                              'total_income': dayWalletIncome,
                              'total_due': dayWalletDue,
                              'orders': dayWalletOrders,
                            });
                          });

                          // ********* UPDATING MONTH WALLET INFORMATION*******

                          String monthWalletId = '';
                          int monthWalletIncome = 0;
                          int monthWalletDue = 0;
                          int monthWalletOrders = 0;
                          List<CategoryCountModel> monthCategoryCount = [];

                          await _db
                              .collection('month_wallet')
                              .where('month', isEqualTo: month)
                              .get()
                              .then((value) async {
                            value.docs.forEach((element) {
                              monthWalletId = element.id;
                              monthWalletIncome =
                                  element.data()['total_income'] - totalAmount;
                              monthWalletDue =
                                  element.data()['total_due'] - dueAmount;
                              monthWalletOrders = element.data()['orders'] - 1;
                            });

                            await _db
                                .collection('month_wallet')
                                .doc(monthWalletId)
                                .update({
                              'total_income': monthWalletIncome,
                              'total_due': monthWalletDue,
                              'orders': monthWalletOrders,
                            });
                          });

                          // ********* UPDATING YEAR WALLET INFORMATION  *******

                          String yearWalletId = '';
                          int yearWalletIncome = 0;
                          int yearWalletDue = 0;
                          int yearWalletOrders = 0;
                          List<CategoryCountModel> yearCategoryCount = [];

                          await _db
                              .collection('year_wallet')
                              .where('year', isEqualTo: year)
                              .get()
                              .then((value) async {
                            value.docs.forEach((element) {
                              yearWalletId = element.id;
                              yearWalletIncome =
                                  element.data()['total_income'] - totalAmount;
                              yearWalletDue =
                                  element.data()['total_due'] + dueAmount;
                              yearWalletOrders = element.data()['orders'] - 1;
                            });

                            await _db
                                .collection('year_wallet')
                                .doc(yearWalletId)
                                .update({
                              'total_income': yearWalletIncome,
                              'total_due': yearWalletDue,
                              'orders': yearWalletOrders,
                            });
                          });
                        },
                        child: const Text(
                          'Delete',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  optionsBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Select Action',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    payBottomSheet(context);
                  },
                  leading: const Icon(
                    Icons.done_all_rounded,
                    color: Colors.green,
                  ),
                  title: const Text('Pay'),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(
                    Icons.edit,
                  ),
                  title: const Text('Edit'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    deleteSaleBottomSheet(context);
                  },
                  leading: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: const Text('Delete'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  payBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
            ),
          ),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Pay Amount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _dueAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "20,000",
                    label: const Text("Pay Amount"),
                    focusedBorder: OutlineInputBorder(
                      //<-- SEE HERE
                      borderSide:
                          const BorderSide(width: 1, color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.redAccent),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black54),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        _dueAmountController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var db = FirebaseFirestore.instance;
                        int dueAmount = 0;
                        int paidAmount = 0;
                        int temp = 0;

                        try {
                          await db.collection('sales').get().then((value) {
                            value.docs.forEach((element) {
                              if (element.id == id) {
                                temp = element.data()['due_amount'];
                                dueAmount = element.data()['due_amount'] -
                                    int.parse(_dueAmountController.text);
                                paidAmount = element.data()['amount_paid'] +
                                    int.parse(_dueAmountController.text);
                              } else {
                                return;
                              }
                            });
                          });

                          await db.collection('sales').doc(id).update({
                            'amount_paid': paidAmount,
                            'due_amount': dueAmount,
                            'is_paid':
                                temp == int.parse(_dueAmountController.text)
                                    ? true
                                    : false,
                          });
                        } catch (e) {}

                        _dueAmountController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Pay'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white38,
        title: const Text(
          'Sale Details',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        // popup menu button
        actions: [
          isPaid
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        deleteSaleBottomSheet(context);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              : IconButton(
                  onPressed: () {
                    optionsBottomSheet(context);
                  },
                  icon: const Icon(Icons.more_vert_rounded),
                ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1, //
                  color: Colors.grey.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${transId}"),
                        Text('12/07/2022'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 8,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(child: Text('Customer:')),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(customerName!),
                              ],
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 4),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text('Total Amount:'),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(totalAmount.toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 4),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text('Items:'),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(itemCount.toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1, //
                  color: Colors.grey.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      bottom: 16,
                      top: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Items"),
                        Text("QTY"),
                        Text('Amount'),
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: productsList.map((product) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    product['product-name'],
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      product['items-count'].toString(),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        product['price'].toString(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1, //
                  color: Colors.grey.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 4),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text('Amount Paid:'),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(amountPaid.toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 4),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(child: Text('Discount Amount:')),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(discountAmount.toString()),
                              ],
                            )),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 4),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(child: Text('Due Amount:')),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  dueAmount.toString(),
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            )),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 4),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(child: Text('Payment Type:')),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(paymentType!),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
