import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:data_collection/model/Hospitalmodel.dart';
import 'package:data_collection/getdata/HospitalService.dart' as Hservice;

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
  List<Division> _divitions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Hservice.HospitalService.getAllData().then((divisions) {
      setState(() {
        _divitions = divisions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: ListView.builder(
          itemCount: null == _divitions ? 0 : _divitions.length,
          itemBuilder: (BuildContext context, int index) {
            Division division = _divitions[index];
             return ListTile(
              title: Text(division.name),
            );
          }),
    ));
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
