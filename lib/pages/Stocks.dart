import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointofsales/Models/ProductModel.dart';

import 'Products/CreateProduct.dart';

class Stocks extends StatefulWidget {
  Stocks({Key? key}) : super(key: key);

  @override
  State<Stocks> createState() => _StocksState();
}

class _StocksState extends State<Stocks> {
  @override
  void initState() {
    // TODO: implement initState
    var getData = getStockValues();
    getData;
    super.initState();
  }

  late List<ProductModel> tempList = <ProductModel>[];

  int totalStockItems = 0;

  int totalBuyPrice = 0;

  int totalSellPrice = 0;

  var numberFormatter = NumberFormat.decimalPattern("en_US");

  Future<List<ProductModel>> productsStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db.collection("products").get().then((element) {
        final List<ProductModel> dataFromFireStore = <ProductModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(ProductModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  void getStockValues() async {
    var db = FirebaseFirestore.instance;
    try {
      await db.collection('products').get().then((value) {
        int buy = 0;
        int sell = 0;
        int stock = 0;

        value.docs.forEach((element) {
          print('######printed#####');
          print(element.data()['product_name']);
          setState(() {
            totalStockItems = totalStockItems + 1;
          });

          setState(() {
            buy = element.data()['buy_price'] * element.data()['stock_count'];
            totalBuyPrice = totalBuyPrice + buy;
          });
          setState(() {
            sell = element.data()['sell_price'] * element.data()['stock_count'];
            totalSellPrice = totalSellPrice + sell;
          });
        });
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white38,
        title: const Text(
          'Stock List',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 14.0,
              bottom: 14,
              right: 12,
              left: 12,
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateProduct(),
                  ),
                );
              },
              child: const Text('Add a Product'),
            ),
          ),
        ],
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
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12,
            ),
            child: Container(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 16,
                left: 12,
                right: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: const [
                  Expanded(child: Center(child: Text('Product'))),
                  Expanded(child: Center(child: Text('QNT'))),
                  Expanded(child: Center(child: Text('Purchase Price(TSH)'))),
                  Expanded(child: Center(child: Text('Sale Price(TSH)'))),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ProductModel>>(
              future: productsStream(),
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
                        ProductModel? productSnapshot = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 12.0,
                            right: 12,
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 16,
                              bottom: 16,
                              left: 12,
                              right: 12,
                            ),
                            decoration: BoxDecoration(
                              color: index % 2 == 0
                                  ? Colors.white
                                  : Colors.lightBlueAccent.withOpacity(0.1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Center(
                                        child: Text(
                                            '${productSnapshot.productName}'))),
                                Expanded(
                                    child: Center(
                                        child: Text(
                                            '${numberFormatter.format(productSnapshot.stockCount)}'))),
                                Expanded(
                                    child: Center(
                                        child: Text(
                                            '${numberFormatter.format(productSnapshot.buyPrice)}'))),
                                Expanded(
                                    child: Center(
                                        child: Text(
                                            '${numberFormatter.format(productSnapshot.sellPrice)}'))),
                              ],
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
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 16, bottom: 16, left: 12, right: 12),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(child: Center(child: Text('Total'))),
                  Expanded(
                      child: Center(
                          child: Text(
                              '${numberFormatter.format(totalStockItems)}'))),
                  Expanded(
                      child: Center(
                          child: Text(
                              '${numberFormatter.format(totalBuyPrice)}'))),
                  Expanded(
                      child: Center(
                          child: Text(
                              '${numberFormatter.format(totalSellPrice)}'))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
