import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pointofsales/Services/CustomerServices.dart';

import '../../Models/CustomersModel.dart';
import 'ReadContacts.dart';
import 'CustomerSales.dart';

class Customers extends StatefulWidget {
  Customers({Key? key}) : super(key: key);

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
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
    createCustomerBottomSheet(BuildContext context) {
      _customerNameController.clear();
      _phoneNumberController.clear();
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

    editCustomerBottomSheet(
        BuildContext context, String id, String name, String phone) {
      _customerNameController.text = name;
      _phoneNumberController.text = phone;
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
                      'Edit Customer Info',
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
                            id: id,
                            customerName: _customerNameController.text,
                            phoneNumber: _phoneNumberController.text,
                            time: DateTime.now(),
                          ).editCustomer();
                          Navigator.pop(context);
                        },
                        child: const Text('Edit'),
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

    deleteCustomerBottomSheet(BuildContext context, String id) {
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
                        'You are about to delete this Customer from you collection. Do you want to proceed?',
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
                          onPressed: () {
                            CustomerServices(
                              id: id,
                              customerName: '',
                              phoneNumber: '',
                              time: DateTime.now(),
                            ).deleteCustomer();
                            Navigator.pop(context);
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white38,
        centerTitle: true,
        title: const Text(
          'Customers',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: ElevatedButton(
              onPressed: () {
                createCustomerBottomSheet(context);
              },
              child: const Text('New Customer'),
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
                        return Column(
                          children: [
                            ExpansionTile(
                              title: Text('${customerSnapshot.customerName}'),
                              leading: const CircleAvatar(
                                child: Icon(Icons.person_outline),
                              ),
                              childrenPadding: EdgeInsets.only(left: 60),
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CustomerSales(
                                          customerId: customerSnapshot.id,
                                        ),
                                      ),
                                    );
                                  },
                                  title:
                                      Text('${customerSnapshot.customerName}'),
                                  subtitle:
                                      Text('${customerSnapshot.phoneNumber}'),
                                  trailing: Icon(Icons.chevron_right),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          editCustomerBottomSheet(
                                            context,
                                            customerSnapshot.id,
                                            customerSnapshot.customerName,
                                            customerSnapshot.phoneNumber,
                                          );
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          deleteCustomerBottomSheet(
                                            context,
                                            customerSnapshot.id,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
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
