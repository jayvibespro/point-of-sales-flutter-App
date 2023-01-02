import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pointofsales/Models/CustomersModel.dart';
import 'package:pointofsales/pages/Customers/ReadContacts.dart';
import 'package:pointofsales/pages/Sales/SelectProduct.dart';

import '../../Models/ProductModel.dart';
import '../../Services/CustomerServices.dart';

class SelectCustomer extends StatefulWidget {
  SelectCustomer({Key? key}) : super(key: key);

  @override
  State<SelectCustomer> createState() => _SelectCustomerState();
}

class _SelectCustomerState extends State<SelectCustomer> {
  @override
  void initState() {
    // TODO: implement initState
    _searchController.text = '';
    searchString = _searchController.text;
    super.initState();
  }

  final TextEditingController _customerNameController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _searchController = TextEditingController();

  String searchString = '';

  Stream<List<CustomerModel>> customersStream() {
    final _db = FirebaseFirestore.instance;
    if (searchString == '') {
      try {
        return _db.collection('customers').snapshots().map((element) {
          final List<CustomerModel> dataFromFireStore = <CustomerModel>[];
          for (final DocumentSnapshot<Map<String, dynamic>> doc
              in element.docs) {
            dataFromFireStore.add(CustomerModel.fromDocumentSnapshot(doc: doc));
          }
          return dataFromFireStore;
        });
      } catch (e) {
        rethrow;
      }
    } else {
      try {
        return _db.collection('customers').snapshots().map((element) {
          final List<CustomerModel> dataFromFireStore = <CustomerModel>[];
          for (final DocumentSnapshot<Map<String, dynamic>> doc
              in element.docs) {
            if (doc
                .data()!['customer_name']
                .toLowerCase()
                .contains(searchString.toLowerCase())) {
              dataFromFireStore
                  .add(CustomerModel.fromDocumentSnapshot(doc: doc));
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
    customBottomSheet(BuildContext context) {
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
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Add new Customer',
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
                    controller: _customerNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline),
                      hintText: "Customer Name",
                      label: const Text("Name"),
                      focusedBorder: OutlineInputBorder(
                        //<-- SEE HERE
                        borderSide: const BorderSide(
                            width: 1, color: Colors.blueAccent),
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
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.call),
                      hintText: "0694 059 968",
                      label: const Text("Phone"),
                      focusedBorder: OutlineInputBorder(
                        //<-- SEE HERE
                        borderSide: const BorderSide(
                            width: 1, color: Colors.blueAccent),
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
                          CustomerServices(
                            id: '',
                            customerName: _customerNameController.text,
                            phoneNumber: _phoneNumberController.text,
                            time: DateTime.now(),
                          ).createCustomer();
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () async {
                      var result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ReadContacts(),
                        ),
                      );
                      _customerNameController.text = result.name.first;
                      _phoneNumberController.text = result.phones.first.number;
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.green,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(
                              1.0,
                              1.0,
                            ),
                            blurRadius: 2.0,
                            spreadRadius: 1.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ), //BoxShadow
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Import from PhoneBook',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white38,
        title: const Text(
          'Select a Customer',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
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
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.black54,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchString = value;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Search",
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 0, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 0, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 0, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.text = '';
                          searchString = '';
                        });
                      },
                      icon: const Icon(Icons.clear)),
                ],
              ),
            ),
          ),
          searchString != ''
              ? SizedBox()
              : ListTile(
                  onTap: () async {
                    List<ProductsTempModel> products = [];
                    try {
                      await FirebaseFirestore.instance
                          .collection('products')
                          .get()
                          .then((value) {
                        List<ProductModel> productList = [];
                        for (final DocumentSnapshot<Map<String, dynamic>> doc
                            in value.docs) {
                          productList
                              .add(ProductModel.fromDocumentSnapshot(doc: doc));
                        }
                        productList.forEach((element) {
                          products.add(ProductsTempModel(
                            value: false,
                            id: element.id,
                            productName: element.productName,
                            productBrand: element.productBrand,
                            productImage: element.productImage,
                            package: element.package,
                            price: element.sellPrice,
                            itemCount: 0,
                            stockCount: element.stockCount,
                            category: element.category,
                          ));
                        });
                        return products;
                      });
                    } catch (e) {
                      rethrow;
                    }

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => SelectProduct(
                          customerName: 'Customer',
                          customerId: '',
                          productList: products,
                        ),
                      ),
                    );
                  },
                  leading: const CircleAvatar(
                    child: Icon(Icons.person_outline),
                  ),
                  title: const Text('Customer'),
                  subtitle: const Text('_ _ _ _ _ _ _ _ _ _'),
                  trailing: const Icon(Icons.chevron_right),
                ),
          Expanded(
            child: StreamBuilder<List<CustomerModel>>(
              stream: customersStream(),
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
                        CustomerModel? customerSnapshot = snapshot.data![index];
                        return ListTile(
                          onTap: () async {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => const Center(
                                    child: CircularProgressIndicator()));
                            List<ProductsTempModel> products = [];
                            try {
                              await FirebaseFirestore.instance
                                  .collection('products')
                                  .get()
                                  .then((value) {
                                List<ProductModel> productList = [];
                                for (final DocumentSnapshot<
                                    Map<String, dynamic>> doc in value.docs) {
                                  productList.add(
                                      ProductModel.fromDocumentSnapshot(
                                          doc: doc));
                                }
                                productList.forEach((element) {
                                  products.add(ProductsTempModel(
                                    value: false,
                                    id: element.id,
                                    productName: element.productName,
                                    productBrand: element.productBrand,
                                    productImage: element.productImage,
                                    package: element.package,
                                    price: element.sellPrice,
                                    itemCount: 0,
                                    stockCount: element.stockCount,
                                    category: element.category,
                                  ));
                                });
                                return products;
                              });
                            } catch (e) {
                              rethrow;
                            }

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => SelectProduct(
                                  customerName: customerSnapshot.customerName,
                                  customerId: customerSnapshot.id,
                                  productList: products,
                                ),
                              ),
                            );
                          },
                          leading: const CircleAvatar(
                            child: Icon(Icons.person_outline),
                          ),
                          title: Text('${customerSnapshot.customerName}'),
                          subtitle: Text('${customerSnapshot.phoneNumber}'),
                          trailing: const Icon(Icons.chevron_right),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          customBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
