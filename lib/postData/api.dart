import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class NetWork {
  
  Map<String, String> headers = {
    "Content-type": "application/json",
    'Charset': 'utf-8'
  };
  sendHospitalStore({
    @required context,
    @required String name,
    @required String nameBangla,
    @required String cityId,
    @required String divisionId,
    @required String addressLine1,
    String addressLine2,
     services,
     surgeries,
     testFacilities,
    @required image,
    @required String locationLat,
    @required String locationLng,
    @required String branchName,
    @required String receptionPhone,
   String notes,
  }) async {
    //   var fullUrl = baseUrl + "/registration/hospital/store";

    var fullUrl = Uri(
        scheme: "http",
        host: "139.59.112.145",
        path: "/api/registration/hospital/store");

    var data = {
      'name': name,
      'name_bn': nameBangla,
      'city_id': cityId,
      'division_id': divisionId,
      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'services': services,
      'surgeries': surgeries,
      'test_facilities': testFacilities,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'branch_name': branchName,
      'reception_phone': receptionPhone,
      'image': image,
      'note': notes
      
    };

    // FormData formData = new FormData.fromMap(data);

    final response =
        await http.post(fullUrl, body: json.encode(data), headers: headers);

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
      print(body);
      print(data);
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





sendDoctorStore({
    @required context,
    @required String name,
    @required String nameBangla,
    @required String cityId,
    @required String divisionId,
    @required String addressLine1,
    String addressLine2,
     departmentId,
     designationId,
     expertiseId,
     notes,
    @required image,
    @required String locationLat,
    @required String locationLng,
    @required String branchName,
    @required String receptionPhone,
  }) async {
   
    var fullUrl = Uri(
        scheme: "http",
        host: "139.59.112.145",
        path: "/api/registration/doctor/store");

    var data = {
      'name': name,
      'name_bn': nameBangla,
      'city_id': cityId,
      'division_id': divisionId,
      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'department_id': departmentId,
      'designation_id': designationId,
      'expertise_id': expertiseId,
      'note':notes,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'branch_name': branchName,
      'reception_phone': receptionPhone,
      'image': image,
    };

    

    final response =
        await http.post(fullUrl, body: json.encode(data), headers: headers);

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
      print(body);
      print(data);
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


sendClinicStore({
    @required context,
    @required String name,
    @required String nameBangla,
    @required String cityId,
    @required String divisionId,
    @required String addressLine1,
    String addressLine2,
     services,
     surgeries,
     testFacilities,
    @required image,
    @required String locationLat,
    @required String locationLng,
    @required String branchName,
    @required String receptionPhone,
    String notes
  }) async {
    

    var fullUrl = Uri(
        scheme: "http",
        host: "139.59.112.145",
        path: "/api/registration/clinic/store");

    var data = {
      'name': name,
      'name_bn': nameBangla,
      'city_id': cityId,
      'division_id': divisionId,
      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'services': services,
      'surgeries': surgeries,
      'test_facilities': testFacilities,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'branch_name': branchName,
      'reception_phone': receptionPhone,
      'image': image,
      'note': notes,
    };

    // FormData formData = new FormData.fromMap(data);

    final response =
        await http.post(fullUrl, body: json.encode(data), headers: headers);

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
      print(body);
      print(data);
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








}
