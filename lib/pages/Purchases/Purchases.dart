import 'package:flutter/material.dart';

import 'PurchaseQrScanner.dart';

class Purchases extends StatelessWidget {
  const Purchases({Key? key}) : super(key: key);

  addPurchaseBottomSheet(BuildContext context) {
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
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Add new Purchase',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              ListTile(
                onTap: () {},
                title: const Text('Input Manually'),
                trailing: const Icon(Icons.edit),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const PurchaseQrScanner(),
                  ));
                },
                title: const Text('Scan QR Code'),
                trailing: const Icon(Icons.qr_code_scanner_outlined),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white38,
        centerTitle: true,
        title: const Text(
          'Purchases',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: ElevatedButton(
              onPressed: () {
                addPurchaseBottomSheet(context);
              },
              child: const Text('Add Purchase'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
