import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'dart:convert';
import 'package:data_collection/model/User.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class AutoCompleteDemo extends StatefulWidget {
  AutoCompleteDemo() : super();

  final String title = "AutoComplete Demo";

  @override
  _AutoCompleteDemoState createState() => _AutoCompleteDemoState();
}

class _AutoCompleteDemoState extends State<AutoCompleteDemo> {
  String _mySelection;

  final String url = "http://139.59.112.145/api/registration/helper/hospital";

  List data = List(); //edited line
  var user;

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);
    
    for (int i = 0; i < resBody.toString().length; i++) {
      user = resBody['data']['divisions'][i]['cities']['name'];
     // print('Sample: $user.');
     setState(() {
      data = user;
    });
    }
    

    //print(resBody);

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          new DropdownButton(
            items: data.map((item) {
              return new DropdownMenuItem(
                child: new Text(item['name']),
                value: item['id'].toString(),
              );
            }).toList(),
            onChanged: (newVal) {
              setState(() {
                _mySelection = newVal;
              });
            },
            value: _mySelection,
          ),
        ],
      ),
    );
  }
}
