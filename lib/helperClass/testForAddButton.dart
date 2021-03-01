import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

import '../players.dart';

class FriendTextFields extends StatefulWidget {
  final int index;
  // final List<String> friendsList;
  FriendTextFields(this.index);
  final GlobalKey<_FriendTextFieldsState> serviceKey = new GlobalKey();
  @override
  _FriendTextFieldsState createState() => _FriendTextFieldsState();
}

class _FriendTextFieldsState extends State<FriendTextFields> {
  GlobalKey<AutoCompleteTextFieldState<Division>> key = new GlobalKey();
  TextEditingController _serviceController;
  AutoCompleteTextField searchTextField;

  void _loadData() async {
    await PlayersViewModel.loadPlayers();
  }

  @override
  void initState() {
    _loadData();
    super.initState();
    _serviceController = TextEditingController();
  }

  @override
  void dispose() {
    _serviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var _HospitalState;
      _serviceController.text = _HospitalState.friendsList[widget.index] ?? '';
    });

    var _HospitalState;
    return TextFormField(
      controller:
          _serviceController, // save text field data in friends list at index
      // whenever text field value changes

      onChanged: (v) => _HospitalState.friendsList[widget.index] = v,
      decoration:
          InputDecoration(hintText: 'Add a unique code: Service Name\''),
      validator: (v) {
        if (v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
