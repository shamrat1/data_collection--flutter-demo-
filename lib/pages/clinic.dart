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






///
// return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             //Name
//             Container(
//               //margin: const EdgeInsets.only(bottom:5.0),
//               child: TextField(
//                 decoration:
//                     InputDecoration(hintText: 'Hospital Name In English'),
//               ),
//               padding: EdgeInsets.all(10.0),
//             ),
//             //Name
//             Container(
//               child: TextField(
//                 decoration:
//                     InputDecoration(hintText: 'Hospital Name In Bangla'),
//               ),
//               padding: EdgeInsets.all(10.0),
//             ),
//             //division
//             Container(
//                 width: 300.0,
//                 margin: const EdgeInsets.all(30.0),
//                 child: Column(
//                   children: [
//                     new DropdownButton(
//                       underline: SizedBox(),
//                       isExpanded: true,
//                       icon: Icon(Icons.arrow_drop_down),
//                       hint: Text("  $divisiondropdown"),
//                       items: data.map((item) {
//                         return new DropdownMenuItem(
//                           child: new Text(item['name']),
//                           value: item['id'].toString(),
//                         );
//                       }).toList(),
//                       onChanged: (newVal) {
//                         setState(() {
//                           _mySelection = newVal;
//                         });
//                       },
//                       value: _mySelection,
//                     ),
//                   ],
//                 )),
//             //city
//             Container(
//                 width: 300.0,
//                 margin: const EdgeInsets.all(30.0),
//                 child: Column(
//                   children: [
//                     new DropdownButton(
//                       underline: SizedBox(),
//                       isExpanded: true,
//                       icon: Icon(Icons.arrow_drop_down),
//                       hint: Text("  $citydropdown"),
//                       items: city_data.map((item) {
//                         return new DropdownMenuItem(
//                           child: new Text(item['name']),
//                           value: item['id'].toString(),
//                         );
//                       }).toList(),
//                       onChanged: (cityVal) {
//                         setState(() {
//                           _citySelection = cityVal;
//                         });
//                       },
//                       value: _citySelection,
//                     ),
//                   ],
//                 )),
//             //address
//             Container(
//               child: TextField(
//                 decoration: InputDecoration(hintText: 'Address In English'),
//               ),
//               padding: EdgeInsets.all(10.0),
//             ),
//             //address
//             Container(
//               child: TextField(
//                 decoration: InputDecoration(hintText: 'Address In Bangla'),
//               ),
//               padding: EdgeInsets.all(10.0),
//             ),
//             //Location
//             Container(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   FlatButton(
//                     onPressed: () {
//                       getCurrentLocation();
//                     },
//                     color: Colors.blue[800],
//                     child: Icon(
//                       Icons.location_on,
//                       size: 20.0,
//                       color: Colors.blue,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10.0,
//                   ),
//                   Text(locationmsg),
//                 ],
//               ),
//             ),
//             //branch name
//             Container(
//               child: TextField(
//                 decoration: InputDecoration(hintText: 'Branch Name'),
//               ),
//               padding: EdgeInsets.all(10.0),
//             ),
//             //reciption no
//             Container(
//               child: TextField(
//                 decoration: InputDecoration(hintText: 'Reception No'),
//               ),
//               padding: EdgeInsets.all(10.0),
//             ),
//             //service
//             Container(
//               margin: new EdgeInsets.all(10.0),
//               child: new Column(
//                 children: <Widget>[
//                   Text(
//                     'Services',
//                     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
//                   ),
//                   serviceData.length == 0 ? dynamicTextField : result,
//                   FlatButton(
//                       color: Colors.green,
//                       shape: new RoundedRectangleBorder(
//                           borderRadius: new BorderRadius.circular(50.0)),
//                       onPressed: addDynamic,
//                       child: floatingIcon),
//                   //serviceData.length == 0 ? submitButton : new Container(),
//                 ],
//               ),
//             ),
//             //image
//             Container(
//               child: Center(
//                 child: Column(
//                   children: <Widget>[
//                     RaisedButton(
//                       onPressed: () {
//                         _showChoiceDialog(context);
//                       },
//                       child: Text("Select Image"),
//                     ),
//                     _decideImageView(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
///