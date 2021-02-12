import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:data_collection/players.dart';

class FinalEdition extends StatefulWidget {
  @override
  _FinalEditionState createState() => _FinalEditionState();
}

class _FinalEditionState extends State<FinalEdition> {
  GlobalKey<AutoCompleteTextFieldState<Division>> key = new GlobalKey();
  final _formKey = GlobalKey<FormState>();
  static List<String> friendsList = [null];

  //final List<GlobalObjectKey<FormState>> formKeyList = List.generate(10, (index) => GlobalObjectKey<FormState>(index));
  final List<GlobalObjectKey<AutoCompleteTextFieldState<Division>>> keyplus =
      List.generate(
          50,
          (index) =>
              GlobalObjectKey<AutoCompleteTextFieldState<Division>>(index));

  AutoCompleteTextField searchTextField;

  TextEditingController controller = new TextEditingController();
  int counter = 1;
  List selectedService = [null];

  void _loadData() async {
    await PlayersViewModel.loadPlayers();
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              searchTextField = AutoCompleteTextField<Division>(
                  style: new TextStyle(color: Colors.black, fontSize: 16.0),
                  decoration: new InputDecoration(
                      suffixIcon: Container(
                        width: 85.0,
                        height: 60.0,
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                      filled: true,
                      hintText: 'Search Player Name',
                      hintStyle: TextStyle(color: Colors.black)),
                  itemSubmitted: (item) {
                    setState(() =>
                        searchTextField.textField.controller.text = item.name);
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
                    return item.name
                        .toLowerCase()
                        .startsWith(query.toLowerCase());
                  }
                  ),
            ],
          ),
        ),
      ),
    );
  }

  //  Container(
  //   padding: EdgeInsets.all(1),
  //   width: MediaQuery.of(context).size.width,
  //   decoration: BoxDecoration(
  //     border: Border.all(),
  //     borderRadius: BorderRadius.all(Radius.circular(15.0) //
  //         ),
  //   ),
  //   child:
  //    searchTextField = AutoCompleteTextField<Division>(
  //       style: new TextStyle(color: Colors.black, fontSize: 16.0),
  //       decoration: new InputDecoration(
  //           suffixIcon: Container(
  //             width: 85.0,
  //             height: 60.0,
  //           ),
  //           contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
  //           filled: true,
  //           hintText: 'Search Player Name',
  //           hintStyle: TextStyle(color: Colors.black)),
  //       itemSubmitted: (item) {
  //         setState(
  //             () => searchTextField.textField.controller.text = item.name);
  //       },
  //       clearOnSubmit: false,
  //       key: key,
  //       suggestions: PlayersViewModel.players,
  //       itemBuilder: (context, item) {
  //         return Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: <Widget>[
  //             Text(
  //               item.name,
  //               style: TextStyle(fontSize: 16.0),
  //             ),
  //             Padding(
  //               padding: EdgeInsets.all(15.0),
  //             ),
  //           ],
  //         );
  //       },
  //       itemSorter: (a, b) {
  //         return a.name.compareTo(b.name);
  //       },
  //       itemFilter: (item, query) {
  //         return item.name.toLowerCase().startsWith(query.toLowerCase());
  //       }),
  // );

}
