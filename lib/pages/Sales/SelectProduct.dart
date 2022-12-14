import 'package:flutter/material.dart';

import '../Products/CreateProduct.dart';

class SelectProduct extends StatefulWidget {
  const SelectProduct({Key? key}) : super(key: key);

  @override
  State<SelectProduct> createState() => _SelectProductState();
}

class _SelectProductState extends State<SelectProduct> {
  @override
  Widget build(BuildContext context) {
    customBottomSheet(BuildContext context) {
      int _count = 0;
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
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 8),
                  child: Center(
                    child: Text(
                      'Smart Watch',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 0,
                    bottom: 12,
                  ),
                  child: Center(
                    child: Text(
                      'Apple',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Stock Count: 16'),
                  ],
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: InkWell(
                //         borderRadius: BorderRadius.circular(30),
                //         onTap: () {},
                //         child: const CircleAvatar(
                //           backgroundColor: Colors.black54,
                //           child: Center(
                //             child: Padding(
                //               padding: EdgeInsets.only(bottom: 28.0),
                //               child: Icon(
                //                 Icons.minimize,
                //                 color: Colors.white,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: CircleAvatar(
                //         radius: 30,
                //         child: Center(
                //           child: Text(
                //             "${_count}",
                //             style: const TextStyle(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 28,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: InkWell(
                //         borderRadius: BorderRadius.circular(30),
                //         onTap: () {
                //           setState(() {
                //             _count++;
                //           });
                //         },
                //         child: const CircleAvatar(
                //           backgroundColor: Colors.black54,
                //           child: Center(
                //             child: Icon(
                //               Icons.add,
                //               color: Colors.white,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 6.0,
                    bottom: 12,
                    left: 100,
                    right: 100,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      label: const Text("count*"),
                      hintText: "20",
                      alignLabelWithHint: true,
                      focusedBorder: OutlineInputBorder(
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
                        onPressed: () {},
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
          'Select Product',
        ),
        centerTitle: true,
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
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                label: const Text("Search"),
                hintText: "Search Product...",
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
          ListTile(
            onTap: () {
              customBottomSheet(context);
            },
            leading: const CircleAvatar(
              child: Icon(Icons.production_quantity_limits),
            ),
            title: const Text('Smart Watch'),
            subtitle: const Text('Samsung'),
            trailing: const Text('350,000 Tsh'),
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
    );
  }
}
