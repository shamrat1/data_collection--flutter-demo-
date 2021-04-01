import 'dart:convert';

import 'package:http/http.dart' as http;

class NetWork {
  Map<String, String> headers = {
    "Content-type": "application/json",
    'Charset': 'utf-8',
    'accept': 'application/json'
  };

  sendHospitalStore({data}) async {
    //   var fullUrl = baseUrl + "/registration/hospital/store";

    var fullUrl = Uri(
        scheme: "http",
        host: "139.59.112.145",
        path: "/api/registration/hospital/store");

    // var data = {
    //   'name': name,
    //   'name_bn': nameBangla,
    //   'city_id': cityId,
    //   'division_id': divisionId,
    //   'address_line_1': addressLine1,
    //   'address_line_2': addressLine2,
    //   'services': services,
    //   'surgeries': surgeries,
    //   'test_facilities': testFacilities,
    //   'location_lat': locationLat,
    //   'location_lng': locationLng,
    //   'branch_name': branchName,
    //   'reception_phone': receptionPhone,
    //   'image': image,
    //   'note': notes
    // };

    // FormData formData = new FormData.fromMap(data);

    return await http.post(fullUrl, body: json.encode(data), headers: headers);
  }

  sendDoctorStore({data}) async {
    var fullUrl = Uri(
        scheme: "http",
        host: "139.59.112.145",
        path: "/api/registration/doctor/store");

    return await http.post(fullUrl, body: json.encode(data), headers: headers);
  }

  Future<http.Response> getDivision() async {
    var fullUrl = Uri(
        scheme: "http",
        host: "139.59.112.145",
        path: "/api/helper/division");

    return await http.get(fullUrl, headers: headers);
  }

  Future<http.Response> getCity(divisionID) async {
    var fullUrl = Uri(
        scheme: "http",
        host: "139.59.112.145",
        path: "/api/helper/city/"+divisionID);

    return await http.get(fullUrl, headers: headers);
  }

  sendClinicStore({data}) async {
    var fullUrl = Uri(
        scheme: "http",
        host: "139.59.112.145",
        path: "/api/registration/clinic/store");

    // var data = {
    //   'name': name,
    //   'name_bn': nameBangla,
    //   'city_id': cityId,
    //   'division_id': divisionId,
    //   'address_line_1': addressLine1,
    //   'address_line_2': addressLine2,
    //   'services': services,
    //   'surgeries': surgeries,
    //   'test_facilities': testFacilities,
    //   'location_lat': locationLat,
    //   'location_lng': locationLng,
    //   'branch_name': branchName,
    //   'reception_phone': receptionPhone,
    //   'image': image,
    //   'note': notes,
    // };

    // FormData formData = new FormData.fromMap(data);

    return await http.post(fullUrl, body: json.encode(data), headers: headers);
  }
}
