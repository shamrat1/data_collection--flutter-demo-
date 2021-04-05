
import 'package:data_collection/pages/clinic.dart';
import 'package:data_collection/pages/doctor.dart';
import 'package:data_collection/pages/hospital.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Data Collection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Data Collection'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  @override
  void initState() {
   
    super.initState();
    _controller = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        title: Text(widget.title), centerTitle: true,

        bottom: TabBar(
          controller: _controller,
          tabs: [
            Tab(
              text: "Doctor",
            ),
            Tab(
              text: "Hospital",
            ),
            Tab(
              text: "Clinic",
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          Doctor(),
          Hospital(),
          Clinic(),
        ],
      ),
    );
  }
}
