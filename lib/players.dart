import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Helper helperFromJson(String str) => Helper.fromJson(json.decode(str));

String helperToJson(Helper data) => json.encode(data.toJson());

class Helper {
  Helper({
    this.status,
    this.msg,
    this.data,
  });

  String status;
  String msg;
  Data data;

  factory Helper.fromJson(Map<String, dynamic> json) => Helper(
        status: json["status"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.services,
    this.surguries,
    this.testFacilities,
    this.divisions,
  });

  List<Service> services;
  List<Service> surguries;
  List<Service> testFacilities;
  List<Division> divisions;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        services: List<Service>.from(
            json["services"].map((x) => Service.fromJson(x))),
        surguries: List<Service>.from(
            json["surguries"].map((x) => Service.fromJson(x))),
        testFacilities: List<Service>.from(
            json["test_facilities"].map((x) => Service.fromJson(x))),
        divisions: List<Division>.from(
            json["divisions"].map((x) => Division.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
        "surguries": List<dynamic>.from(surguries.map((x) => x.toJson())),
        "test_facilities":
            List<dynamic>.from(testFacilities.map((x) => x.toJson())),
        "divisions": List<dynamic>.from(divisions.map((x) => x.toJson())),
      };
}

class Division {
  Division({
    this.id,
    this.name,
    this.cities,
  });

  int id;
  String name;
  List<City> cities;

  factory Division.fromJson(Map<String, dynamic> json) => Division(
        id: json["id"],
        name: json["name"],
        cities: List<City>.from(json["cities"].map((x) => City.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "cities": List<dynamic>.from(cities.map((x) => x.toJson())),
      };
}

class City {
  City({
    this.id,
    this.divisionId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int divisionId;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        divisionId: json["division_id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "division_id": divisionId,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Service {
  Service({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class PlayersViewModel {
  static List<Division> players;
  static List<City> cityFetchData;

  static Future loadPlayers() async {
    try {
      final String url =
          "http://139.59.112.145/api/registration/helper/hospital";

      players = new List<Division>();
      var res = await http
          .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
      Map parsedJson = json.decode(res.body);
      var categoryJson = parsedJson['data']['divisions'] as List;
      for (int i = 0; i < categoryJson.length; i++) {
        players.add(new Division.fromJson(categoryJson[i]));
      }

      cityFetchData = new List<City>();
      var cityJson = parsedJson['data']['divisions'] as List;
      for (int j = 0; j < cityJson.length; j++) {
        //var allinfo = cityJson[j];
        //for (int k = 0; k < allinfo.toString().length; k++) {
          cityFetchData.add(new City.fromJson(cityJson[j]));
        //}
        //cityFetchData.add(new City.fromJson(cityJson[j]));
      }
    } catch (e) {
      print(e);
    }
  }
}

// Dio dio = new Dio();
//   Future postData() async {
//     final String apiUrl =
//         "http://139.59.112.145/api/registration/hospital/store";
//     setState(() {
//       servicejson = jsonEncode(serviceTextList);
//       surgeryjson = jsonEncode(surgeryList);
//       testfacilityjson = jsonEncode(testFacilityList);
//     });

//     String imageFileName = imageFile.path.split('/').last;
//     // FormData formData = new FormData.fromMap({
//     //   "image": await MultipartFile.fromFile(imageFile.path,
//     //       filename: imageFileName, contentType: new MediaType('image', 'png')),
//     //   "type": "image/png"
//     // });
//     FormData formData = new FormData.fromMap({
//       "name": hospitalNameEng,
//       "name_bn": hospitalNameBang.text,
//       "city_id": 1,
//       "division_id": 1,
//       "address_line_1": addressInEng.text,
//       "address_line_2": addressInBng.text,
//       "Services": servicejson,
//       "Surgeries": surgeryjson,
//       "test_facilities": testfacilityjson,
//       "Image": {
//         "image": await MultipartFile.fromFile(imageFile.path,
//             filename: imageFileName,
//             contentType: new MediaType('image', 'png')),
//         "type": "image/png"
//       },
//       "location_lat": latmsg,
//       "location_lng": longmsg,
//       "branch_name": branchName.text,
//       "reception_phone": mobileNo.text,
//     });

//     // dynamic allOfTheUploadData = {
//     //   "name": hospitalNameEng.text,
//     //   "name_bn": hospitalNameBang.text,
//     //   "city_id": _mySelection,
//     //   "division_id": _citySelection,
//     //   "address_line_1": addressInEng.text,
//     //   "address_line_2": addressInBng.text,
//     //   "Services": servicejson,
//     //   "Surgeries": surgeryjson,
//     //   "test_facilities": testfacilityjson,
//     //   "Image": formData,
//     //   "location_lat": latmsg,
//     //   "location_lng": longmsg,
//     //   "branch_name": branchName.text,
//     //   "reception_phone": mobileNo.text,
//     // };

//     var response = await dio.post(apiUrl,
//         data: formData,
//         options: Options(headers: {
//           // "accept": "*/*",
//           "Authorization": "Bearer accresstoken",
//           // "Content-type": "multipart/form-data",
//           "Content-type": "application/json; charset:UTF-8"
//         }));

//     //return response.data;
//     if (response.statusCode == 200) {
//       return response.data;
//     } else {
//       print(response.statusCode); // 500
//       print(Error);
//     }
//   }
