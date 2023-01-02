import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pointofsales/Models/SalesModel.dart';

import 'SalesDetails.dart';

class SearchSales extends StatefulWidget {
  const SearchSales({Key? key}) : super(key: key);

  @override
  State<SearchSales> createState() => _SearchSalesState();
}

class _SearchSalesState extends State<SearchSales> {
  @override
  void initState() {
    // TODO: implement initState
    _searchController.text = '';
    searchString = _searchController.text;
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();

  String searchString = '';

  Stream<List<SalesModel>> allSalesStream() {
    final _db = FirebaseFirestore.instance;
    if (searchString == '') {
      try {
        return _db.collection('sales').snapshots().map((element) {
          final List<SalesModel> dataFromFireStore = <SalesModel>[];
          for (final DocumentSnapshot<Map<String, dynamic>> doc
              in element.docs) {
            dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
          }
          return dataFromFireStore;
        });
      } catch (e) {
        rethrow;
      }
    } else {
      try {
        return _db.collection('sales').snapshots().map((element) {
          final List<SalesModel> dataFromFireStore = <SalesModel>[];
          for (final DocumentSnapshot<Map<String, dynamic>> doc
              in element.docs) {
            if (doc
                .data()!['customer_name']
                .toLowerCase()
                .contains(searchString.toLowerCase())) {
              dataFromFireStore.add(SalesModel.fromDocumentSnapshot(doc: doc));
            }
          }
          return dataFromFireStore;
        });
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white38,
        title: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black54,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      searchString = value;
                    });
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search...",
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  setState(() {
                    searchString = '';
                    _searchController.text = '';
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(Icons.clear),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<List<SalesModel>>(
        stream: allSalesStream(),
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
                              customerName: saleSnapshot.customerName,
                              dueAmount: saleSnapshot.dueAmount,
                              totalAmount: saleSnapshot.totalAmount,
                              amountPaid: saleSnapshot.amountPaid,
                              discountAmount: saleSnapshot.discountAmount,
                              transId: saleSnapshot.transId,
                              id: saleSnapshot.id,
                              paymentType: saleSnapshot.paymentType,
                              itemCount: saleSnapshot.itemCount,
                              productsList: saleSnapshot.productsList,
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
                                color: Colors.lightBlueAccent.withOpacity(0.3),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("NO: ${saleSnapshot.transId!}"),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0, bottom: 4),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                                '${saleSnapshot.totalAmount}'),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: saleSnapshot.dueAmount == 0
                                            ? const Icon(
                                                Icons.done_all_rounded,
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
                                                child: Text('Customer:')),
                                            Expanded(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
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
                                              child: Text('Items:'),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                      '${saleSnapshot.itemCount}'),
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
    );
  }
}
