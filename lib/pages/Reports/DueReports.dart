import 'package:flutter/material.dart';

class DueReports extends StatelessWidget {
  const DueReports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white38,
        title: const Text(
          'Due Reports',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        // popup menu button
      ),
    );
  }
}
