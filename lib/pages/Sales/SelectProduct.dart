import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointofsales/Models/ProductModel.dart';
import 'package:pointofsales/pages/Sales/OrderSummary.dart';

import '../Products/CreateProduct.dart';

class SelectProduct extends StatefulWidget {
  SelectProduct({
    Key? key,
    required this.customerName,
    required this.customerId,
    required this.productList,
  }) : super(key: key);

  List<ProductsTempModel> productList;
  final String customerName;
  final String customerId;

  @override
  State<SelectProduct> createState() => _SelectProductState();
}

class _SelectProductState extends State<SelectProduct> {
  @override
  void initState() {
    // TODO: implement initState
    _searchController.text = '';

    items.addAll(widget.productList);
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _stockCountController = TextEditingController();

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
                padding: const EdgeInsets.all(12.0),
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

  List<ProductsTempModel> items = [];

  void filterSearchResults(String query) {
    List<ProductsTempModel> dummySearchList = [];
    dummySearchList.addAll(widget.productList);
    if (query != '') {
      List<ProductsTempModel> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.productName!.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        widget.productList.clear();
        widget.productList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        widget.productList.clear();
        widget.productList.addAll(items);
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white38,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Select Product(s)',
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              widget.customerName,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ],
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                filterSearchResults(value);
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
            child: ListView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: widget.productList.length,
                itemBuilder: (context, index) {
                  ProductsTempModel? product = widget.productList[index];
                  return CheckboxListTile(
                    title: Row(
                      children: [
                        Text('${product.productName}'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '(${product.stockCount})',
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text('${product.price} Tsh'),
                    value: product.value,
                    onChanged: (newValue) {
                      if (product.stockCount == 0) {
                        addProductBottomSheet(context, product.id!);
                      } else {
                        setState(() {
                          product.value = newValue;
                        });
                      }
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: MaterialButton(
              onPressed: () {
                List<ProductsTempModel> newList = [];
                int _totalItems = 0;
                int _totalAmount = 0;

                widget.productList.forEach((element) {
                  if (element.value == true) {
                    newList.add(element);
                  } else {
                    return;
                  }
                });

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => OrderSummary(
                      productList: newList,
                      customerName: widget.customerName,
                      customerId: widget.customerId,
                    ),
                  ),
                );
              },
              color: Colors.lightBlueAccent,
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
