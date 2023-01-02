import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  void initState() {
    // TODO: implement initState
    var getData = getTodayStats();
    getData;
    super.initState();
  }

  List<_SalesData> data = [];

  List<_PieData> pieData = [
    _PieData('phone', 200),
    _PieData('food', 123),
    _PieData('accessories', 50),
    _PieData('laptop', 45),
    _PieData('drinks', 135),
  ];

  void getTodayStats() async {
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    var db = FirebaseFirestore.instance;
    await db
        .collection('day_wallet')
        .where('day',
            isEqualTo: int.parse(DateFormat('yyyMMdd').format(DateTime.now())))
        .get()
        .then((value) {
      setState(() {
        data.clear();
      });

      value.docs.forEach((element) {
        setState(() {
          data.add(_SalesData(
              date: element.data()['date'],
              sales: element.data()['total_income']));
        });
      });
    });
    Navigator.of(context).pop();
  }

  void getRangeStats() async {
    var db = FirebaseFirestore.instance;
    await db
        .collection('day_wallet')
        .where('day',
            isGreaterThanOrEqualTo: int.parse(_initialDateController.text))
        .where('day', isLessThanOrEqualTo: int.parse(_finalDateController.text))
        .orderBy('day', descending: false)
        .get()
        .then((value) {
      setState(() {
        data.clear();
      });

      value.docs.forEach((element) {
        setState(() {
          data.add(_SalesData(
              date: element.data()['date'],
              sales: element.data()['total_income']));
        });
      });
    });
  }

  void getMonthStats() async {
    var db = FirebaseFirestore.instance;
    await db
        .collection('day_wallet')
        .orderBy('day', descending: false)
        .get()
        .then((value) {
      setState(() {
        data.clear();
      });
      value.docs.forEach((element) {
        setState(() {
          data.add(_SalesData(
              date: element.data()['date'],
              sales: element.data()['total_income']));
        });
      });
    });
  }

  void getYearStats() async {
    var db = FirebaseFirestore.instance;
    await db
        .collection('month_wallet')
        .orderBy('month', descending: false)
        .get()
        .then((value) {
      setState(() {
        data.clear();
      });
      value.docs.forEach((element) {
        setState(() {
          data.add(_SalesData(
              date: element.data()['date'],
              sales: element.data()['total_income']));
        });
      });
    });
  }

  final TextEditingController _initialDateController = TextEditingController();
  final TextEditingController _finalDateController = TextEditingController();

  selectDateRangeBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Set Date Range',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime(
                          2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2030));

                  if (pickedDate != null) {
                    print(
                        pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                    String formattedDate = DateFormat('yyyyMMdd').format(
                        pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                    print(
                        formattedDate); //formatted date output using intl package =>  2022-07-04
                    //You can format date as per your need

                    setState(() {
                      _initialDateController.text =
                          formattedDate; //set foratted date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
                readOnly: true,
                controller: _initialDateController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_month),
                  hintText: "Initial Date",
                  label: const Text("Initial Date"),
                  focusedBorder: OutlineInputBorder(
                    //<-- SEE HERE
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
                    borderSide:
                        const BorderSide(width: 1, color: Colors.black54),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 6.0,
                bottom: 12,
                left: 12,
                right: 12,
              ),
              child: TextField(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), //get today's date
                    firstDate: DateTime(
                        2000), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    print(
                        pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                    String formattedDate = DateFormat('yyyyMMdd').format(
                        pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                    print(
                        formattedDate); //formatted date output using intl package =>  2022-07-04
                    //You can format date as per your need

                    setState(() {
                      _finalDateController.text =
                          formattedDate; //set foratted date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
                readOnly: true,
                controller: _finalDateController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_month),
                  hintText: "Final Date",
                  label: const Text("Final Date"),
                  focusedBorder: OutlineInputBorder(
                    //<-- SEE HERE
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
                    onPressed: () {
                      Navigator.pop(context);
                      getRangeStats();
                    },
                    child: const Text('Set'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String dropdownValue = 'Filter';

  String chartTitle = 'Today Sales';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white38,
        title: const Text(
          'Statistics',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        // popup menu button
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.calendar_month),
              elevation: 4,
              style: const TextStyle(color: Colors.black87),
              underline: Container(
                height: 0,
                color: Colors.transparent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });

                if (dropdownValue == 'Set Range') {
                  selectDateRangeBottomSheet(context);
                } else if (dropdownValue == 'Today') {
                  setState(() {
                    chartTitle = 'Today Sales';
                  });
                  getTodayStats();
                } else if (dropdownValue == 'Month') {
                  setState(() {
                    chartTitle = 'This Month Sales';
                  });
                  getMonthStats();
                } else if (dropdownValue == 'Year') {
                  setState(() {
                    chartTitle = 'This Year Sales';
                  });
                  getYearStats();
                }
              },
              items: <String>[
                'Filter',
                'Today',
                'Month',
                'Year',
                'Set Range',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          //Initialize the chart widget
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: chartTitle),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_SalesData, String>>[
                LineSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.date,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Sales',
                    // Enable data label
                    dataLabelSettings: const DataLabelSettings(isVisible: true))
              ]),

          Center(
              child: SfCircularChart(
                  title: ChartTitle(text: 'Sales by sales Category'),
                  legend: Legend(isVisible: true),
                  series: <PieSeries<_PieData, String>>[
                PieSeries<_PieData, String>(
                    explode: true,
                    explodeIndex: 0,
                    dataSource: pieData,
                    xValueMapper: (_PieData data, _) => data.xData,
                    yValueMapper: (_PieData data, _) => data.yData,
                    dataLabelMapper: (_PieData data, _) => data.text,
                    dataLabelSettings: DataLabelSettings(isVisible: true)),
              ])),
        ],
      ),
    );
  }
}

class _SalesData {
  _SalesData({required this.date, required this.sales});

  final String date;
  final int sales;
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);
  final String xData;
  final num yData;
  final String? text;
}
