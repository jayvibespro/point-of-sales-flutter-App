import 'package:flutter/material.dart';
import 'package:pointofsales/pages/Reports/DueReports.dart';
import 'package:pointofsales/pages/Reports/PurchasesReports.dart';
import 'package:pointofsales/pages/Reports/SalesReports.dart';

class Reports extends StatelessWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white38,
        title: const Text(
          'Reports',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        // popup menu button
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PurchasesReports(),
                  ),
                );
              },
              leading: Icon(Icons.monetization_on_outlined),
              title: Text('Purchases Reports'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SalesReports(),
                  ),
                );
              },
              leading: Icon(Icons.shopping_cart),
              title: Text('Sales Reports'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DueReports(),
                  ),
                );
              },
              leading: Icon(Icons.list_alt),
              title: Text('Due Reports'),
              trailing: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
