import 'dart:convert';

import 'package:data_collection/model/Hospitalmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class DoctorData extends StatefulWidget {
  @override
  _DoctorDataState createState() => _DoctorDataState();
}

class _DoctorDataState extends State<DoctorData> {
  var _divisionController = new TextEditingController();
  AutoCompleteTextField searchTextField;
  var jsonResponse, itemCount, dname;
  static List<Divisions> users ;
  GlobalKey<AutoCompleteTextFieldState<Divisions>> key = new GlobalKey();

  // Future<String> getData() async {
  //   // This example uses the Google Books API to search for books about http.
  //   // https://developers.google.com/books/docs/overview
  //   var url = 'http://139.59.112.145/api/registration/helper/hospital';

  //   // Await the http get response, then decode the json-formatted response.
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     jsonResponse = convert.jsonDecode(response.body);
  //     itemCount = jsonResponse['data'];
  //     users = itemCount['divisions'];
  //     print('itemCount: $users.');
  //   } else {
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }
 var user;
  Future getData() async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url = 'http://139.59.112.145/api/registration/helper/hospital';

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      // itemCount = jsonResponse['data'];
      user = jsonResponse['data']['divisions'][0]['name'];

      // Helper helper = new Helper.fromJson(jsonResponse);

      // for (var i = 0; i < helper.data.divisions.length; i++) {
      //   users.add(helper.data.divisions[i]);
      //   print(helper.data.divisions[i].name);
      // }

      print(user);
      print('itemCount: $users.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }







  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          AutoCompleteTextField<Divisions>(
              controller: _divisionController,
              clearOnSubmit: false,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
              itemSubmitted: (item) {
                _divisionController.text = item.name;
              },
              key: key,
              suggestions: users,
              decoration: InputDecoration(hintText: 'Division'),
              itemBuilder: (context, item) {
                return Container(
                  padding: EdgeInsets.all(2.0),
                  child: Row(
                    children: <Widget>[
                      Text(item.name),
                    ],
                  ),
                );
              },
              itemSorter: (a, b) {
                return a.name.compareTo(b.name);
              },
              itemFilter: (item, query) {
                return item.name.toLowerCase().startsWith(query.toLowerCase());
              })
        ],
      ),
    );
  }
}
