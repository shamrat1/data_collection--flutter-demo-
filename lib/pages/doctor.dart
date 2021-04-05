import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:data_collection/model/city.dart';
import 'package:data_collection/postData/api.dart';
import 'package:data_collection/model/doctorModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../constant.dart';
import '../helperClass/testFacilityField.dart';
import '../model/doctorModel.dart';

class Doctor extends StatefulWidget {
  @override
  _DoctorState createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {
  List<String> departmentItems = [];
  List<String> visitedHoursItems = [];
  List<String> visitedFeesItems = [];
  var baseimage;
  var locationmsg = " ";
  var latmsg = '';
  var longmsg = '';
  double currentlat;
  double currentlong;
  File imageFile;

  bool loading = true;
  var response;
  final hospitalNameEng = TextEditingController();
  final hospitalNameBang = TextEditingController();
  //dropdown
  var selectedCityID; //city
  final addressInEng = TextEditingController();
  final addressInBng = TextEditingController();
  final bmdcCode = TextEditingController();
  final mobileNo = TextEditingController();

  final _notesController = TextEditingController();
  // var locationLatitude;
  //var locationLongitude;
  ///

  var errorMessageHospitalEnglish;
  var errorMessageHospitalBangla;
  var errorMessageAddressEnglish;
  var errorMessageAddressBangla;
  var errorMessageBmdcCode;
  var errorMessagePhone;

  var cities;
  var selectedDivisionID = "1";

  ///
  // final _formKeytest = GlobalKey<FormState>();
  //final _formKeyservices = GlobalKey<FormState>();

  final _formKeyVisitHours = GlobalKey<FormState>();
  final _formKeyVisitFree = GlobalKey<FormState>();
  String servicejson;
  String surgeryjson;
  String testfacilityjson;
  int cityId;
  int divId;
  int latitudemessage;
  int longitudemessage;

  int surveyquestionnum = 1;
  int surveyquestiontotal = 1;

  int linktestdevices = 1;
  String dropdownvalue = "SELECT FROM DROPDOWN";
  String divisiondropdown = "Dhaka";
  String citydropdown = "Select Area";
  String testgorir = "Select testgorir";
  List serviceList = [];

  var departmantItem;
  var designationItems;
  var expertiseItems;
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
      path: "/api/registration/helper/doctor/");

  Future<String> getSWData() async {
    var res = await http.get(url, headers: {"Accept": "application/json"});
    resBody = json.decode(res.body);
    // print(resBody);
    var user = resBody['data']['divisions'];
    setState(() {
      data = user;
      response = DoctorHelper.fromJson(resBody);
    });
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
    // print('city: $city.');
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
    this.getCities();
  }

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
  //var user, user2, user1;

  List department = [];
  List<VisitHour> visitHour = [];
  List<VisitFee> visitFee = [];
  List expertises = [];
  List desginations = [];

  ///
  String departmentDropDown = "SELECT Department";
  String designationsDropDown = "SELECT Department";
  String expertisesDropDown = "SELECT Department";

  ///

  fetchDivision() async {
    final response = await http.get(
      Uri(
          scheme: "http",
          host: "139.59.112.145",
          path: "/api/registration/helper/doctor/"),
    );
    final jsonResponse = json.decode(response.body);
    // print(jsonResponse);
    //Doctor helper = Doctor.fromJson(jsonResponse);
    DoctorHelper doctor = new DoctorHelper.fromJson(jsonResponse);

    // for (var i = 0; i < helper.data.surguries.length; i++) {
    //   //  data.add(helper.data.surguries[i].name);
    // }
    return doctor;
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
                    hintText: 'Name', errorText: errorMessageHospitalEnglish),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            //Name bn
            Container(
              child: TextField(
                controller: hospitalNameBang,
                decoration: InputDecoration(
                    hintText: 'Name (BN)',
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
                    hintText: 'Address line 1',
                    errorText: errorMessageAddressEnglish),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            //address
            Container(
              child: TextField(
                  controller: addressInBng,
                  decoration: InputDecoration(
                      hintText: 'Address Line 2',
                      errorText: errorMessageAddressBangla)),
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
            //BMDC code
            Container(
              child: TextField(
                controller: bmdcCode,
                decoration: InputDecoration(
                    hintText: 'BMDC Code', errorText: errorMessageBmdcCode),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            //reciption no
            Container(
              child: TextField(
                controller: mobileNo,
                decoration: InputDecoration(
                    hintText: 'Phone Number', errorText: errorMessagePhone),
              ),
              padding: EdgeInsets.all(10.0),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FutureBuilder(
                    future: fetchDivision(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return CupertinoActivityIndicator();
                      } else {
                        expertises = [];
                        department = [];
                        visitHour = [];
                        visitFee = [];
                        desginations = [];
                        for (var i = 0;
                            i < snapshot.data.data.departments.length;
                            i++) {
                          // user = snapshot.data.data.services[i];
                          department.add(snapshot.data.data.departments[i]);
                          // print(department);
                        }
                        for (var i = 0;
                            i < snapshot.data.data.expertises.length;
                            i++) {
                          expertises.add(snapshot.data.data.expertises[i]);
                        }
                        for (var i = 0;
                            i < snapshot.data.data.designations.length;
                            i++) {
                          desginations.add(snapshot.data.data.designations[i]);
                        }
                        // print(expertises);
                        // print("__-------__");
                        // print(department);
                        // print("--_____--");
                        // print(desginations);

                        for (var i = 0;
                            i < snapshot.data.data.visitHours.length;
                            i++) {
                          visitHour.add(snapshot.data.data.visitHours[i]);
                        }
                        for (var i = 0;
                            i < snapshot.data.data.visitFees.length;
                            i++) {
                          visitFee.add(snapshot.data.data.visitFees[i]);
                        }

                        // print(department);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //  crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //department
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      alignment: Alignment.center,
                                      child:
                                          Text("Department", style: textStyle)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.6,
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        children: [
                                          new DropdownButton(
                                            underline: SizedBox(),
                                            isExpanded: true,
                                            icon: Icon(Icons.arrow_drop_down),
                                            hint: Text(
                                              "  $departmentDropDown",
                                              textAlign: TextAlign.center,
                                            ),
                                            // items: department.map((i){
                                            //     return new DropdownMenuItem(
                                            //       child: new Text(i.name.toString()),
                                            //       value: i.id.toString(),
                                            //     );
                                            //   }).toList(),
                                            items: department.map((item) {
                                              return new DropdownMenuItem(
                                                child: new Text(item.name),
                                                value: item.id.toString(),
                                              );
                                            }).toList(),
                                            // for (var i in department)
                                            //   DropdownMenuItem(
                                            //     child:
                                            //         Text(i.name.toString()),
                                            //     value: i.id.toString(),
                                            //   )

                                            // department.map((item) {
                                            //   return new DropdownMenuItem(
                                            //     child: new Text(item['name']),
                                            //     value: item['id'].toString(),
                                            //   );
                                            // }).toList(),
                                            onChanged: (cityVal) {
                                              // setState(() {
                                              departmantItem = cityVal;
                                              //   });
                                              print(departmantItem);
                                            },
                                            value: departmantItem,
                                          ),
                                        ],
                                      )),

                                  //   Container(
                                  //     child: Form(
                                  //       key: _formKeyservices,
                                  //       child: MultiSelectFormFieldForDepartment(
                                  //         context: context,
                                  //         buttonText: 'Department',
                                  //         itemList: [
                                  //           for (var i in department)
                                  //             i.id.toString() +
                                  //                 ") " +
                                  //                 i.name.toString()
                                  //         ],

                                  //         // itemList: department.map((item) {
                                  //         //   item.name;
                                  //         // }).toList(),

                                  //         questionText: 'Select Your Department',
                                  //         validator: (flavours1) => flavours1
                                  //                     .length ==
                                  //                 0
                                  //             ? 'Please select at least one Department!'
                                  //             : null,
                                  //         onSaved: (flavours1) {
                                  //           //print(flavours1);
                                  //           //var items = flavours1.map((e) => e.replaceAll(')', ' '));
                                  //           departmentItems = flavours1
                                  //               .map((e) => e.split(")")[0])
                                  //               .toList();
                                  //           // print(items.toString());
                                  //           //  departmentItems = items.toList();
                                  //           // departmentItems = items.toList();
                                  //           print(departmentItems);

                                  //           // Logic to save selected flavours in the database
                                  //         },
                                  //       ),
                                  //       onChanged: () {
                                  //         if (_formKeyservices.currentState
                                  //             .validate()) {
                                  //           // Invokes the OnSaved Method
                                  //           // departmentItems.cast();

                                  //           _formKeyservices.currentState.save();
                                  //         }
                                  //       },
                                  //     ),
                                  //   ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Designations", style: textStyle),
                                  SizedBox(width: 10),
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.7,
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        children: [
                                          new DropdownButton(
                                            underline: SizedBox(),
                                            isExpanded: true,
                                            icon: Icon(Icons.arrow_drop_down),
                                            hint: Text(
                                              "  Select designations",
                                              textAlign: TextAlign.center,
                                            ),
                                            items: [
                                              for (var i in desginations)
                                                DropdownMenuItem(
                                                  child:
                                                      Text(i.name.toString()),
                                                  value: i.id.toString(),
                                                )
                                            ],
                                            onChanged: (cityVal) {
                                              // setState(() {
                                              designationItems = cityVal;
                                              //   });
                                              // print(departmantItem);
                                            },
                                            value: designationItems,
                                          ),
                                        ],
                                      )),

                                  //   Container(
                                  //     child: Form(
                                  //       key: _formKeyservices,
                                  //       child: MultiSelectFormFieldForDepartment(
                                  //         context: context,
                                  //         buttonText: 'Department',
                                  //         itemList: [
                                  //           for (var i in department)
                                  //             i.id.toString() +
                                  //                 ") " +
                                  //                 i.name.toString()
                                  //         ],
                                  // itemList: department.map((item) {
                                  //   item.name;
                                  // }).toList(),
                                  //         questionText: 'Select Your Department',
                                  //         validator: (flavours1) => flavours1
                                  //                     .length ==
                                  //                 0
                                  //             ? 'Please select at least one Department!'
                                  //             : null,
                                  //         onSaved: (flavours1) {
                                  //print(flavours1);
                                  //var items = flavours1.map((e) => e.replaceAll(')', ' '));
                                  //           departmentItems = flavours1
                                  //               .map((e) => e.split(")")[0])
                                  //               .toList();
                                  // print(items.toString());
                                  //  departmentItems = items.toList();
                                  // departmentItems = items.toList();
                                  //           print(departmentItems);
                                  // Logic to save selected flavours in the database
                                  //         },
                                  //       ),
                                  //       onChanged: () {
                                  //         if (_formKeyservices.currentState
                                  //             .validate()) {
                                  // Invokes the OnSaved Method
                                  // departmentItems.cast();
                                  //           _formKeyservices.currentState.save();
                                  //         }
                                  //       },
                                  //     ),
                                  //   ),
                                ],
                              ),
                            ),
                            //expertises
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Expertises", style: textStyle),
                                  SizedBox(width: 10),
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.6,
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        children: [
                                          new DropdownButton(
                                            underline: SizedBox(),
                                            isExpanded: true,
                                            icon: Icon(Icons.arrow_drop_down),
                                            hint: Text(
                                              "  Select expertises",
                                              textAlign: TextAlign.center,
                                            ),
                                            items: [
                                              for (var i in expertises)
                                                DropdownMenuItem(
                                                  child:
                                                      Text(i.name.toString()),
                                                  value: i.id.toString(),
                                                )
                                            ],
                                            onChanged: (cityVal) {
                                              // setState(() {
                                              expertiseItems = cityVal;
                                              //   });
                                              // print(departmantItem);
                                            },
                                            value: expertiseItems,
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
//visitHours
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Visited Hours", style: textStyle),
                                  Container(
                                    child: Form(
                                      key: _formKeyVisitHours,
                                      child: MultiSelectFormFieldForSurgeries(
                                        context: context,
                                        buttonText: 'visitHours',
                                        itemList: [
                                          for (var i in visitHour)
                                            i.id.toString() +
                                                ") " +
                                                i.days.toString()
                                        ],
                                        questionText: 'Select Your surguries',
                                        validator: (flavours2) => flavours2
                                                    .length ==
                                                0
                                            ? 'Please select at least one flavor!'
                                            : null,
                                        onSaved: (flavours2) {
                                          visitedHoursItems = flavours2
                                              .map((e) => e.split(")")[0])
                                              .toList();
                                          print(visitedHoursItems);
                                          // Logic to save selected flavours in the database
                                        },
                                      ),
                                      onChanged: () {
                                        if (_formKeyVisitHours.currentState
                                            .validate()) {
                                          // Invokes the OnSaved Method
                                          _formKeyVisitHours.currentState
                                              .save();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //visitfree
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Visit Free", style: textStyle),
                                  Container(
                                    child: Form(
                                      key: _formKeyVisitFree,
                                      child:
                                          MultiSelectFormFieldForTestFacilities(
                                        context: context,
                                        buttonText: 'Visits Fee',
                                        itemList: [
                                          for (var i in visitFee)
                                            i.id.toString() +
                                                ") " +
                                                i.type.toString() +
                                                " " +
                                                i.fee.toString()
                                        ],
                                        questionText:
                                            'Select Your testFacilities',
                                        validator: (flavours3) => flavours3
                                                    .length ==
                                                0
                                            ? 'Please select at least one Visit Free!'
                                            : null,
                                        onSaved: (flavours3) {
                                          visitedFeesItems = flavours3
                                              .map((e) => e.split(")")[0])
                                              .toList();

                                          // Logic to save selected flavours in the database
                                        },
                                      ),
                                      onChanged: () {
                                        if (_formKeyVisitFree.currentState
                                            .validate()) {
                                          // Invokes the OnSaved Method
                                          _formKeyVisitFree.currentState.save();
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
                    // hintText: 'Give us your feeling of thought',
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

                        // print(testFacilitiesItems);
                        // print(visitedHoursItems);
                        // print(departmentItems);

                        List<int> imageBytes = imageFile.readAsBytesSync();
                        baseimage = base64Encode(imageBytes);

                        _sendDoctor();
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

  //testFacilities: testFacilitiesItems,

  _sendDoctor() async {
    var data = {
      'name': hospitalNameEng.text,
      'name_bn': hospitalNameBang.text,
      'city_id': selectedCityID,
      'division_id': selectedDivisionID,
      'address_line_1': addressInEng.text,
      'address_line_2': addressInBng.text,
      'department_id': departmentItems,
      'designation_id': designationItems,
      'expertise_id': expertiseItems,
      'note': _notesController.text,
      'location_lat': latmsg,
      'location_lng': longmsg,
      'bmdc_code': bmdcCode.text,
      'reception_phone': mobileNo.text,
      'image': baseimage,
      'visiting_hours': visitedHoursItems,
      'visiting_fees': visitedFeesItems,
    };

    var response = await NetWork().sendDoctorStore(data: data);

    String showMessage;

    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      showMessage = body['msg'];
      // print(data);
      // print(body);
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
      errorMessageBmdcCode = body['data']['bmdc_code'].toString();
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
