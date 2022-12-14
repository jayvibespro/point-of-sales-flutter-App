import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pointofsales/pages/Products/CreateProduct.dart';
import 'package:pointofsales/pages/Products/ProductDetails.dart';
import 'package:pointofsales/pages/Products/SearchProduct.dart';

class Products extends StatelessWidget {
  const Products({Key? key}) : super(key: key);

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
                text: "Remaining",
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
            ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProductDetails(),
                      ),
                    );
                  },
                  leading: const CircleAvatar(
                    child: Icon(Icons.production_quantity_limits),
                  ),
                  title: const Text('Smart Watch'),
                  subtitle: const Text('20'),
                  trailing: const Text('350,000 Tsh'),
                ),
              ],
            ),
            Container(
              child: Center(
                child: Text('Remaining'),
              ),
            ),
            Container(
              child: Center(
                child: Text('Finished'),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CreateProduct(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
