import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pointofsales/Models/ProductModel.dart';
import 'package:pointofsales/main.dart';

import 'TempSelectProduct.dart';

class OrderSummary extends StatefulWidget {
  OrderSummary({
    Key? key,
    required this.productList,
    required this.customerName,
    required this.customerId,
  }) : super(key: key);

  List<ProductsTempModel> productList;
  final String customerName;
  final String customerId;

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  final TextEditingController _itemCountController = TextEditingController();
  final TextEditingController _paidAmountController = TextEditingController();
  final TextEditingController _discountAmountController =
      TextEditingController();
  final TextEditingController _bottomDiscountAmountController =
      TextEditingController();
  final TextEditingController _bottomPaidAmountController =
      TextEditingController();

  String _paymentType = 'Cash';

  var numberFormatter = NumberFormat.decimalPattern("en_US");

  List<String> list = [
    'Cash',
    'Mobile',
    'Check',
    'Bank',
  ];

  List categoryList = [];

  int _subTotal = 0;
  int _discountAmount = 0;
  int _dueAmount = 0;
  int _totalItems = 0;
  int _totalAmount = 0;
  int _paidAmount = 0;

  @override
  Widget build(BuildContext context) {
    discountAmountBottomSheet(BuildContext context) {
      return showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Enter Discount Amount',
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
                    controller: _bottomDiscountAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "20,000",
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
                          setState(() {
                            _discountAmountController.text =
                                _bottomDiscountAmountController.text;
                            _discountAmount =
                                int.parse(_bottomDiscountAmountController.text);
                            _totalAmount = _subTotal - _discountAmount;
                            _dueAmount = _totalAmount - _paidAmount;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
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

    paidAmountBottomSheet(BuildContext context) {
      return showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Enter Paid Amount',
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
                    controller: _bottomPaidAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "100,000",
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
                          setState(() {
                            _paidAmountController.text =
                                _bottomPaidAmountController.text;
                            _paidAmount =
                                int.parse(_bottomPaidAmountController.text);
                            _totalAmount = _subTotal - _discountAmount;
                            _dueAmount = _totalAmount - _paidAmount;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
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

    itemCountBottomSheet(BuildContext context) {
      return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Enter Item Quantity',
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
                    controller: _itemCountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "100",
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
                          setState(() {
                            _itemCountController.clear();
                          });
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
                          int count = 0;
                          if (int.parse(_itemCountController.text) >= 0) {
                            setState(() {
                              count = int.parse(_itemCountController.text);
                              _itemCountController.clear();
                            });
                          } else {
                            Get.snackbar("Warning",
                                "Item count can not be negative value.",
                                snackPosition: SnackPosition.BOTTOM,
                                borderRadius: 20,
                                duration: const Duration(seconds: 4),
                                margin: const EdgeInsets.all(15),
                                isDismissible: true,
                                dismissDirection: DismissDirection.horizontal,
                                forwardAnimationCurve: Curves.easeInOutBack);
                            return;
                          }
                          Navigator.pop(context, count);
                        },
                        child: const Text('Done'),
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white38,
        title: const Text(
          'Order Summary',
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
            child: MaterialButton(
              onPressed: () async {
                var result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TempSelectProduct(),
                  ),
                );

                setState(() {
                  widget.productList.add(ProductsTempModel(
                    value: result['value'],
                    id: result['id'],
                    productName: result['product_name'],
                    productBrand: result['product_brand'],
                    productImage: result['product_image'],
                    package: result['package'],
                    price: result['price'],
                    itemCount: result['item_count'],
                    stockCount: result['stock_count'],
                    category: result['category'],
                  ));
                });
              },
              color: Colors.lightBlueAccent,
              child: const Text(
                'Add item',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
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
                      bottom: 16,
                      top: 16,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Items"),
                        Text("QTY"),
                        Text('Amount'),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: widget.productList
                            .map(
                              (e) => Padding(
                                padding:
                                    const EdgeInsets.only(top: 0, bottom: 4),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text('${e.productName}')),
                                        Expanded(
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      if (e.itemCount != 0) {
                                                        setState(() {
                                                          _subTotal = _subTotal -
                                                              e.price! *
                                                                  e.itemCount!;
                                                          _totalItems =
                                                              _totalItems -
                                                                  e.itemCount!;
                                                          e.itemCount =
                                                              e.itemCount! - 1;
                                                          _subTotal = _subTotal +
                                                              e.price! *
                                                                  e.itemCount!;
                                                          _totalItems =
                                                              _totalItems +
                                                                  e.itemCount!;
                                                          _totalAmount =
                                                              _subTotal -
                                                                  _discountAmount;

                                                          _dueAmount =
                                                              _totalAmount -
                                                                  _paidAmount;
                                                        });
                                                      } else if (e.itemCount! <
                                                          1) {
                                                        setState(() {
                                                          widget.productList
                                                              .remove(e);
                                                        });
                                                      }
                                                    },
                                                    child: const CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      child: Center(
                                                          child: Text(
                                                        '-',
                                                      )),
                                                    )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 2.0, right: 2),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      int result =
                                                          await itemCountBottomSheet(
                                                              context);

                                                      setState(() {
                                                        _totalItems =
                                                            _totalItems -
                                                                e.itemCount!;

                                                        _subTotal = _subTotal -
                                                            e.itemCount! *
                                                                e.price!;

                                                        e.itemCount = result;
                                                        _totalItems =
                                                            _totalItems +
                                                                e.itemCount!;

                                                        _subTotal = _subTotal +
                                                            e.itemCount! *
                                                                e.price!;

                                                        _totalAmount =
                                                            _subTotal -
                                                                _discountAmount;
                                                        _dueAmount =
                                                            _totalAmount -
                                                                _paidAmount;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: Colors.black12,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 8,
                                                                bottom: 8,
                                                                left: 8.0,
                                                                right: 8),
                                                        child: Text(
                                                            '${e.itemCount}'),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (e.itemCount ==
                                                            e.stockCount) {
                                                          Get.snackbar(
                                                              "Message",
                                                              "This item is out of stock.",
                                                              snackPosition:
                                                                  SnackPosition
                                                                      .BOTTOM,
                                                              borderRadius: 20,
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          4),
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              isDismissible:
                                                                  true,
                                                              dismissDirection:
                                                                  DismissDirection
                                                                      .horizontal,
                                                              forwardAnimationCurve:
                                                                  Curves
                                                                      .easeInOutBack);
                                                        } else {
                                                          _subTotal = _subTotal -
                                                              e.price! *
                                                                  e.itemCount!;
                                                          _totalItems =
                                                              _totalItems -
                                                                  e.itemCount!;
                                                          e.itemCount =
                                                              e.itemCount! + 1;
                                                          _subTotal = _subTotal +
                                                              e.price! *
                                                                  e.itemCount!;
                                                          _totalItems =
                                                              _totalItems +
                                                                  e.itemCount!;
                                                          _totalAmount =
                                                              _subTotal -
                                                                  _discountAmount;
                                                          _dueAmount =
                                                              _totalAmount -
                                                                  _paidAmount;
                                                        }
                                                      });
                                                    },
                                                    child: const CircleAvatar(
                                                      radius: 12,
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(numberFormatter.format(
                                                e.price! * e.itemCount!)),
                                          ],
                                        )),
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
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
                      bottom: 16,
                      top: 16,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Sub Total"),
                        Text(numberFormatter.format(_subTotal)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, top: 14, bottom: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Item(s)"),
                        Text(numberFormatter.format(_totalItems)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12, top: 6, bottom: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Discount"),
                        Container(
                          width: 100,
                          child: TextField(
                            readOnly: true,
                            onTap: () {
                              discountAmountBottomSheet(context);
                            },
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (_subTotal > int.parse(value)) {
                                setState(() {
                                  _discountAmount = int.parse(value);
                                  _totalAmount = _subTotal - _discountAmount;
                                });
                              } else {
                                return;
                              }
                            },
                            controller: _discountAmountController,
                            decoration: const InputDecoration(
                              hintText: '0',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12, top: 6, bottom: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Amount"),
                        Text(numberFormatter.format(_totalAmount)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12, top: 6, bottom: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Paid Amount"),
                        Container(
                          width: 100,
                          child: TextField(
                            readOnly: true,
                            onTap: () {
                              paidAmountBottomSheet(context);
                            },
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                if (_totalAmount > int.parse(value)) {
                                  _dueAmount = _totalAmount - int.parse(value);
                                } else {
                                  return;
                                }
                              });
                            },
                            controller: _paidAmountController,
                            decoration: const InputDecoration(
                              hintText: '0',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12, top: 6, bottom: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Due Amount"),
                        Text(numberFormatter.format(_dueAmount)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12, top: 6, bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Payment Type"),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12),
                          child: DropdownButton<String>(
                            value: _paymentType,
                            icon: const Icon(Icons.arrow_drop_down_sharp),
                            elevation: 4,
                            style: const TextStyle(color: Colors.black87),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                _paymentType = value!;
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 24),
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
                  onPressed: () async {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()));
                    var _db = FirebaseFirestore.instance;

                    String walletId = '';
                    int totalWalletIncome = 0;
                    int totalWalletDue = 0;
                    int totalWalletOrders = 0;

                    String dayWalletId = '';
                    int dayWalletIncome = 0;
                    int dayWalletDue = 0;
                    int dayWalletOrders = 0;

                    String monthWalletId = '';
                    int monthWalletIncome = 0;
                    int monthWalletDue = 0;
                    int monthWalletOrders = 0;

                    String yearWalletId = '';
                    int yearWalletIncome = 0;
                    int yearWalletDue = 0;
                    int yearWalletOrders = 0;

                    String name = widget.customerName;
                    String customerId = widget.customerId;
                    List list = [];
                    widget.productList.forEach((element) {
                      if (element.itemCount != 0) {
                        list.add({
                          'product-id': element.id,
                          'product-name': element.productName,
                          'items-count': element.itemCount,
                          'price': element.price,
                          'product-brand': element.productBrand,
                          'category': element.category,
                        });
                      } else {
                        return;
                      }
                    });

                    if (_subTotal != 0 && _totalItems != 0) {
                      await _db.collection('products').get().then((value) {
                        value.docs.forEach((element) {
                          list.forEach((item) {
                            if (element.data()['product_name'] ==
                                item['product-name']) {
                              _db
                                  .collection('products')
                                  .doc(element.id)
                                  .update({
                                'stock_count': element.data()['stock_count'] -
                                    item['items-count']
                              });
                            }
                          });
                        });
                      });
                      print('##### PRINTING CATEGORY ######');
                      print(categoryList);
                      categoryList.forEach((element) {
                        print(element['category']);
                      });

                      await _db
                          .collection('sales_by_category')
                          .get()
                          .then((value) {
                        if (value.docs.isNotEmpty) {
                        } else {
                          categoryList.forEach((e) async {
                            await _db.collection('sales_by_category').add({
                              'category': e['category'],
                              'count': 1,
                            });
                          });
                        }
                      });

                      // SalesService(
                      //   id: '',
                      //   isPaid: _dueAmount == 0 ? true : false,
                      //   customerName: name,
                      //   customerID: customerId,
                      //   productsList: list,
                      //   transId: nanoid(8),
                      //   dueAmount: _dueAmount,
                      //   totalAmount: _totalAmount,
                      //   paymentType: _paymentType,
                      //   itemCount: _totalItems,
                      //   discountAmount: _discountAmount,
                      //   amountPaid: _paidAmount,
                      //   time: Timestamp.now(),
                      //   year:
                      //       int.parse(DateFormat('yyy').format(DateTime.now())),
                      //   month: int.parse(
                      //       DateFormat('yyyMM').format(DateTime.now())),
                      //   day: int.parse(
                      //       DateFormat('yyyMMdd').format(DateTime.now())),
                      // ).sell();

                      // ********* UPDATING WALLET INFORMATION*******

                      // await _db.collection('wallet').get().then((value) {
                      //   value.docs.forEach((element) {
                      //     walletId = element.id;
                      //     totalWalletIncome =
                      //         element.data()['total_income'] + _totalAmount;
                      //     totalWalletDue =
                      //         element.data()['total_due'] + _dueAmount;
                      //     totalWalletOrders = element.data()['orders'] + 1;
                      //
                      //     element.data()['category_count'].forEach((element) {
                      //       walletCategoryCount.forEach((e) {
                      //         if (element['category'] == e.category) {
                      //           e.count =
                      //               e.count! + int.parse(element['count']);
                      //         } else {
                      //           walletCategoryCount.add(CategoryCountModel(
                      //               category: element['category'],
                      //               count: element['count']));
                      //         }
                      //       });
                      //     });
                      //   });
                      // });
                      // await _db.collection('wallet').doc(walletId).update({
                      //   'total_income': totalWalletIncome,
                      //   'total_due': totalWalletDue,
                      //   'orders': totalWalletOrders,
                      //   'category_count': walletCategoryCount,
                      // });

                      // ********* UPDATING DAY WALLET INFORMATION*******

                      await _db
                          .collection('day_wallet')
                          .where('day',
                              isEqualTo: int.parse(
                                  DateFormat('yyyMMdd').format(DateTime.now())))
                          .get()
                          .then((value) async {
                        if (value.docs.isNotEmpty) {
                          value.docs.forEach((element) {
                            dayWalletId = element.id;
                            dayWalletIncome =
                                element.data()['total_income'] + _totalAmount;
                            dayWalletDue =
                                element.data()['total_due'] + _dueAmount;
                            dayWalletOrders = element.data()['orders'] + 1;
                          });
                          await _db
                              .collection('day_wallet')
                              .doc(dayWalletId)
                              .update({
                            'total_income': dayWalletIncome,
                            'total_due': dayWalletDue,
                            'orders': dayWalletOrders,
                          });
                        } else {
                          await _db.collection('day_wallet').add({
                            'total_income': _totalAmount,
                            'total_due': _dueAmount,
                            'orders': 1,
                            'date': DateFormat('EEE').format(DateTime.now()),
                            'day': int.parse(
                                DateFormat('yyyMMdd').format(DateTime.now())),
                          });
                        }
                      });

                      // ********* UPDATING MONTH WALLET INFORMATION*******

                      await _db
                          .collection('month_wallet')
                          .where('month',
                              isEqualTo: int.parse(
                                  DateFormat('yyyMM').format(DateTime.now())))
                          .get()
                          .then((value) async {
                        if (value.docs.isNotEmpty) {
                          value.docs.forEach((element) {
                            monthWalletId = element.id;
                            monthWalletIncome =
                                element.data()['total_income'] + _totalAmount;
                            monthWalletDue =
                                element.data()['total_due'] + _dueAmount;
                            monthWalletOrders = element.data()['orders'] + 1;
                          });

                          await _db
                              .collection('month_wallet')
                              .doc(monthWalletId)
                              .update({
                            'total_income': monthWalletIncome,
                            'total_due': monthWalletDue,
                            'orders': monthWalletOrders,
                          });
                        } else {
                          await _db.collection('month_wallet').add({
                            'total_income': _totalAmount,
                            'total_due': _dueAmount,
                            'orders': 1,
                            'date': DateFormat('MMM').format(DateTime.now()),
                            'month': int.parse(
                                DateFormat('yyyMM').format(DateTime.now())),
                          });
                        }
                      });

                      // ********* UPDATING YEAR WALLET INFORMATION  *******

                      await _db
                          .collection('year_wallet')
                          .where('year',
                              isEqualTo: int.parse(
                                  DateFormat('yyy').format(DateTime.now())))
                          .get()
                          .then((value) async {
                        if (value.docs.isNotEmpty) {
                          value.docs.forEach((element) {
                            yearWalletId = element.id;
                            yearWalletIncome =
                                element.data()['total_income'] + _totalAmount;
                            yearWalletDue =
                                element.data()['total_due'] + _dueAmount;
                            yearWalletOrders = element.data()['orders'] + 1;

                            element
                                .data()['category_count']
                                .forEach((element) {});
                          });

                          await _db
                              .collection('year_wallet')
                              .doc(yearWalletId)
                              .update({
                            'total_income': yearWalletIncome,
                            'total_due': yearWalletDue,
                            'orders': yearWalletOrders,
                          });
                        } else {
                          await _db.collection('year_wallet').add({
                            'total_income': _totalAmount,
                            'total_due': _dueAmount,
                            'orders': 1,
                            'year': int.parse(
                                DateFormat('yyy').format(DateTime.now())),
                          });
                        }
                      });

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHome(
                              selectedIndex: 1,
                            ),
                          ),
                          (route) => false);
                    } else {
                      Get.snackbar("Message",
                          "Make sure that you have at least one item for sale.",
                          snackPosition: SnackPosition.BOTTOM,
                          borderRadius: 20,
                          duration: const Duration(seconds: 4),
                          margin: const EdgeInsets.all(15),
                          isDismissible: true,
                          dismissDirection: DismissDirection.horizontal,
                          forwardAnimationCurve: Curves.easeInOutBack);
                      return;
                    }
                  },
                  child: const Text(
                    'Save',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
