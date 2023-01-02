import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Models/ProductModel.dart';
import 'ProductDetails.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({Key? key}) : super(key: key);

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  @override
  void initState() {
    // TODO: implement initState
    _searchController.text = '';
    searchString = _searchController.text;
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();

  String searchString = '';

  Stream<List<ProductModel>> allProductsStream() {
    final _db = FirebaseFirestore.instance;
    if (searchString == '') {
      try {
        return _db.collection('products').snapshots().map((element) {
          final List<ProductModel> dataFromFireStore = <ProductModel>[];
          for (final DocumentSnapshot<Map<String, dynamic>> doc
              in element.docs) {
            dataFromFireStore.add(ProductModel.fromDocumentSnapshot(doc: doc));
          }
          return dataFromFireStore;
        });
      } catch (e) {
        rethrow;
      }
    } else {
      try {
        return _db.collection('products').snapshots().map((element) {
          final List<ProductModel> dataFromFireStore = <ProductModel>[];
          for (final DocumentSnapshot<Map<String, dynamic>> doc
              in element.docs) {
            if (doc
                .data()!['product_name']
                .toLowerCase()
                .contains(searchString.toLowerCase())) {
              dataFromFireStore
                  .add(ProductModel.fromDocumentSnapshot(doc: doc));
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
                    hintText: "Search Product...",
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
      body: StreamBuilder<List<ProductModel>>(
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
                              child: Icon(Icons.production_quantity_limits),
                            ),
                          ),
                    title: Text('${productSnapshot.productName}'),
                    subtitle: Text('${productSnapshot.stockCount}'),
                    trailing: Text('${productSnapshot.sellPrice} Tsh'),
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
