import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ReadContacts extends StatefulWidget {
  const ReadContacts({Key? key}) : super(key: key);
  @override
  _ReadContactsState createState() => _ReadContactsState();
}

class _ReadContactsState extends State<ReadContacts> {
  List<Contact>? contacts;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContact();
  }

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact List",
        ),
        centerTitle: true,
        backgroundColor: Colors.white38,
        elevation: 0,
      ),
      body: (contacts) == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 6.0,
                    bottom: 12,
                    left: 12,
                    right: 12,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                    controller: _searchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      label: const Text("Search"),
                      hintText: "Contact name",
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
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: contacts!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Uint8List? image = contacts![index].photo;
                      String num = (contacts![index].phones.isNotEmpty)
                          ? (contacts![index].phones.first.number)
                          : "--";
                      return ListTile(
                          leading: (contacts![index].photo == null)
                              ? const CircleAvatar(child: Icon(Icons.person))
                              : CircleAvatar(
                                  backgroundImage: MemoryImage(image!)),
                          title: Text(
                              "${contacts![index].name.first} ${contacts![index].name.last}"),
                          subtitle: Text(num),
                          onTap: () {});
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
