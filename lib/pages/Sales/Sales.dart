import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointofsales/Models/SalesModel.dart';
import 'package:pointofsales/pages/Sales/SalesDetails.dart';

import 'SearchSales.dart';

class Sales extends StatefulWidget {
  const Sales({Key? key}) : super(key: key);

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  Stream<List<SalesModel>> allSalesStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db.collection("sales").snapshots().map((element) {
        final List<SalesModel> dataFromFireStore = <SalesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SalesModel>> paidSalesStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("sales")
          .where('is_paid', isEqualTo: true)
          .snapshots()
          .map((element) {
        final List<SalesModel> dataFromFireStore = <SalesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SalesModel>> dueSalesStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("sales")
          .where('is_paid', isEqualTo: false)
          .snapshots()
          .map((element) {
        final List<SalesModel> dataFromFireStore = <SalesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SalesModel>> allTodaySalesStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("sales")
          .where('day',
              isEqualTo:
                  int.parse(DateFormat('yyyMMdd').format(DateTime.now())))
          .snapshots()
          .map((element) {
        final List<SalesModel> dataFromFireStore = <SalesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SalesModel>> allWeekSalesStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("sales")
          .where('day',
              isLessThanOrEqualTo:
                  int.parse(DateFormat('yyyMMdd').format(DateTime.now())))
          .where('day',
              isGreaterThanOrEqualTo:
                  int.parse(DateFormat('yyyMMdd').format(DateTime.now())) - 7)
          .snapshots()
          .map((element) {
        final List<SalesModel> dataFromFireStore = <SalesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SalesModel>> allMonthSalesStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("sales")
          .where('month',
              isEqualTo: int.parse(DateFormat('yyyMM').format(DateTime.now())))
          .snapshots()
          .map((element) {
        final List<SalesModel> dataFromFireStore = <SalesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SalesModel>> allDateRangeSalesStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("sales")
          .where('day', isGreaterThanOrEqualTo: initialDate)
          .where('day', isLessThanOrEqualTo: finalDate)
          .snapshots()
          .map((element) {
        final List<SalesModel> dataFromFireStore = <SalesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SalesModel>> allTodayPaidSalesStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("sales")
          .where('is_paid', isEqualTo: true)
          .where('day',
              isEqualTo:
                  int.parse(DateFormat('yyyMMdd').format(DateTime.now())))
          .snapshots()
          .map((element) {
        final List<SalesModel> dataFromFireStore = <SalesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SalesModel>> allWeekPaidSalesStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("sales")
          .where('is_paid', isEqualTo: true)
          .where('day',
              isLessThanOrEqualTo:
                  int.parse(DateFormat('yyyMMdd').format(DateTime.now())))
          .where('day',
              isGreaterThanOrEqualTo:
                  int.parse(DateFormat('yyyMMdd').format(DateTime.now())) - 7)
          .snapshots()
          .map((element) {
        final List<SalesModel> dataFromFireStore = <SalesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SalesModel>> allMonthPaidSalesStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("sales")
          .where('is_paid', isEqualTo: true)
          .where('month',
              isEqualTo: int.parse(DateFormat('yyyMM').format(DateTime.now())))
          .snapshots()
          .map((element) {
        final List<SalesModel> dataFromFireStore = <SalesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SalesModel>> allDateRangePaidSalesStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("sales")
          .where('is_paid', isEqualTo: true)
          .where('day', isGreaterThanOrEqualTo: initialDate)
          .where('day', isLessThanOrEqualTo: finalDate)
          .snapshots()
          .map((element) {
        final List<SalesModel> dataFromFireStore = <SalesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SalesModel>> allTodayDueSalesStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("sales")
          .where('is_paid', isEqualTo: false)
          .where('day',
              isEqualTo:
                  int.parse(DateFormat('yyyMMdd').format(DateTime.now())))
          .snapshots()
          .map((element) {
        final List<SalesModel> dataFromFireStore = <SalesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SalesModel>> allWeekDueSalesStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("sales")
          .where('is_paid', isEqualTo: false)
          .where('day',
              isLessThanOrEqualTo:
                  int.parse(DateFormat('yyyMMdd').format(DateTime.now())))
          .where('day',
              isGreaterThanOrEqualTo:
                  int.parse(DateFormat('yyyMMdd').format(DateTime.now())) - 7)
          .snapshots()
          .map((element) {
        final List<SalesModel> dataFromFireStore = <SalesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SalesModel>> allMonthDueSalesStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("sales")
          .where('is_paid', isEqualTo: false)
          .where('month',
              isEqualTo: int.parse(DateFormat('yyyMM').format(DateTime.now())))
          .snapshots()
          .map((element) {
        final List<SalesModel> dataFromFireStore = <SalesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SalesModel>> allDateRangeDueSalesStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("sales")
          .where('is_paid', isEqualTo: false)
          .where('day', isGreaterThanOrEqualTo: initialDate)
          .where('day', isLessThanOrEqualTo: finalDate)
          .snapshots()
          .map((element) {
        final List<SalesModel> dataFromFireStore = <SalesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  int initialDate = 0;
  int finalDate = 0;

  final TextEditingController _initialDateController = TextEditingController();
  final TextEditingController _finalDateController = TextEditingController();

  var numberFormatter = NumberFormat.decimalPattern("en_US");

  selectDateRangeBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Set Date Range',
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
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime(
                          2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2030));

                  if (pickedDate != null) {
                    print(
                        pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      initialDate =
                          int.parse(DateFormat('yyyyMMdd').format(pickedDate));
                    });
                    // format date in required form here we use yyyy-MM-dd that means time is removed
                    print(
                        formattedDate); //formatted date output using intl package =>  2022-07-04
                    //You can format date as per your need
                    setState(() {
                      _initialDateController.text =
                          formattedDate; //set foratted date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
                readOnly: true,
                controller: _initialDateController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_month),
                  hintText: "Initial Date",
                  label: const Text("Initial Date"),
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
              padding: const EdgeInsets.only(
                top: 6.0,
                bottom: 12,
                left: 12,
                right: 12,
              ),
              child: TextField(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), //get today's date
                    firstDate: DateTime(
                        2000), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    print(
                        pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      finalDate =
                          int.parse(DateFormat('yyyyMMdd').format(pickedDate));
                    }); // format date in required form here we use yyyy-MM-dd that means time is removed
                    print(
                        formattedDate); //formatted date output using intl package =>  2022-07-04
                    //You can format date as per your need

                    setState(() {
                      _finalDateController.text =
                          formattedDate; //set foratted date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
                readOnly: true,
                controller: _finalDateController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_month),
                  hintText: "Final Date",
                  label: const Text("Final Date"),
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
                    onPressed: () {
                      setState(() {
                        dropdownValue = 'Set Range';
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Set'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String dropdownValue = 'Today';

  allSalesSelectorFunction() {
    if (dropdownValue == 'Filter') {
      return allSalesStream();
    } else if (dropdownValue == 'Today') {
      return allTodaySalesStream();
    } else if (dropdownValue == 'Week') {
      return allWeekSalesStream();
    } else if (dropdownValue == 'Month') {
      return allMonthSalesStream();
    } else if (dropdownValue == 'Set Range') {
      return allDateRangeSalesStream();
    } else {
      return;
    }
  }

  allPaidSalesSelectorFunction() {
    if (dropdownValue == 'Filter') {
      return paidSalesStream();
    } else if (dropdownValue == 'Today') {
      return allTodayPaidSalesStream();
    } else if (dropdownValue == 'Week') {
      return allWeekPaidSalesStream();
    } else if (dropdownValue == 'Month') {
      return allMonthPaidSalesStream();
    } else if (dropdownValue == 'Set Range') {
      return allDateRangePaidSalesStream();
    } else {
      return;
    }
  }

  allDueSalesSelectorFunction() {
    if (dropdownValue == 'Filter') {
      return dueSalesStream();
    } else if (dropdownValue == 'Today') {
      return allTodayDueSalesStream();
    } else if (dropdownValue == 'Week') {
      return allWeekDueSalesStream();
    } else if (dropdownValue == 'Month') {
      return allMonthDueSalesStream();
    } else if (dropdownValue == 'Set Range') {
      return allDateRangeDueSalesStream();
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white38,
          title: const Text(
            'Sales',
            style: TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
          // popup menu button
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SearchSales(),
                  ),
                );
              },
              icon: const Icon(Icons.search),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.calendar_month),
                elevation: 4,
                style: const TextStyle(color: Colors.black87),
                underline: Container(
                  height: 0,
                  color: Colors.transparent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });

                  if (dropdownValue == 'Set Range') {
                    selectDateRangeBottomSheet(context);
                  }
                },
                items: <String>[
                  'Filter',
                  'Today',
                  'Week',
                  'Month',
                  'Set Range',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],

          bottom: const TabBar(
            tabs: [
              Tab(
                text: "All",
              ),
              Tab(
                text: "Paid",
              ),
              Tab(
                text: "Due",
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: Colors.black54.withOpacity(0.1),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                dragStartBehavior: DragStartBehavior.down,
                children: [
                  StreamBuilder<List<SalesModel>>(
                    stream: allSalesSelectorFunction(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              SalesModel? saleSnapshot = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12, bottom: 12),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SalesDetails(
                                          isPaid: saleSnapshot.isPaid,
                                          customerName:
                                              saleSnapshot.customerName,
                                          dueAmount: saleSnapshot.dueAmount,
                                          totalAmount: saleSnapshot.totalAmount,
                                          amountPaid: saleSnapshot.amountPaid,
                                          discountAmount:
                                              saleSnapshot.discountAmount,
                                          transId: saleSnapshot.transId,
                                          id: saleSnapshot.id,
                                          paymentType: saleSnapshot.paymentType,
                                          itemCount: saleSnapshot.itemCount,
                                          productsList:
                                              saleSnapshot.productsList,
                                          customerID: saleSnapshot.customerID,
                                          year: saleSnapshot.year,
                                          month: saleSnapshot.month,
                                          day: saleSnapshot.day,
                                        ),
                                      ),
                                    );
                                  },
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
                                            bottom: 4,
                                            top: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.lightBlueAccent
                                                .withOpacity(0.3),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "NO: ${saleSnapshot.transId!}"),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0,
                                                            bottom: 4),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                          '${numberFormatter.format(saleSnapshot.totalAmount)}',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: saleSnapshot
                                                                .dueAmount ==
                                                            0
                                                        ? const Icon(
                                                            Icons
                                                                .done_all_rounded,
                                                            color: Colors.green,
                                                          )
                                                        : const Icon(
                                                            Icons.pending,
                                                            color: Colors.red,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0,
                                              right: 12,
                                              top: 12,
                                              bottom: 4),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0, bottom: 4),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Expanded(
                                                            child: Text(
                                                                'Customer:')),
                                                        Expanded(
                                                            child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                                '${saleSnapshot.customerName}'),
                                                          ],
                                                        )),
                                                      ],
                                                    ),
                                                    const Divider(),
                                                  ],
                                                ),
                                              ),
                                              saleSnapshot.isPaid == true
                                                  ? SizedBox()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0,
                                                              bottom: 4),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              const Expanded(
                                                                child: Text(
                                                                    'Due Amount:'),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      numberFormatter
                                                                          .format(
                                                                              saleSnapshot.dueAmount),
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return const Center(
                          child: Text('An error occurred...'),
                        );
                      }
                    },
                  ),
                  StreamBuilder<List<SalesModel>>(
                    stream: allPaidSalesSelectorFunction(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              SalesModel? saleSnapshot = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12, bottom: 12),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SalesDetails(
                                          isPaid: saleSnapshot.isPaid,
                                          customerName:
                                              saleSnapshot.customerName,
                                          dueAmount: saleSnapshot.dueAmount,
                                          totalAmount: saleSnapshot.totalAmount,
                                          amountPaid: saleSnapshot.amountPaid,
                                          discountAmount:
                                              saleSnapshot.discountAmount,
                                          transId: saleSnapshot.transId,
                                          id: saleSnapshot.id,
                                          paymentType: saleSnapshot.paymentType,
                                          itemCount: saleSnapshot.itemCount,
                                          productsList:
                                              saleSnapshot.productsList,
                                          customerID: saleSnapshot.customerID,
                                          year: saleSnapshot.year,
                                          month: saleSnapshot.month,
                                          day: saleSnapshot.day,
                                        ),
                                      ),
                                    );
                                  },
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
                                            bottom: 4,
                                            top: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.lightBlueAccent
                                                .withOpacity(0.3),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "NO: ${saleSnapshot.transId!}"),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0,
                                                            bottom: 4),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                          '${numberFormatter.format(saleSnapshot.totalAmount)}',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: const Icon(
                                                      Icons.done_all_rounded,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0, bottom: 4),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Expanded(
                                                            child: Text(
                                                                'Customer:')),
                                                        Expanded(
                                                            child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                                '${saleSnapshot.customerName}'),
                                                          ],
                                                        )),
                                                      ],
                                                    ),
                                                    const Divider(),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0, bottom: 4),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Expanded(
                                                            child: Text(
                                                                'Paid Amount:')),
                                                        Expanded(
                                                            child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              '${numberFormatter.format(saleSnapshot.amountPaid)}',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return const Center(
                          child: Text('An error occurred...'),
                        );
                      }
                    },
                  ),
                  StreamBuilder<List<SalesModel>>(
                    stream: allDueSalesSelectorFunction(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              SalesModel? saleSnapshot = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12, bottom: 12),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SalesDetails(
                                          isPaid: saleSnapshot.isPaid,
                                          customerName:
                                              saleSnapshot.customerName,
                                          dueAmount: saleSnapshot.dueAmount,
                                          totalAmount: saleSnapshot.totalAmount,
                                          amountPaid: saleSnapshot.amountPaid,
                                          discountAmount:
                                              saleSnapshot.discountAmount,
                                          transId: saleSnapshot.transId,
                                          id: saleSnapshot.id,
                                          paymentType: saleSnapshot.paymentType,
                                          itemCount: saleSnapshot.itemCount,
                                          productsList:
                                              saleSnapshot.productsList,
                                          customerID: saleSnapshot.customerID,
                                          year: saleSnapshot.year,
                                          month: saleSnapshot.month,
                                          day: saleSnapshot.day,
                                        ),
                                      ),
                                    );
                                  },
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
                                            bottom: 4,
                                            top: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.lightBlueAccent
                                                .withOpacity(0.3),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "NO: ${saleSnapshot.transId!}"),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0,
                                                            bottom: 4),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                          '${numberFormatter.format(saleSnapshot.totalAmount)}',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: const Icon(
                                                      Icons.pending,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0, bottom: 4),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Expanded(
                                                            child: Text(
                                                                'Customer:')),
                                                        Expanded(
                                                            child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                                '${saleSnapshot.customerName}'),
                                                          ],
                                                        )),
                                                      ],
                                                    ),
                                                    const Divider(),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0, bottom: 4),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Expanded(
                                                            child: Text(
                                                                'Due Amount:')),
                                                        Expanded(
                                                            child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              '${numberFormatter.format(saleSnapshot.dueAmount)}',
                                                              style:
                                                                  const TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return const Center(
                          child: Text('An error occurred...'),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
