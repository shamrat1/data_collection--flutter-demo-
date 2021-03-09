import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
//import 'package:data_collection/helperClass/testFacilityField.dart';
import 'package:data_collection/model/HospitalDataModelForSend.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
////import 'package:data_collection/helperClass/testForAddButton.dart';
//import 'package:data_collection/helperClass/surgeriesField.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:data_collection/players.dart';
import 'package:http_parser/http_parser.dart';

class Hospital extends StatefulWidget {
  @override
  _HospitalState createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  var locationmsg = " ";
  var latmsg = '';
  var longmsg = '';
  double currentlat;
  double currentlong;
  File imageFile;
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Division>> key = new GlobalKey();
  static List<Division> divisions = new List<Division>();
  bool loading = true;

  final hospitalNameEng = TextEditingController();
  final hospitalNameBang = TextEditingController();
  //dropdown
  var _mySelection; //division
  var _citySelection; //city
  final addressInEng = TextEditingController();
  final addressInBng = TextEditingController();
  final branchName = TextEditingController();
  final mobileNo = TextEditingController();

  // var locationLatitude;
  //var locationLongitude;

  //service, test_facility, surgery
  final _serviceKey = GlobalKey<FormState>();
  final _surgeryKey = GlobalKey<FormState>();
  final _testFacilityKey = GlobalKey<FormState>();
  // TextEditingController _nameController;
  static List<String> friendsList = [null];
  static List<String> serviceTextList = [null];
  static List<String> surgeryList = [null];
  static List<String> testFacilityList = [null];
  String servicejson;
  String surgeryjson;
  String testfacilityjson;
  int cityId;
  int divId;
  int latitudemessage;
  int longitudemessage;

  ////////////////////////
  ///TEST Dropdown/////////////
  /////////////////////
  int surveyquestionnum = 1;
  int surveyquestiontotal = 1;

  int linktestdevices = 1;
  String dropdownvalue = "SELECT FROM DROPDOWN";
  String divisiondropdown = "Select Division";
  String citydropdown = "Select Area";
  String testgorir = "Select testgorir";
  List serviceList = List();

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
    //currentlat = lastPosition.latitude;
    //currentlong = lastPosition.longitude;
    print(lastPosition);

    setState(() {
      // locationmsg = "$position.latitude";
      latmsg = lastPosition.latitude.toString();
      longmsg = lastPosition.longitude.toString();
      //locationmsg = lastPosition as String;
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

  final String url = "http://139.59.112.145/api/registration/helper/hospital";

  List data = List(); //edited line
  List city_data = List();
  var city;
  var resBody;

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    resBody = json.decode(res.body);

    var user = resBody['data']['divisions'];
    setState(() {
      data = user;
    });
    return "Sucess";
  }

  Future<String> getCity() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var rresBody = json.decode(res.body);

    var city = rresBody['data']['divisions'];

    // for (int k = 0; k < div.toString().length; k++) {
    //   city = div['cities'][k];
    // }

    //city = diva['cities'];
    print('city: $city.');
    setState(() {
      city_data = city;
    });

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
    this.getCity();
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
        width: 200,
        height: 200,
      );
    }
    return Image.file(
      imageFile,
      width: 200,
      height: 200,
    );
  }

  //Dio part
  Dio dio = new Dio();
  Future postData() async {
    final String apiUrl =
        "http://139.59.112.145/api/registration/hospital/store";
    setState(() {
      servicejson = jsonEncode(serviceTextList);
      surgeryjson = jsonEncode(surgeryList);
      testfacilityjson = jsonEncode(testFacilityList);

      //cityId = _citySelection;
      //divId = _mySelection;

      //latitudemessage = latmsg as int;
      //longitudemessage = longmsg as int;
    });
    String imageFileName = imageFile.path.split('/').last;

    FormData formData = new FormData.fromMap({
      "name": hospitalNameEng.text,
      "name_bn": hospitalNameBang.text,
      "city_id": _citySelection,
      "division_id": _mySelection,
      "address_line_1": addressInEng.text,
      "address_line_2": addressInBng.text,
      "Services": servicejson,
      "Surgeries": surgeryjson,
      "test_facilities": testfacilityjson,
      "Image": {
        "image": await MultipartFile.fromFile(imageFile.path,
            filename: imageFileName,
            contentType: new MediaType('image', 'png')),
        "type": "image/png"
      },
      "location_lat": double.parse(latmsg),
      "location_lng": double.parse(longmsg),
      "branch_name": branchName.text,
      "reception_phone": int.parse(mobileNo.text),
    });

    try {
      var response = await dio.post(apiUrl,
          data: formData,
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer accresstoken",
            "Content-type": "multipart/form-data",
            // "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
          }));

      return response.data;
    } on DioError catch (error) {
      print('error: $error');
      print(error.response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Name
            Container(
              //margin: const EdgeInsets.only(bottom:5.0),
              child: TextField(
                controller: hospitalNameEng,
                decoration:
                    InputDecoration(hintText: 'Hospital Name In English'),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            //Name bn
            Container(
              child: TextField(
                controller: hospitalNameBang,
                decoration:
                    InputDecoration(hintText: 'Hospital Name In Bangla'),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            //division
            Container(
                width: 300.0,
                margin: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    new DropdownButton(
                      underline: SizedBox(),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      hint: Text("  $divisiondropdown"),
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
            //city
            Container(
                width: 300.0,
                margin: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    new DropdownButton(
                      underline: SizedBox(),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      hint: Text("  $citydropdown"),
                      items: data.map((item) {
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
            //address
            Container(
              child: TextField(
                controller: addressInEng,
                decoration: InputDecoration(hintText: 'Address In English'),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            //address
            Container(
              child: TextField(
                controller: addressInBng,
                decoration: InputDecoration(hintText: 'Address In Bangla'),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            //Location
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  // SizedBox(
                  //   height: 10.0,
                  // ),
                  // Text(latmsg),
                  // Text(longmsg),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 8.0,
                  ),
                  Text("Latitude:" + latmsg),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 8.0,
                  ),
                  Text("Longitude:" + longmsg),
                ],
              ),
            ),
            //branch name
            Container(
              child: TextField(
                controller: branchName,
                decoration: InputDecoration(hintText: 'Branch Name'),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            //reciption no
            Container(
              child: TextField(
                controller: mobileNo,
                decoration: InputDecoration(hintText: 'Reception No'),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            //service
            Container(
              child: Form(
                key: _serviceKey,
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
                      ..._getServices(),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //test_facility
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
                    ],
                  ),
                ),
              ),
            ),
            //surgeries
            Container(
              child: Form(
                key: _surgeryKey,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Surgery',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      ..._getSurgery(),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // //image
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
            //send to server
            Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.green)),
                      onPressed: () async {
                        try {
                          await postData().then((value) {
                            print(value);
                          });
                        } catch (e) {
                          print("--" * 20);
                          print('Exception while uploading data: $e');
                        }
                      },
                      child: Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

  //services
  List<Widget> _getServices() {
    List<Widget> serviceTextFieldsList = [];
    for (int i = 0; i < serviceTextList.length; i++) {
      serviceTextFieldsList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: FriendTextFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row only
            _addRemoveServiceButton(i == serviceTextList.length - 1, i),
          ],
        ),
      ));
    }
    return serviceTextFieldsList;
  }

  Widget _addRemoveServiceButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          serviceTextList.insert(0, null);
        } else
          serviceTextList.removeAt(index);
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

  //test facility

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
            _addRemoveTestButton(i == testFacilityList.length - 1, i),
          ],
        ),
      ));
    }
    return testFacilityTextFieldsList;
  }

  Widget _addRemoveTestButton(bool add, int index) {
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

  //Surgery

  List<Widget> _getSurgery() {
    List<Widget> surgeryTextFieldsList = [];
    for (int i = 0; i < surgeryList.length; i++) {
      surgeryTextFieldsList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: SurgeryTextField(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row only
            _addRemoveSurgeryButton(i == surgeryList.length - 1, i),
          ],
        ),
      ));
    }
    return surgeryTextFieldsList;
  }

  Widget _addRemoveSurgeryButton(bool add, int index) {
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
}

////////////////
///Service/////
//////////////

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
      //var _HospitalState;
      _serviceController.text =
          _HospitalState.serviceTextList[widget.index] ?? '';
    });

    //var _HospitalState;
    return TextFormField(
      controller:
          _serviceController, // save text field data in friends list at index
      // whenever text field value changes

      onChanged: (v) => _HospitalState.serviceTextList[widget.index] = v,
      decoration:
          InputDecoration(hintText: 'Add a unique code: Service Name\''),
      validator: (v) {
        if (v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}

////////////////////
///Surgery/////////
///////////////////

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
      // var _HospitalState;
      _surgeryNameController.text =
          _HospitalState.surgeryList[widget.index] ?? '';
    });
    //var _HospitalState;
    return TextFormField(
      controller:
          _surgeryNameController, // save text field data in friends list at index
      // whenever text field value changes
      onChanged: (v) => _HospitalState.surgeryList[widget.index] = v,
      decoration:
          InputDecoration(hintText: 'Add a unique code: Surgery Details\''),
      validator: (v) {
        if (v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}

////////////////////
///Test facility////
///////////////////
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
      //  var _HospitalState;
      _testFacilityNameController.text =
          _HospitalState.testFacilityList[widget.index] ?? '';
    });
    // var _HospitalState;
    return TextFormField(
      controller:
          _testFacilityNameController, // save text field data in friends list at index
      // whenever text field value changes
      onChanged: (v) => _HospitalState.testFacilityList[widget.index] = v,
      decoration: InputDecoration(
          hintText: 'Add a unique code: Test Facility Details\''),
      validator: (v) {
        if (v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
