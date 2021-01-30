import 'package:flutter/material.dart';

class FriendTextFields extends StatefulWidget {
  final int index;
  FriendTextFields(this.index);
  @override
  _FriendTextFieldsState createState() => _FriendTextFieldsState();
}

class _FriendTextFieldsState extends State<FriendTextFields> {
  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // ignore: non_constant_identifier_names
      var _HospitalState;
      _nameController.text = _HospitalState.friendsList[widget.index] ?? '';
    });
    var _HospitalState;
    return TextFormField(
      controller:
          _nameController, // save text field data in friends list at index
      // whenever text field value changes
      onChanged: (v) => _HospitalState.friendsList[widget.index] = v,
      decoration: InputDecoration(hintText: 'Add a unique code: Service Name\''),
      validator: (v) {
        if (v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
