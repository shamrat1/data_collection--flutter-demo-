import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Hospital extends StatefulWidget {
  @override
  _HospitalState createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  var locationmsg = " ";

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
    print(lastPosition);

    setState(() {
      locationmsg = "$position";
    });
  }

//retrive data
  final String url = 'http://139.59.112.145/api/registration/helper/hospital';
  List data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Content type", "application/json"});
    print(response.body);

    setState(() {
      var convertDataToJson = JsonCodec().decode(response.body);
      data = convertDataToJson['data'];
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int index) {
              return new Container(
                child: new Center(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new Card(
                        child: new Container(
                          child: new Text(data[3]['name']),
                          padding: const EdgeInsets.all(20.0),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }));
  }
}

// child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children:<Widget>[
//             FlatButton(
//               onPressed: () {
//                 getCurrentLocation();
//               },
//               color: Colors.blue[800],
//               child: Icon(
//                 Icons.location_on,
//                 size: 20.0,
//                 color: Colors.blue,
//               ),
//             ),
//             SizedBox(
//               height: 10.0,
//             ),
//             Text(locationmsg
//             ),
//           ],
//         ),

//  new ListView.builder(
//                 itemCount: 1,
//                 itemBuilder: (BuildContext context, int index) {
//                   return new Container(
//                     child: new Center(
//                       child: new Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: <Widget>[
//                           new Card(
//                             child: new Container(
//                               child: new Text("Hello"),
//                               padding: const EdgeInsets.all(20.0),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 })
