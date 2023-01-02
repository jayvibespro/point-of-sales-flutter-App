import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Models/ProductModel.dart';
import '../Products/CreateProduct.dart';

class TempSelectProduct extends StatefulWidget {
  const TempSelectProduct({Key? key}) : super(key: key);

  @override
  State<TempSelectProduct> createState() => _TempSelectProductState();
}

class _TempSelectProductState extends State<TempSelectProduct> {
  @override
  void initState() {
    // TODO: implement initState
    _searchController.text = '';
    searchString = _searchController.text;
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _stockCountController = TextEditingController();

  var numberFormatter = NumberFormat.decimalPattern("en_US");

  String searchString = '';

  Stream<List<ProductModel>> allProductsStream() {
    final _db = FirebaseFirestore.instance;

    if (searchString == '') {
      try {
        return _db
            .collection('products')
            .orderBy('product_name', descending: false)
            .snapshots()
            .map((element) {
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
        return _db
            .collection('products')
            .orderBy('product_name', descending: false)
            .snapshots()
            .map((element) {
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

  addProductBottomSheet(BuildContext context, String id) {
    _stockCountController.text = '';
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'This item is out of stock!. Add it in stock',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _stockCountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Item count",
                    label: const Text("100"),
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
                child: ElevatedButton(
                  onPressed: () async {
                    var db = FirebaseFirestore.instance;
                    if (_stockCountController.text != '') {
                      try {
                        await db.collection('products').doc(id).update({
                          'stock_count': int.parse(_stockCountController.text)
                        });
                        Get.snackbar("Message", "Product added successfully.",
                            snackPosition: SnackPosition.BOTTOM,
                            borderRadius: 20,
                            duration: const Duration(seconds: 4),
                            margin: const EdgeInsets.all(15),
                            isDismissible: true,
                            dismissDirection: DismissDirection.horizontal,
                            forwardAnimationCurve: Curves.easeInOutBack);
                      } catch (e) {}
                      Navigator.pop(context);
                    } else {
                      Get.snackbar(
                        "Message",
                        "An Input field should not be empty.",
                        snackPosition: SnackPosition.BOTTOM,
                        borderRadius: 20,
                        duration: const Duration(seconds: 4),
                        margin: const EdgeInsets.all(15),
                        isDismissible: true,
                        dismissDirection: DismissDirection.horizontal,
                        forwardAnimationCurve: Curves.easeInOutBack,
                      );
                      return;
                    }
                  },
                  child: const Text('Add Item Now'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  addProductOptionBottomSheet(BuildContext context) {
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
          child: Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Add new item or Tap an existing item with "0" count to add it in stock.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => CreateProduct(),
                      ),
                    );
                  },
                  child: const Text('Create new item'),
                ),
              ),
              const SizedBox(
                height: 40,
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
          'Select Product(s)',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                addProductOptionBottomSheet(context);
              },
              child: const Text('Add Item'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 6.0,
              bottom: 12,
              left: 12,
              right: 12,
            ),
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
                label: const Text("Search"),
                hintText: "Search item",
                focusedBorder: OutlineInputBorder(
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
                  borderSide: const BorderSide(width: 1, color: Colors.black54),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ProductModel>>(
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
                            var product = {};
                            product = {
                              'value': true,
                              'id': productSnapshot.id,
                              'product_name': productSnapshot.productName,
                              'product_brand': productSnapshot.productBrand,
                              'product_image': productSnapshot.productImage,
                              'package': productSnapshot.package,
                              'price': productSnapshot.sellPrice,
                              'item_count': 0,
                              'stock_count': productSnapshot.stockCount,
                              'category': productSnapshot.category,
                            };
                            Navigator.pop(context, product);
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
          ),
        ],
      ),
    );
  }
}
