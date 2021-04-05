import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:data_collection/helperClass/testFacilityField.dart';
import 'package:data_collection/model/Hospitalmodel.dart';
import 'package:data_collection/model/city.dart';
import 'package:data_collection/postData/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../constant.dart';

class Clinic extends StatefulWidget {
  @override
  _ClinicState createState() => _ClinicState();
}

class _ClinicState extends State<Clinic> {
  List<String> servicesItems = [];
  List<String> surguriesItems = [];
  List<String> testFacilitiesItems = [];

  final _notesController = TextEditingController();
  //dropdown
  List surguriesList = [];
  List testFacilitiesList = [];

  var locationmsg = " ";
  var latmsg = '';
  var longmsg = '';
  double currentlat;
  double currentlong;
  File imageFile;

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

  var selectedCityID; //city
  var selectedDivisionID; //city
  var cities;

  // var locationLatitude;
  //var locationLongitude;

  ///

  var errorMessageHospitalEnglish;
  var errorMessageHospitalBangla;
  var errorMessageAddressEnglish;
  var errorMessageAddressBangla;
  var errorMessageBranchName;
  var errorMessagePhone;

  ///

  final _formKeytest = GlobalKey<FormState>();
  final _formKeyservices = GlobalKey<FormState>();

  final _formKeySurgeries = GlobalKey<FormState>();

  String servicejson;
  String surgeryjson;
  String testfacilityjson;
  int cityId;
  int divId;
  int latitudemessage;
  int longitudemessage;
  var baseimage;
  int surveyquestionnum = 1;
  int surveyquestiontotal = 1;

  int linktestdevices = 1;
  String dropdownvalue = "SELECT FROM DROPDOWN";
  String divisiondropdown = "Select Division";
  String citydropdown = "Select Area";
  String testgorir = "Select testgorir";
  List serviceList = [];

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

  DropdownMenuItem<Datum> buildDropdownMenuItem(Datum item) {
    return DropdownMenuItem(
      value: item, // you must provide a value
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(item.name),
      ),
    );
  }

  getCities() {
    NetWork().getCity(selectedDivisionID).then((response) {
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        setState(() {
          cities = CityData.fromJson(body);
          print(cities);
        });
      }
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

//  final String url = "http://139.59.112.145/api/registration/helper/hospital";

  List data = []; //edited line
  List cityData = [];
  var city;
  var resBody;

  var url = Uri(
      scheme: "http",
      host: "139.59.112.145",
      path: "/api/registration/helper/clinic/");

  Future<String> getSWData() async {
    var res = await http.get(url, headers: {"Accept": "application/json"});
    resBody = json.decode(res.body);

    var user = resBody['data']['divisions'];
    //  setState(() {
    data = user;
    // });
    return "Sucess";
  }

  Future<String> getCity() async {
    var res = await http.get(url, headers: {"Accept": "application/json"});
    var rresBody = json.decode(res.body);

    var city = rresBody['data']['divisions'];

    // for (int k = 0; k < div.toString().length; k++) {
    //   city = div['cities'][k];
    // }

    //city = diva['cities'];
    print('city: $city.');
    setState(() {
      cityData = city;
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
  // var _divisionController = new TextEditingController();
  // var _cityController = new TextEditingController();
  var uses;
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

  // List<String> data = [];
  var user, user2, user1;

  fetchDivisons() async {
    final response = await http.get(
      Uri(
          scheme: "http",
          host: "139.59.112.145",
          path: "/api/registration/helper/clinic/"),
    );
    final jsonResponse = json.decode(response.body);
    Helper helper = new Helper.fromJson(jsonResponse);
    for (var i = 0; i < helper.data.surguries.length; i++) {
      //  data.add(helper.data.surguries[i].name);
    }
    // print(data);
    return helper;
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
                decoration: InputDecoration(
                    hintText: 'Name In English',
                    errorText: errorMessageHospitalEnglish),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            //Name bn
            Container(
              child: TextField(
                controller: hospitalNameBang,
                decoration: InputDecoration(
                    hintText: 'Name In Bangla',
                    errorText: errorMessageHospitalBangla),
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
                      hint: Text(divisiondropdown),
                      items: data.asMap().entries.map((item) {
                        // print(item);
                        return new DropdownMenuItem(
                          child: new Text(item.value['name']),
                          value: [item.value['id'], item.value['name']],
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          divisiondropdown = newVal[1].toString();
                          selectedDivisionID = newVal[0].toString();
                          citydropdown = "Select Area";
                          selectedCityID = null;
                          cities = null;
                          getCities();
                        });
                      },
                    ),
                  ],
                )),
            //city
            Container(
                width: 300.0,
                margin: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    if (cities != null)
                      new DropdownButton(
                        underline: SizedBox(),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        hint: Text(citydropdown),
                        items: cities.data
                            .map<DropdownMenuItem<dynamic>>(
                                (item) => buildDropdownMenuItem(item))
                            .toList(),
                        onChanged: (cityVal) {
                          // print(cityVal.name);
                          setState(() {
                            citydropdown = cityVal.name.toString();
                            selectedCityID = cityVal.id.toString();
                          });
                          // print(_citySelection);
                        },
                        // value: selectedCityID,
                      ),
                  ],
                )),
            //address
            Container(
              child: TextField(
                controller: addressInEng,
                decoration: InputDecoration(
                    hintText: 'Address In English',
                    errorText: errorMessageAddressEnglish),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            //address
            Container(
              child: TextField(
                controller: addressInBng,
                decoration: InputDecoration(
                    hintText: 'Address In Bangla',
                    errorText: errorMessageAddressBangla),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            //Location
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      getCurrentLocation();
                    },
                    // color: Colors.blue[800],
                    child: Icon(
                      Icons.location_on,
                      size: 20.0,
                      color: Colors.blue,
                    ),
                  ),
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
                decoration: InputDecoration(
                    hintText: 'Branch Name', errorText: errorMessageBranchName),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            //reciption no
            Container(
              child: TextField(
                controller: mobileNo,
                decoration: InputDecoration(
                    hintText: 'Reception No', errorText: errorMessagePhone),
              ),
              padding: EdgeInsets.all(10.0),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FutureBuilder(
                    future: fetchDivisons(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return CupertinoActivityIndicator();
                      } else {
                        for (var i = 0;
                            i < snapshot.data.data.services.length;
                            i++) {
                          // user = snapshot.data.data.services[i];
                          serviceList.add(snapshot.data.data.services[i]);
                        }
                        for (var i = 0;
                            i < snapshot.data.data.surguries.length;
                            i++) {
                          surguriesList.add(snapshot.data.data.surguries[i]);
                        }
                        for (var i = 0;
                            i < snapshot.data.data.testFacilities.length;
                            i++) {
                          testFacilitiesList
                              .add(snapshot.data.data.testFacilities[i]);
                        }

                        return Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Services", style: textStyle),
                                  Container(
                                    child: Form(
                                      key: _formKeyservices,
                                      child: MultiSelectFormFieldForServies(
                                        context: context,
                                        buttonText: 'Services',
                                        itemList: [
                                          for (var i in serviceList)
                                            i.id.toString() +
                                                ") " +
                                                i.name.toString()
                                        ],
                                        questionText: 'Select Your services',
                                        validator: (flavours1) => flavours1
                                                    .length ==
                                                0
                                            ? 'Please select at least one services!'
                                            : null,
                                        onSaved: (flavours1) {
                                          print(flavours1);
                                          //var items = flavours1.map((e) => e.replaceAll(')', ' '));
                                          servicesItems = flavours1
                                              .map((e) => e.split(")")[0])
                                              .toList();

                                          print(servicesItems);

                                          // Logic to save selected flavours in the database
                                        },
                                      ),
                                      onChanged: () {
                                        if (_formKeyservices.currentState
                                            .validate()) {
                                          // Invokes the OnSaved Method
                                          // servicesItems.cast();

                                          _formKeyservices.currentState.save();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Surguries", style: textStyle),
                                  Container(
                                    child: Form(
                                      key: _formKeySurgeries,
                                      child: MultiSelectFormFieldForSurgeries(
                                        context: context,
                                        buttonText: 'Surguries',
                                        itemList: [
                                          for (var i in surguriesList)
                                            i.id.toString() +
                                                ") " +
                                                i.name.toString()
                                        ],
                                        questionText: 'Select Your surguries',
                                        validator: (flavours2) => flavours2
                                                    .length ==
                                                0
                                            ? 'Please select at least one flavor!'
                                            : null,
                                        onSaved: (flavours2) {
                                          surguriesItems = flavours2
                                              .map((e) => e.split(")")[0])
                                              .toList();

                                          print(surguriesItems);
                                          // Logic to save selected flavours in the database
                                        },
                                      ),
                                      onChanged: () {
                                        if (_formKeySurgeries.currentState
                                            .validate()) {
                                          // Invokes the OnSaved Method
                                          _formKeySurgeries.currentState.save();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Test Facilities", style: textStyle),
                                  Container(
                                    child: Form(
                                      key: _formKeytest,
                                      child:
                                          MultiSelectFormFieldForTestFacilities(
                                        context: context,
                                        buttonText: 'Test Facilities',
                                        itemList: [
                                          for (var i in testFacilitiesList)
                                            i.id.toString() +
                                                ") " +
                                                i.name.toString()
                                        ],
                                        questionText:
                                            'Select Your testFacilities',
                                        validator: (flavours3) => flavours3
                                                    .length ==
                                                0
                                            ? 'Please select at least one testFacilities!'
                                            : null,
                                        onSaved: (flavours3) {
                                          testFacilitiesItems = flavours3
                                              .map((e) => e.split(")")[0])
                                              .toList();

                                          print(testFacilitiesItems);

                                          // Logic to save selected flavours in the database
                                        },
                                      ),
                                      onChanged: () {
                                        if (_formKeytest.currentState
                                            .validate()) {
                                          // Invokes the OnSaved Method
                                          _formKeytest.currentState.save();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    }),
              ],
            ),

            // //image
            Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
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

            SizedBox(
              height: 10,
            ),
//notes
            Container(
              height: 100,
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                    labelText: "Notes",
                    hintText: 'Give us your feeling of thought',
                    border: OutlineInputBorder()),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),

            //send to server
            Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.green)),
                      onPressed: () {
                        //String imageFileName = imageFile.path.split('/').last;

                        print("/////////////");
                        print(testFacilitiesItems);
                        print(surguriesItems);
                        print(servicesItems);

                        List<int> imageBytes = imageFile.readAsBytesSync();
                        baseimage = base64Encode(imageBytes);

                        _sendClinic();
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

  _sendClinic() async {
    var data = {
      'name': hospitalNameEng.text,
      'name_bn': hospitalNameBang.text,
      'city_id': _citySelection.toString(),
      'division_id': _mySelection.toString(),
      'address_line_1': addressInEng.text,
      'address_line_2': addressInBng.text,
      'services': servicesItems,
      'surgeries': surguriesItems,
      'test_facilities': testFacilitiesItems,
      'note': _notesController.text,
      'location_lat': latmsg,
      'location_lng': longmsg,
      'branch_name': branchName.text,
      'reception_phone': mobileNo.text,
      'image': baseimage,
    };

    var response = await NetWork().sendClinicStore(data: data);

    String showMessage;

    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      showMessage = body['msg'];
      print(data);
      print(body);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Dialog Title',
        desc: showMessage.toString(),
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      )..show();
    } else {
      errorMessageHospitalEnglish = body['data']['name'].toString();
      errorMessageHospitalBangla = body['data']['name_bn'].toString();
      // print(errorMessageHospitalEnglish);

      errorMessageAddressEnglish = body['data']['address_line_1'].toString();
      errorMessageAddressBangla = body['data']['address_line_2'].toString();
      errorMessageBranchName = body['data']['branch_name'].toString();
      errorMessagePhone = body['data']['reception_phone'].toString();
      showMessage = body['msg'];
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Dialog Title',
        desc: showMessage.toString(),
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      )..show();
    }
  }

  //gallery
  _openGallery(BuildContext context) async {
    final _picker = ImagePicker();
    final pickedFile =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    final File file = File(pickedFile.path);
    // var picture = await ImagePicker.getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      imageFile = file;
    });
    Navigator.of(context).pop();
  }

  //Camera
  _openCamera(BuildContext context) async {
    final _picker = ImagePicker();
    final pickedFile =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);
    final File file = File(pickedFile.path);

    setState(() {
      imageFile = file;
    });
    Navigator.of(context).pop();
  }
}
