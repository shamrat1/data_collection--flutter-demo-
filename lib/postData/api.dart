import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class NetWork {
  var baseUrl = "http://139.59.112.145/api";
  Map<String, String> headers = {
   "Content-type": "application/json",
    'Charset': 'utf-8'
  };
  sendHospitalStore({
    @required context,
    @required String name,
    @required String name_bn,
    @required String city_id,
    @required String division_id,
    @required String address_line_1,
    String address_line_2,
    List services,
    List surgeries,
    List test_facilities,
    @required image,
    @required String location_lat,
    @required String location_lng,
    @required String branch_name,
    @required String reception_phone,
  }) async {
    var fullUrl = baseUrl + "/registration/hospital/store";

    var data = {
      'name': name,
      'name_bn': name_bn,
      'city_id': city_id,
      'division_id': division_id,
      'address_line_1': address_line_1,
      'address_line_2': address_line_2,
     
      'location_lat': location_lat,
      'location_lng': location_lng,
      'branch_name': branch_name,
      'reception_phone': reception_phone,
       'image': image,
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
