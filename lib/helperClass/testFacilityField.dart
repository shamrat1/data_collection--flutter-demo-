import 'package:flutter/material.dart';

class TestFacilityTextField extends StatefulWidget {
  final int index;
  TestFacilityTextField(this.index);
  @override
  _TestFacilityTextFieldState createState() => _TestFacilityTextFieldState();
}

class _TestFacilityTextFieldState extends State<TestFacilityTextField> {
  TextEditingController _testFacilityNameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _testFacilityNameController = TextEditingController();
  }

  @override
  void dispose() {
    _testFacilityNameController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // ignore: non_constant_identifier_names
      var _HospitalState;
      _testFacilityNameController.text = _HospitalState.testFacilityList[widget.index] ?? '';
    });
    var _HospitalState;
    return TextFormField(
      controller:
          _testFacilityNameController, // save text field data in friends list at index
      // whenever text field value changes
      onChanged: (v) => _HospitalState.testFacilityList[widget.index] = v,
      decoration: InputDecoration(hintText: 'Add a unique code: Test Facility Details\''),
      validator: (v) {
        if (v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
