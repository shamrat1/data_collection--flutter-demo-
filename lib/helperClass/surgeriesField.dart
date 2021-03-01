import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:data_collection/players.dart';
import 'package:flutter/material.dart';


class SurgeryTextField extends StatefulWidget {
   final int index;
  SurgeryTextField(this.index);
  @override
  _SurgeryTextFieldState createState() => _SurgeryTextFieldState();
}

 class _SurgeryTextFieldState extends State<SurgeryTextField> {
  TextEditingController _surgeryNameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _surgeryNameController = TextEditingController();
  }

  @override
  void dispose() {
    _surgeryNameController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // ignore: non_constant_identifier_names
      var _HospitalState;
      _surgeryNameController.text = _HospitalState.surgeryList[widget.index] ?? '';
    });
    var _HospitalState;
    return TextFormField(
      controller:
          _surgeryNameController, // save text field data in friends list at index
      // whenever text field value changes
      onChanged: (v) => _HospitalState.surgeryList[widget.index] = v,
      decoration: InputDecoration(hintText: 'Add a unique code: Surgery Details\''),
      validator: (v) {
        if (v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
