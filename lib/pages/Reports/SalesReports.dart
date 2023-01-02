import 'package:flutter/material.dart';

class SalesReports extends StatelessWidget {
  const SalesReports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white38,
        title: const Text(
          'Sales Reports',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        // popup menu button
      ),
    );
  }
}
