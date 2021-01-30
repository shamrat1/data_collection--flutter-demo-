import 'package:flutter/material.dart';

class SurgeriTextField extends StatefulWidget {
  final int index;
  SurgeriTextField(this.index);

  @override
  _SurgeriTextFieldState createState() => _SurgeriTextFieldState();
}

class _SurgeriTextFieldState extends State<SurgeriTextField> {
  TextEditingController _surgeyNameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _surgeyNameController = TextEditingController();
  }

  @override
  void dispose() {
    _surgeyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // ignore: non_constant_identifier_names
      var _HospitalState;
      _surgeyNameController.text = _HospitalState.friendsList[widget.index] ?? '';
    });
    var _HospitalState;
    return TextFormField(
      controller:
          _surgeyNameController, // save text field data in friends list at index
      // whenever text field value changes
      onChanged: (v) => _HospitalState.friendsList[widget.index] = v,
      decoration: InputDecoration(hintText: 'Add a unique code: Surgery Name\''),
      validator: (v) {
        if (v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
