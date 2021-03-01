import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class AutoCompleteDemo extends StatefulWidget {
  @override
  _AutoCompleteDemoState createState() => _AutoCompleteDemoState();
}

class _AutoCompleteDemoState extends State<AutoCompleteDemo> {
  final hospitalNameEng = TextEditingController();
  final _serviceKey = GlobalKey<FormState>();
  static List<String> friendsList = [];
  File imageFile;
  String servicejson;
  bool loading = true;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              //margin: const EdgeInsets.only(bottom:5.0),
              child: TextField(
                controller: hospitalNameEng,
                decoration:
                    InputDecoration(hintText: 'Hospital Name In English'),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            //service
            Container(
              child: Form(
                key: _serviceKey,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Services',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      //..._getServices(),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          //send to server
            Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.green)),
                      onPressed: () async {
                        
                      },
                      child: Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //services
  // List<Widget> _getServices() {
  //   List<Widget> friendsTextFieldsList = [];
  //   for (int i = 0; i < friendsList.length; i++) {
  //     friendsTextFieldsList.add(Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 16.0),
  //       child: Row(
  //         children: [
  //           Expanded(child: FriendTextFields(i)),
  //           SizedBox(
  //             width: 16,
  //           ),
  //           // we need add button at last friends row only
  //           _addRemoveButton(i == friendsList.length - 1, i),
  //         ],
  //       ),
  //     ));
  //   }
  //   return friendsTextFieldsList;
  // }

  // Widget _addRemoveButton(bool add, int index) {
  //   return InkWell(
  //     onTap: () {
  //       if (add) {
  //         // add new text-fields at the top of all friends textfields
  //         friendsList.insert(0, null);
  //       } else
  //         friendsList.removeAt(index);
  //       setState(() {});
  //     },
  //     child: Container(
  //       width: 30,
  //       height: 30,
  //       decoration: BoxDecoration(
  //         color: (add) ? Colors.green : Colors.red,
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       child: Icon(
  //         (add) ? Icons.add : Icons.remove,
  //         color: Colors.white,
  //       ),
  //     ),
  //   );
  // }


}
