// import 'dart:convert';

// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:data_collection/model/Hospitalmodel.dart';

// // class HospitalService {
// //   //
// //   static const String url =
// //       'http://139.59.112.145/api/registration/helper/hospital';

// //   // static Future<List<Division>> getAllData() async {
// //   //   try {
// //   //     final response = await http.get(url);
// //   //     if (200 == response.statusCode) {
// //   //       final List<Division> divitions = welcomeFromJson(response.body) as List<Division>;
// //   //       return divitions;
// //   //     } else {
// //   //       // ignore: deprecated_member_use
// //   //       return List<Division>();
// //   //     }
// //   //   } catch (e) {
// //   //     // ignore: deprecated_member_use
// //   //     return List<Division>();
// //   //   }
// //   // }
// // }

// class PlayersViewModel {
//   static List<Division> players;
//   static const String url =
//       'http://139.59.112.145/api/registration/helper/hospital';
//   static Future loadPlayers() async {
//     try {
//       players = new List<Division>();
//       //var jsonString = await http.get(url);
//       String jsonString1 = await rootBundle.loadString(url);
//       Map parsedJson = json.decode(jsonString1);
//       var categoryJson = parsedJson['divisions'] as List;
//       for (int i = 0; i < categoryJson.length; i++) {
//         players.add(new Divisions.fromJson(categoryJson[i]));
//         print('aaaaaaaa: $players.');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
// }

import 'dart:convert';



import 'package:http/http.dart' as http;

import '../model/Hospitalmodel.dart';


class PlayersViewModel {
  static List<Division> players;
  String url = 'http://139.59.112.145/api/registration/helper/hospital'; 
  static Future loadPlayers() async {
    try {
      // players = new List<Division>();
      //var jsonString = await http.get(url);
      http.Response jsonString = await http
          .get('http://139.59.112.145/api/registration/helper/hospital');
      // String jsonString1 = await rootBundle.loadString(url);
      //  Map parsedJson = json.decode(jsonString1);
      // var categoryJson = parsedJson['divisions'] as List;
      // for (int i = 0; i < categoryJson.length; i++) {
      //   players.add(new Division.fromJson(categoryJson[i]));
      //   print('aaaaaaaa: $players.');
      //List<Division> players = [];
      final jsonResponse = json.decode(jsonString.body);
      Helper helper = new Helper.fromJson(jsonResponse);

      for (var i = 0; i < helper.data.divisions.length; i++) {
        players.add(helper.data.divisions[i]);
        print(helper.data.divisions[i].name);
      }

      return players;

      // }
    } catch (e) {
      print(e);
    }
  }
}