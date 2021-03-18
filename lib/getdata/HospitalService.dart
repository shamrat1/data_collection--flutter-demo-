// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../model/Hospitalmodel.dart';


// class PlayersViewModel {
//   static List<Division> players;
//   String url = 'http://139.59.112.145/api/registration/helper/hospital'; 
//   static Future loadPlayers() async {
//     try {
//       http.Response jsonString = await http
//           .get('http://139.59.112.145/api/registration/helper/hospital');
   
//       final jsonResponse = json.decode(jsonString.body);
//       Helper helper = new Helper.fromJson(jsonResponse);

//       for (var i = 0; i < helper.data.divisions.length; i++) {
//         players.add(helper.data.divisions[i]);
//         print(helper.data.divisions[i].name);
//       }

//       return players;

//       // }
//     } catch (e) {
//       print(e);
//     }
//   }
// }