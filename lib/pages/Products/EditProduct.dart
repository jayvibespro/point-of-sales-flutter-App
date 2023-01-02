import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../Models/CategoryModel.dart';
import '../../Models/ProductModel.dart';
import '../../Services/CategoryServices.dart';
import '../../Services/ProductServices.dart';

class EditProduct extends StatefulWidget {
  EditProduct({Key? key, required this.product}) : super(key: key);

  final ProductModel product;

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final TextEditingController _productNameController = TextEditingController();

  final TextEditingController _productBrandController = TextEditingController();

  final TextEditingController _buyPriceController = TextEditingController();

  final TextEditingController _sellPriceController = TextEditingController();

  final TextEditingController _stockCountController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _categoryController = TextEditingController();

  String _packageValue = 'Package';

  String _category = '';

  List<String> list = [
    'Package',
    'Pcs',
    'Box',
    'Ctn',
    'Ltr',
    'Kg',
    'Pair',
    'Dozen',
    'Bag',
    'Gram',
    'Roll'
  ];

  UploadTask? task;
  File? image;
  String _productImage = '';

  Stream<List<CategoryModel>> categoryStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("categories")
          .orderBy('category', descending: true)
          .snapshots()
          .map((element) {
        final List<CategoryModel> dataFromFireStore = <CategoryModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(CategoryModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future pickImage(ImageSource source) async {
    try {
      var image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick imag: $e');
    }

    if (image == null) return;

    final imageName = image!.path;

    final destination = 'images/$imageName';

    var snapshot = await FirebaseStorage.instance
        .ref()
        .child(destination)
        .putFile(image!)
        .whenComplete(() => null);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      _productImage = downloadUrl;
    });
  }

  Future uploadImage() async {
    if (image == null) return;

    final imageName = image!.path;

    final destination = 'images/$imageName';

    Reference referenceImageToUpdate =
        FirebaseStorage.instance.refFromURL(widget.product.productImage!);

    var snapshot = await referenceImageToUpdate
        .child(destination)
        .putFile(image!)
        .whenComplete(() => null);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      _productImage = downloadUrl;
    });
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
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Select Image',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12,
                    top: 4,
                    bottom: 0,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      pickImage(ImageSource.camera);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(Icons.camera),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text('Open Camera'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12,
                    top: 4,
                    bottom: 0,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      pickImage(ImageSource.gallery);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(Icons.photo),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text('Select from gallery'),
                          ),
                        ],
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

    categoryBottomSheet(BuildContext context) {
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
                  padding: EdgeInsets.only(top: 12.0),
                  child: Center(
                    child: Text(
                      'Select Category',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 12.0, bottom: 24, left: 12, right: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _categoryController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            label: const Text("Category"),
                            hintText: "Category",
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.redAccent),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.black54),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            CategoryServices(
                              id: '',
                              category: _categoryController.text,
                            ).createCategory();
                          },
                          child: const Text('Add Category'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<CategoryModel>>(
                    stream: categoryStream(),
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
                              CategoryModel? categorySnapshot =
                                  snapshot.data![index];
                              return Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          _categoryController.text =
                                              categorySnapshot.category;
                                          _category = categorySnapshot.category;
                                          Navigator.pop(context);
                                        });
                                      },
                                      title:
                                          Text('${categorySnapshot.category}'),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
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
        },
      );
    }

    _productNameController.text = widget.product.productName!;
    _productBrandController.text = widget.product.productBrand!;
    _buyPriceController.text = widget.product.buyPrice!.toString();
    _sellPriceController.text = widget.product.sellPrice!.toString();
    _stockCountController.text = widget.product.stockCount!.toString();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white38,
        centerTitle: true,
        title: const Text(
          'Edit Product',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 6.0,
              bottom: 12,
              left: 12,
              right: 12,
            ),
            child: TextField(
              controller: _productNameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                label: const Text("Name*"),
                hintText: "Product name...",
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
          Padding(
            padding: const EdgeInsets.only(
              top: 6.0,
              bottom: 12,
              left: 12,
              right: 12,
            ),
            child: TextField(
              controller: _productBrandController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                label: const Text("Brand*"),
                hintText: "Product brand...",
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
          Padding(
            padding: const EdgeInsets.only(
              top: 6.0,
              bottom: 12,
              left: 12,
              right: 12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 12,
                    ),
                    child: TextField(
                      controller: _buyPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: const Text("Buying Price*"),
                        hintText: "200...",
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Colors.redAccent),
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
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 0,
                      left: 12,
                      right: 0,
                    ),
                    child: TextField(
                      controller: _sellPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: const Text("Selling Price*"),
                        hintText: "230...",
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Colors.redAccent),
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
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 6.0,
              bottom: 12,
              left: 12,
              right: 12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 12,
                    ),
                    child: TextField(
                      controller: _stockCountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: const Text("Stock*"),
                        hintText: "20...",
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Colors.redAccent),
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
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 0,
                      left: 12,
                      right: 0,
                    ),
                    child: TextField(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(), //get today's date
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2030));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                          String formattedDate = DateFormat('yyyy-MM-dd').format(
                              pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                          print(
                              formattedDate); //formatted date output using intl package =>  2022-07-04
                          //You can format date as per your need

                          setState(() {
                            _dateController.text =
                                formattedDate; //set foratted date to TextField value.
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                      controller: _dateController,
                      keyboardType: TextInputType.datetime,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: const Text("Date"),
                        hintText: "Select date...",
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Colors.redAccent),
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
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 6.0,
              bottom: 12,
              left: 12,
              right: 12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 12,
                    ),
                    child: Container(
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black54,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: DropdownButton<String>(
                          value: _packageValue,
                          icon: const Icon(Icons.arrow_drop_down_sharp),
                          elevation: 4,
                          underline: Container(
                            height: 0,
                            color: Colors.transparent,
                          ),
                          style: const TextStyle(color: Colors.black87),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              _packageValue = value!;
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
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 0,
                      left: 12,
                      right: 0,
                    ),
                    child: TextField(
                      onTap: () {
                        categoryBottomSheet(context);
                      },
                      controller: _categoryController,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: const Text("Category*"),
                        hintText: "Category",
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Colors.redAccent),
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
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Center(
              child: Text('Select New Product Image'),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  customBottomSheet(context);
                },
                child: CircleAvatar(
                  radius: 100,
                  child: ClipOval(
                    child: image != null
                        ? Image.file(
                            image!,
                            fit: BoxFit.cover,
                            width: 200.0,
                            height: 200.0,
                          )
                        : Image.network(
                            widget.product.productImage!,
                            fit: BoxFit.cover,
                            width: 200.0,
                            height: 200.0,
                          ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                var buyPrice = int.parse(_buyPriceController.text);
                var sellPrice = int.tryParse(_sellPriceController.text);
                var stockCount = int.parse(_stockCountController.text);

                if (_packageValue == 'Package') {
                  setState(() {
                    _packageValue = widget.product.package!;
                  });
                } else {
                  return;
                }
                if (_category == '') {
                  setState(() {
                    _categoryController.text = widget.product.category!;
                    _category = widget.product.category!;
                  });
                } else {
                  return;
                }

                uploadImage;

                ProductService(
                  id: widget.product.id!,
                  productName: _productNameController.text,
                  productBrand: _productBrandController.text,
                  package: _packageValue,
                  productImage: _productImage,
                  buyPrice: buyPrice,
                  sellPrice: sellPrice!,
                  stockCount: stockCount,
                  category: _category,
                ).editProduct();
              },
              child: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}
