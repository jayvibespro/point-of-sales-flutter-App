import 'package:flutter/material.dart';

class PurchasesReports extends StatelessWidget {
  const PurchasesReports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white38,
        title: const Text(
          'Purchases Reports',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        // popup menu button
      ),
    );
  }
}
