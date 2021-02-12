import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:data_collection/players.dart';
import 'package:data_collection/players.dart';

class AutoCompleteDemo extends StatefulWidget {

  @override
  _AutoCompleteDemoState createState() => _AutoCompleteDemoState();
}

class _AutoCompleteDemoState extends State<AutoCompleteDemo> {
  GlobalKey<AutoCompleteTextFieldState<Division>> key = new GlobalKey();
  final _formKey = GlobalKey<FormState>();
  static List<String> friendsList = [null];

  // TextEditingController controller = new TextEditingController();
  //int counter = 1;
  //List selectedService = [null];

  void _loadData() async {
    await PlayersViewModel.loadPlayers();
  }

  List<DynamicWidget> listDynamic = [];
  List<String> data = [];

  Icon floatingIcon = new Icon(Icons.add);

  addDynamic() {
    if (data.length != 0) {
      floatingIcon = new Icon(Icons.add);

      data = [];
      listDynamic = [];
      print('if');
    }
    setState(() {});
    if (listDynamic.length >= 50) {
      return;
    }
    listDynamic.add(new DynamicWidget());
  }

  submitData() {
    floatingIcon = new Icon(Icons.arrow_back);
    data = [];
    listDynamic.forEach((widget) => data.add(widget.controller.text));
    setState(() {});
    print(data.length);
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = new Flexible(
        flex: 1,
        child: new Card(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) {
              return new Padding(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      margin: new EdgeInsets.only(left: 10.0),
                      child: new Text("${index + 1} : ${data[index]}"),
                    ),
                    new Divider()
                  ],
                ),
              );
            },
          ),
        ));

    Widget dynamicTextField = new Flexible(
      flex: 2,
      child: new ListView.builder(
        itemCount: listDynamic.length,
        itemBuilder: (_, index) => listDynamic[index],
      ),
    );

    Widget submitButton = new Container(
      child: new RaisedButton(
        onPressed: submitData,
        child: new Padding(
          padding: new EdgeInsets.all(16.0),
          child: new Text('Submit Data'),
        ),
      ),
    );

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Dynamic App'),
        ),
        body: new Container(
          margin: new EdgeInsets.all(10.0),
          child: new Column(
            children: <Widget>[
              data.length == 0 ? dynamicTextField : result,
              data.length == 0 ? submitButton : new Container(),
            ],
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: addDynamic,
          child: floatingIcon,
        ),
      ),
    );
  }
}


class DynamicWidget extends StatelessWidget {
  TextEditingController controller = new TextEditingController();
  AutoCompleteTextField searchTextField;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(8.0),
      // child: new TextField(
      //   controller: controller,
      //   decoration: new InputDecoration(hintText: 'Enter Data '),
      // ),
      child: Column(
        children: [
          Text(
                        'Services',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
          searchTextField = AutoCompleteTextField<Division>(
              controller: controller,
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
                setState() =>
                    searchTextField.textField.controller.text = item.name;
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
        ],
      ),
    );
  }
}
