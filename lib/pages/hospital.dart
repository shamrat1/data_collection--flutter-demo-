import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:data_collection/helperClass/surgeriesField.dart';
import 'package:data_collection/helperClass/testFacilityField.dart';
import 'package:data_collection/helperClass/testForAddButton.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:data_collection/model/Hospitalmodel.dart';
import 'package:data_collection/getdata/HospitalService.dart' as Hservice;
import 'package:image_picker/image_picker.dart';

class Hospital extends StatefulWidget {
  @override
  _HospitalState createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  var locationmsg = " ";
  File imageFile;

  // for map
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator.getLastKnownPosition();
    print(lastPosition);

    setState(() {
      locationmsg = "$position";
    });
  }

  //for camera
  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a Choice"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  //retrive data
  List<Division> _divitions;

  //service, test_facility, surgery
  final _formKey = GlobalKey<FormState>();
  final _surveyKey = GlobalKey<FormState>();
  final _testFacilityKey = GlobalKey<FormState>();
  // TextEditingController _nameController;
  static List<String> friendsList = [null];
  static List<String> surgeryList = [null];
  static List<String> testFacilityList = [null];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //service, test_facility, surgery
    // _nameController = TextEditingController();
    Hservice.HospitalService.getAllData().then((divisions) {
      setState(() {
        _divitions = divisions;
      });
    });
  }

  //autoCompleteTextView test
  var _divisionController = new TextEditingController();
  var _cityController = new TextEditingController();
  List division = ["Dhaka", "Chittagong", "Sylhet"];
  List city = ["Mirpur", "Dhanmondi", "Gulshan"];

  //service, test_facility, surgery
  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   super.dispose();
  // }

  Widget _decideImageView() {
    if (imageFile == null) {
      return Text("No Image Selected");
    } else {
      Image.file(
        imageFile,
        width: 400,
        height: 400,
      );
    }
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
                decoration:
                    InputDecoration(hintText: 'Hospital Name In English'),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            Container(
              child: TextField(
                decoration:
                    InputDecoration(hintText: 'Hospital Name In Bangla'),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  AutoCompleteTextField(
                      controller: _divisionController,
                      clearOnSubmit: false,
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                      itemSubmitted: (item) {
                        _divisionController.text = item;
                      },
                      key: null,
                      suggestions: division,
                      decoration: InputDecoration(hintText: 'Division'),
                      itemBuilder: (context, item) {
                        return Container(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            children: <Widget>[
                              Text(item),
                            ],
                          ),
                        );
                      },
                      itemSorter: (a, b) {
                        return a.compareTo(b);
                      },
                      itemFilter: (item, query) {
                        return item
                            .toLowerCase()
                            .startsWith(query.toLowerCase());
                      })
                ],
              ),
              padding: EdgeInsets.all(10.0),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  AutoCompleteTextField(
                      controller: _cityController,
                      clearOnSubmit: false,
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                      itemSubmitted: (cityItem) {
                        _cityController.text = cityItem;
                      },
                      key: null,
                      suggestions: city,
                      decoration: InputDecoration(hintText: 'City'),
                      itemBuilder: (context, cityItem) {
                        return Container(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            children: <Widget>[
                              Text(cityItem),
                            ],
                          ),
                        );
                      },
                      itemSorter: (c, d) {
                        return c.compareTo(d);
                      },
                      itemFilter: (cityItem, query) {
                        return cityItem
                            .toLowerCase()
                            .startsWith(query.toLowerCase());
                      })
                ],
              ),
              padding: EdgeInsets.all(10.0),
            ),
            Container(
              child: TextField(
                decoration: InputDecoration(hintText: 'Address In English'),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            Container(
              child: TextField(
                decoration: InputDecoration(hintText: 'Address In Bangla'),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      getCurrentLocation();
                    },
                    color: Colors.blue[800],
                    child: Icon(
                      Icons.location_on,
                      size: 20.0,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(locationmsg),
                ],
              ),
            ),
            Container(
              child: Form(
                key: _formKey,
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
                      ..._getFriends(),
                      SizedBox(
                        height: 20,
                      ),
                      //  FlatButton(
                      //    onPressed: (){
                      //      if(_formKey.currentState.validate()){
                      //         _formKey.currentState.save();
                      //         }
                      //         },
                      //         child: Text('Submit'),
                      //         color: Colors.green,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Form(
                key: _surveyKey,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Surgey',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      ..._getSurgeries(),
                      SizedBox(
                        height: 20,
                      ),
                      //  FlatButton(
                      //    onPressed: (){
                      //      if(_surveyKey.currentState.validate()){
                      //         _surveyKey.currentState.save();
                      //         }
                      //         },
                      //         child: Text('Submit'),
                      //         color: Colors.green,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Form(
                key: _testFacilityKey,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test Facility',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      ..._getTestFacilities(),
                      SizedBox(
                        height: 20,
                      ),
                      //  FlatButton(
                      //    onPressed: (){
                      //      if(_surveyKey.currentState.validate()){
                      //         _surveyKey.currentState.save();
                      //         }
                      //         },
                      //         child: Text('Submit'),
                      //         color: Colors.green,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: TextField(
                decoration: InputDecoration(hintText: 'Branch Name'),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            Container(
              child: TextField(
                decoration: InputDecoration(hintText: 'Reception No'),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        _showChoiceDialog(context);
                      },
                      child: Text("Select Image"),
                    ),
                    _decideImageView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getFriends() {
    List<Widget> friendsTextFieldsList = [];
    for (int i = 0; i < friendsList.length; i++) {
      friendsTextFieldsList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: FriendTextFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row only
            _addRemoveButton(i == friendsList.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFieldsList;
  }

  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          friendsList.insert(0, null);
        } else
          friendsList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  //surgery
  List<Widget> _getSurgeries() {
    List<Widget> surgeryTextFieldsList = [];
    for (int i = 0; i < surgeryList.length; i++) {
      surgeryTextFieldsList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: SurgeriTextField(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row only
            _surgeryAddRemoveButton(i == surgeryList.length - 1, i),
          ],
        ),
      ));
    }
    return surgeryTextFieldsList;
  }

  Widget _surgeryAddRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          surgeryList.insert(0, null);
        } else
          surgeryList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  //Test Facility
  List<Widget> _getTestFacilities() {
    List<Widget> testFacilityTextFieldsList = [];
    for (int i = 0; i < testFacilityList.length; i++) {
      testFacilityTextFieldsList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: TestFacilityTextField(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row only
            _testFacilityAddRemoveButton(i == testFacilityList.length - 1, i),
          ],
        ),
      ));
    }
    return testFacilityTextFieldsList;
  }

  Widget _testFacilityAddRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          testFacilityList.insert(0, null);
        } else
          testFacilityList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }
}

// child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children:<Widget>[
//             FlatButton(
//               onPressed: () {
//                 getCurrentLocation();
//               },
//               color: Colors.blue[800],
//               child: Icon(
//                 Icons.location_on,
//                 size: 20.0,
//                 color: Colors.blue,
//               ),
//             ),
//             SizedBox(
//               height: 10.0,
//             ),
//             Text(locationmsg
//             ),
//           ],
//         ),

//  new ListView.builder(
//                 itemCount: 1,
//                 itemBuilder: (BuildContext context, int index) {
//                   return new Container(
//                     child: new Center(
//                       child: new Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: <Widget>[
//                           new Card(
//                             child: new Container(
//                               child: new Text("Hello"),
//                               padding: const EdgeInsets.all(20.0),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 })

// color: Colors.white,
//       child: ListView.builder(
//           itemCount: null == _divitions ? 0 : _divitions.length,
//           itemBuilder: (BuildContext context, int index) {
//             Division division = _divitions[index];
//              return ListTile(
//               title: Text(division.name),
//             );
//           }),

// new ListView.builder(
//       itemCount: null == _divitions ? 0 : _divitions.length,
//       itemBuilder: (BuildContext context, int index) {
//         Division division = _divitions[index];
//         return new Container(
//           child: new Center(
//             child: new Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 new Card(
//                   child: new Container(
//                     child: new Text(division.name),
//                     padding: const EdgeInsets.all(20.0),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       })
