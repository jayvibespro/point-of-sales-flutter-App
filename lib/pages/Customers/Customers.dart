import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pointofsales/Services/CustomerServices.dart';

import '../Models/CustomersModel.dart';
import 'Sales/ReadContacts.dart';

class Customers extends StatelessWidget {
  Customers({Key? key}) : super(key: key);

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  Stream<List<CustomerModel>> customersStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db.collection("customers").snapshots().map((element) {
        final List<CustomerModel> dataFromFireStore = <CustomerModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(CustomerModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
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
                      'Adding new Customer',
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
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ReadContacts(),
                        ),
                      );
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Customers",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    customBottomSheet(context);
                  },
                  child: const Text('New Customer'),
                ),
              ],
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
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              label: const Text("Search"),
              hintText: "Search",
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(50.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.redAccent),
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
                        onTap: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => AddSales(
                          //       customerName: customerSnapshot.customerName,
                          //     ),
                          //   ),
                          // );
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
    );
  }
}
