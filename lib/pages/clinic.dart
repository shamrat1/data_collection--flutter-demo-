// import 'package:flutter/material.dart';

// class Clinic extends StatefulWidget {
//   @override
//   _ClinicState createState() => _ClinicState();
// }

// class _ClinicState extends State<Clinic> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }
import 'dart:convert';

import 'package:data_collection/getdata/HospitalService.dart';
import 'package:data_collection/model/Hospitalmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class AutoCompleteDemo extends StatefulWidget {
  AutoCompleteDemo() : super();

  final String title = "AutoComplete Demo";

  @override
  _AutoCompleteDemoState createState() => _AutoCompleteDemoState();
}

class _AutoCompleteDemoState extends State<AutoCompleteDemo> {
  AutoCompleteTextField searchTextField;
  TextEditingController controller = new TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<Division>> key = new GlobalKey();
  //static List<Divisions> users = new List<Divisions>();
  bool loading = true;

  void _loadData() async {
    await PlayersViewModel.loadPlayers();
  }

  @override
  void initState() {
    //getUsers();
    _loadData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Center(
          child: new Column(children: <Widget>[
        new Column(children: <Widget>[
          searchTextField = AutoCompleteTextField<Division>(
              style: new TextStyle(color: Colors.black, fontSize: 16.0),
              decoration: new InputDecoration(
                  suffixIcon: Container(
                    width: 85.0,
                    height: 60.0,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                  filled: true,
                  hintText: 'Search Player Name',
                  hintStyle: TextStyle(color: Colors.black)),
              itemSubmitted: (item) {
                setState(() =>
                    searchTextField.textField.controller.text = item.name);
              },
              clearOnSubmit: false,
              key: key,
              suggestions: PlayersViewModel.players,
              itemBuilder: (context, item) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      item.name,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                    ),
                  ],
                );
              },
              itemSorter: (a, b) {
                return a.name.compareTo(b.name);
              },
              itemFilter: (item, query) {
                return item.name.toLowerCase().startsWith(query.toLowerCase());
              }),
        ]),
      ])),
    );
  }
}
