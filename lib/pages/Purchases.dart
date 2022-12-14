import 'package:flutter/material.dart';

class Purchases extends StatelessWidget {
  const Purchases({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 12.0, bottom: 12),
          child: Center(
            child: Text(
              "Purchases",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
