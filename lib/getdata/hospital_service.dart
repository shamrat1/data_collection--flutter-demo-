import 'package:http/http.dart' as http;
import 'package:data_collection/model/Hospitalmodel.dart';


class Services {
  //
  static const String url = 'http://139.59.112.145/api/registration/helper/hospital';
  
  static Future<List<Welcome>> getAllData() async {
    try {
      final response = await http.get(url);
      if (200 == response.statusCode) {
        final Welcome welcomesData= welcomeFromJson(response.body);
      } else {
        // ignore: deprecated_member_use
        return List<Welcome>();
      }
    } catch (e) {
      // ignore: deprecated_member_use
      return List<Welcome>();
    }
  }
}