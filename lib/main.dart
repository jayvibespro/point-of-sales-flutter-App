import 'package:flutter/material.dart';
import 'package:pointofsales/pages/Customers.dart';
import 'package:pointofsales/pages/Home.dart';
import 'package:pointofsales/pages/Purchases.dart';
import 'package:pointofsales/pages/Sales/Sales.dart';
import 'package:pointofsales/pages/Sales/StartNewSales.dart';
import 'package:pointofsales/pages/Settings.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Point of Sales';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlueAccent,

        // Define the default font family.
        fontFamily: 'roboto',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'roboto'),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'roboto'),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white38,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.normal,
          ),
          toolbarHeight: 70,
          iconTheme: IconThemeData(
            color: Colors.black87,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              const EdgeInsets.all(12),
            ),
            backgroundColor: MaterialStateProperty.all(
              Colors.lightBlueAccent,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              const EdgeInsets.all(12),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.lightBlueAccent,
        ),
      ),
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Sales(),
    Purchases(),
    Customers(),
    Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Purchases',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        selectedItemColor: Colors.black87,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const StartNewSales(),
            ),
          );
        },
        child: const Text('SELL'),
      ),
    );
  }
}