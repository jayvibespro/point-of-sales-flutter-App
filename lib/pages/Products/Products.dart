import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointofsales/Models/ProductModel.dart';
import 'package:pointofsales/pages/Products/CreateProduct.dart';
import 'package:pointofsales/pages/Products/ProductDetails.dart';
import 'package:pointofsales/pages/Products/SearchProduct.dart';

class Products extends StatelessWidget {
  Products({Key? key}) : super(key: key);

  Stream<List<ProductModel>> allProductsStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db.collection("products").snapshots().map((element) {
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

  Stream<List<ProductModel>> nearlyFinishedProductsStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("products")
          .where('stock_count', isLessThanOrEqualTo: 10)
          .snapshots()
          .map((element) {
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

  Stream<List<ProductModel>> finishedProductsStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("products")
          .where('stock_count', isLessThanOrEqualTo: 0)
          .snapshots()
          .map((element) {
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

  var numberFormatter = NumberFormat.decimalPattern("en_US");

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white38,
          title: const Text(
            'Products',
            style: TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SearchProduct(),
                    ),
                  );
                },
                icon: const Icon(Icons.search),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "All",
              ),
              Tab(
                text: "Nearly Finished",
              ),
              Tab(
                text: "Finished",
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          dragStartBehavior: DragStartBehavior.down,
          children: [
            StreamBuilder<List<ProductModel>>(
              stream: allProductsStream(),
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
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetails(product: productSnapshot),
                              ),
                            );
                          },
                          leading: productSnapshot.productImage! != ''
                              ? CircleAvatar(
                                  radius: 24,
                                  child: ClipOval(
                                    child: Image.network(
                                      productSnapshot.productImage!,
                                      fit: BoxFit.fill,
                                      width: 50,
                                    ),
                                  ),
                                )
                              : const CircleAvatar(
                                  radius: 24,
                                  child: Center(
                                    child:
                                        Icon(Icons.production_quantity_limits),
                                  ),
                                ),
                          title: Text('${productSnapshot.productName}'),
                          subtitle: Text(
                              '${numberFormatter.format(productSnapshot.stockCount)}'),
                          trailing: Text(
                              '${numberFormatter.format(productSnapshot.sellPrice)} Tsh'),
                        );
                      });
                } else {
                  return const Center(
                    child: Text('An error occurred...'),
                  );
                }
              },
            ),
            StreamBuilder<List<ProductModel>>(
              stream: nearlyFinishedProductsStream(),
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
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetails(product: productSnapshot),
                              ),
                            );
                          },
                          leading: productSnapshot.productImage! != ''
                              ? CircleAvatar(
                                  radius: 24,
                                  child: ClipOval(
                                    child: Image.network(
                                      productSnapshot.productImage!,
                                      fit: BoxFit.fill,
                                      width: 50,
                                    ),
                                  ),
                                )
                              : const CircleAvatar(
                                  radius: 24,
                                  child: Center(
                                    child:
                                        Icon(Icons.production_quantity_limits),
                                  ),
                                ),
                          title: Text('${productSnapshot.productName}'),
                          subtitle: Text(
                              '${numberFormatter.format(productSnapshot.stockCount)}'),
                          trailing: Text(
                              '${numberFormatter.format(productSnapshot.sellPrice)} Tsh'),
                        );
                      });
                } else {
                  return const Center(
                    child: Text('An error occurred...'),
                  );
                }
              },
            ),
            StreamBuilder<List<ProductModel>>(
              stream: finishedProductsStream(),
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
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetails(product: productSnapshot),
                              ),
                            );
                          },
                          leading: productSnapshot.productImage! != ''
                              ? CircleAvatar(
                                  radius: 24,
                                  child: ClipOval(
                                    child: Image.network(
                                      productSnapshot.productImage!,
                                      fit: BoxFit.fill,
                                      width: 50,
                                    ),
                                  ),
                                )
                              : const CircleAvatar(
                                  radius: 24,
                                  child: Center(
                                    child:
                                        Icon(Icons.production_quantity_limits),
                                  ),
                                ),
                          title: Text('${productSnapshot.productName}'),
                          subtitle: Text(
                              '${numberFormatter.format(productSnapshot.stockCount)}'),
                          trailing: Text(
                              '${numberFormatter.format(productSnapshot.sellPrice)} Tsh'),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreateProduct(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
