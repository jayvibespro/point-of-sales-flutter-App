import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pointofsales/pages/Products/CreateProduct.dart';

class Sales extends StatelessWidget {
  const Sales({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white38,
          title: const Text(
            'Sales',
            style: TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
          // popup menu button
          actions: [
            PopupMenuButton<int>(
              icon: const Icon(Icons.filter_alt_outlined),
              itemBuilder: (context) => [
                // popupmenu item 1
                const PopupMenuItem(
                  value: 1,
                  // row has two child icon and text.
                  child: Text('Today'),
                ),
                // popupmenu item 2
                const PopupMenuItem(
                  value: 2,
                  // row has two child icon and text
                  child: Text('Week'),
                ),
                const PopupMenuItem(
                  value: 3,
                  // row has two child icon and text
                  child: Text('Month'),
                ),
                const PopupMenuItem(
                  value: 4,
                  // row has two child icon and text
                  child: Text('Limit'),
                ),
              ],
              offset: const Offset(0, 10),
              elevation: 1,
            ),
          ],

          bottom: const TabBar(
            tabs: [
              Tab(
                text: "All",
              ),
              Tab(
                text: "Paid",
              ),
              Tab(
                text: "Due",
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
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const ProductDetails(),
                    //   ),
                    // );
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
              child: const Center(
                child: Text('Paid'),
              ),
            ),
            Container(
              child: const Center(
                child: Text('Due'),
              ),
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
