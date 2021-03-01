import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
final String hint;
final TextEditingController controllers;

CustomTextField(this.hint, this.controllers);

    @override
    Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 2.0, left: 6.0, right: 6.0, bottom: 2.0),
        child: Column(
          children: <Widget>[
            TextField(
                decoration: InputDecoration(hintText: hint),
                controller: controllers),
            SizedBox(height: 4.0),
          ],
        ),
      );
    }
}