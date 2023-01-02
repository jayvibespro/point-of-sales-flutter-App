import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ReadContacts extends StatefulWidget {
  const ReadContacts({Key? key}) : super(key: key);
  @override
  _ReadContactsState createState() => _ReadContactsState();
}

class _ReadContactsState extends State<ReadContacts> {
  List<Contact> items = [];
  List<Contact>? contacts;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  @override
  void initState() {
    // TODO: implement initState
    _searchController.text = '';
    super.initState();
    getContact();
  }

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      setState(() {
        items.addAll(contacts!);
      });
    }
  }

  void filterSearchResults(String query) {
    List<Contact> dummySearchList = [];
    dummySearchList.addAll(contacts!);
    if (query != '') {
      List<Contact> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.name.first.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        contacts!.clear();
        contacts!.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        contacts!.clear();
        contacts!.addAll(items);
      });
      return;
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
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.black54,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: _searchController,
                            onChanged: (value) {
                              filterSearchResults(value);
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: "Search",
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 0, color: Colors.transparent),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 0, color: Colors.transparent),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 0, color: Colors.transparent),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _searchController.text = '';
                                contacts!.addAll(items);
                              });
                            },
                            icon: const Icon(Icons.clear)),
                      ],
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
                          onTap: () {
                            Navigator.pop(context, contacts![index]);
                          });
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
