import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:data_collection/helperClass/surgeriesField.dart';
import 'package:data_collection/helperClass/testFacilityField.dart';
import 'package:data_collection/helperClass/testForAddButton.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:data_collection/model/Hospitalmodel.dart';
import 'package:data_collection/pages/doctor.dart';
import 'package:data_collection/getdata/HospitalService.dart' as Hservice;
import 'package:image_picker/image_picker.dart';

class Hospital extends StatefulWidget {
  @override
  _HospitalState createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  var locationmsg = " ";
  File imageFile;
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Division>> key = new GlobalKey();
  static List<Division> divisions = new List<Division>();
  bool loading = true;

  static get extractedData => null;

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

  //for camera dialogBox
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

  //service, test_facility, surgery
  final _formKey = GlobalKey<FormState>();
  final _surveyKey = GlobalKey<FormState>();
  final _testFacilityKey = GlobalKey<FormState>();
  // TextEditingController _nameController;
  static List<String> friendsList = [null];
  static List<String> surgeryList = [null];
  static List<String> testFacilityList = [null];

  //dropdown
  String _mySelection;
  String _citySelection;

  final String url = "http://139.59.112.145/api/registration/helper/hospital";

  List data = List(); //edited line
  List city_data = List();
  var city;

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    var user = resBody['data']['divisions'];
    setState(() {
      data = user;
    });
    return "Sucess";
  }

  Future<String> getCity() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    //var user = resBody['data']['divisions'];
    // setState(() {
    //   data = user;
    // });
    // for (int i = 0; i < resBody.toString().length; i++) {
    city = resBody['data']['divisions']['cities'];
    print('city: $city.');
    setState(() {
      city_data = city;
    });

    return "Sucess";
  }

      ////////////////////////
      ///TEST Dropdown/////////////
      /////////////////////
      int surveyquestionnum = 1;
  int surveyquestiontotal = 1;
  ///service
  List<Item> selectedService = [null];
  List<Item> survices;
  int linkservicedevices = 1;
  ///surgery
  List<Item> selectedSurgery = [null];
  List<Item> surgeries;
  int linksurgerydevices = 1;
  ////test facility
  List<Item> selectedtest = [null];
  List<Item> tests;
  int linktestdevices = 1;
  String dropdownvalue = "SELECT FROM DROPDOWN";
 
  @override
  Widget _servicedropdownbutton(List<Item> servicelist, int index) {
    return Container(
      padding: EdgeInsets.all(1),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(15.0) //
            ),
      ),
      child: DropdownButton<Item>(
        underline: SizedBox(),
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down),
        hint: Text("  $dropdownvalue"),
        value: selectedService[index],
        onChanged: (Item Value) {
          print(Value.toString());
          print(index);
          setState(() {
            selectedService[index] = Value;
          });
        },
        items: servicelist.map((Item service) {
          return DropdownMenuItem<Item>(
            value: service,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Text(
                  service.name,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

   @override
  Widget _surgerydropdownbutton(List<Item> surgerylist, int index) {
    return Container(
      padding: EdgeInsets.all(1),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(15.0) //
            ),
      ),
      child: DropdownButton<Item>(
        underline: SizedBox(),
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down),
        hint: Text("  $dropdownvalue"),
        value: selectedSurgery[index],
        onChanged: (Item Value) {
          print(Value.toString());
          print(index);
          setState(() {
            selectedSurgery[index] = Value;
          });
        },
        items: surgerylist.map((Item surgery) {
          return DropdownMenuItem<Item>(
            value: surgery,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Text(
                  surgery.name,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

   @override
  Widget _testdropdownbutton(List<Item> testlist, int index) {
    return Container(
      padding: EdgeInsets.all(1),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(15.0) //
            ),
      ),
      child: DropdownButton<Item>(
        underline: SizedBox(),
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down),
        hint: Text("  $dropdownvalue"),
        value: selectedtest[index],
        onChanged: (Item Value) {
          print(Value.toString());
          print(index);
          setState(() {
            selectedtest[index] = Value;
          });
        },
        items: testlist.map((Item test) {
          return DropdownMenuItem<Item>(
            value: test,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Text(
                  test.name,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _text(texthere, bold, size, color) {
    return Text(texthere,
        style: TextStyle(fontWeight: bold, fontSize: size, color: color),
        overflow: TextOverflow.ellipsis,
        maxLines: 1);
  }


  @override
  void initState() {
    super.initState();
    this.getSWData();
    this.getCity();
    survices = <Item>[
      Item('Sample device 1'),
      Item('Sample device 2'),
      Item('Sample device 3'),
      Item('Sample device 4'),
    ];
     surgeries = <Item>[
      Item('surgeries device 1'),
      Item('surgeries device 2'),
      Item('surgeries device 3'),
      Item('surgeries device 4'),
    ];
    tests = <Item>[
      Item('tests device 1'),
      Item('tests device 2'),
      Item('tests device 3'),
      Item('tests device 4'),
    ];
  }

  //autoCompleteTextView test
  var _divisionController = new TextEditingController();
  // var _cityController = new TextEditingController();

  // for image
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
    return Image.file(
      imageFile,
      width: 400,
      height: 400,
    );
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
                width: 300.0,
                margin: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    new DropdownButton(
                      items: data.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item['name']),
                          value: item['id'].toString(),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _mySelection = newVal;
                        });
                      },
                      value: _mySelection,
                    ),
                  ],
                )),
            Container(
                width: 300.0,
                margin: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    new DropdownButton(
                      items: city_data.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item['name']),
                          value: item['id'].toString(),
                        );
                      }).toList(),
                      onChanged: (cityVal) {
                        setState(() {
                          _citySelection = cityVal;
                        });
                      },
                      value: _citySelection,
                    ),
                  ],
                )),
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
              child: Column(
                children: <Widget>[
                  _text("Services", FontWeight.bold, 20.0, Colors.blue),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: linkservicedevices,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _servicedropdownbutton(survices, index),
                      );
                    },
                    separatorBuilder: (context, index) => Container(height: 10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        child: Text("ADD DEVICE"),
                        onTap: () {
                          selectedService.add(null);
                          linkservicedevices++;
                          setState(() {});
                        },
                      ),
                      // InkWell(
                      //   child: Text("CLEAR ALL DEVICE"),
                      //   onTap: () {},
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  _text("Surgery", FontWeight.bold, 20.0, Colors.blue),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: linksurgerydevices,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _surgerydropdownbutton(surgeries, index),
                      );
                    },
                    separatorBuilder: (context, index) => Container(height: 10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        child: Text("ADD DEVICE"),
                        onTap: () {
                          selectedSurgery.add(null);
                          linksurgerydevices++;
                          setState(() {});
                        },
                      ),
                      // InkWell(
                      //   child: Text("CLEAR ALL DEVICE"),
                      //   onTap: () {},
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  _text("Test Facility", FontWeight.bold, 20.0, Colors.blue),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: linktestdevices,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _testdropdownbutton(tests, index),
                      );
                    },
                    separatorBuilder: (context, index) => Container(height: 10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        child: Text("ADD DEVICE"),
                        onTap: () {
                          selectedtest.add(null);
                          linktestdevices++;
                          setState(() {});
                        },
                      ),
                      // InkWell(
                      //   child: Text("CLEAR ALL DEVICE"),
                      //   onTap: () {},
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            // Container(
            //   child: Form(
            //     key: _formKey,
            //     child: Padding(
            //       padding: const EdgeInsets.all(5.0),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'Services',
            //             style: TextStyle(
            //                 fontWeight: FontWeight.w700, fontSize: 16),
            //           ),
            //           ..._getFriends(),
            //           SizedBox(
            //             height: 20,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // Container(
            //   child: Form(
            //     key: _surveyKey,
            //     child: Padding(
            //       padding: const EdgeInsets.all(5.0),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'Surgey',
            //             style: TextStyle(
            //                 fontWeight: FontWeight.w700, fontSize: 16),
            //           ),
            //           ..._getSurgeries(),
            //           SizedBox(
            //             height: 20,
            //           ),
            //           //  FlatButton(
            //           //    onPressed: (){
            //           //      if(_surveyKey.currentState.validate()){
            //           //         _surveyKey.currentState.save();
            //           //         }
            //           //         },
            //           //         child: Text('Submit'),
            //           //         color: Colors.green,
            //           // ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // Container(
            //   child: Form(
            //     key: _testFacilityKey,
            //     child: Padding(
            //       padding: const EdgeInsets.all(5.0),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'Test Facility',
            //             style: TextStyle(
            //                 fontWeight: FontWeight.w700, fontSize: 16),
            //           ),
            //           ..._getTestFacilities(),
            //           SizedBox(
            //             height: 20,
            //           ),
            //           //  FlatButton(
            //           //    onPressed: (){
            //           //      if(_surveyKey.currentState.validate()){
            //           //         _surveyKey.currentState.save();
            //           //         }
            //           //         },
            //           //         child: Text('Submit'),
            //           //         color: Colors.green,
            //           // ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
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

  //gallery
  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  //Camera
  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }
}
