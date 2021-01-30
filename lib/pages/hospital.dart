import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:data_collection/helperClass/surgeriesField.dart';
import 'package:data_collection/helperClass/testForAddButton.dart';
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

   //service, test_facility, surgery
  final _formKey = GlobalKey<FormState>();
 // TextEditingController _nameController;
  static List<String> friendsList = [null];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     //service, test_facility, surgery
   // _nameController = TextEditingController();
    Hservice.HospitalService.getAllData().then((divisions) {
      setState(() {
        _divitions = divisions;
      });
    });
  }

  //autoCompleteTextView test
  var _divisionController = new TextEditingController();
  var _cityController = new TextEditingController();
  List division = ["Dhaka", "Chittagong", "Sylhet"];
  List city = ["Mirpur", "Dhanmondi", "Gulshan"];
 
 //service, test_facility, surgery
  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child:Column(
      children: <Widget>[
        Container(
          //margin: const EdgeInsets.only(bottom:5.0),
          child: TextField(
            decoration: InputDecoration(hintText: 'Hospital Name In English'),
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          child: TextField(
            decoration: InputDecoration(hintText: 'Hospital Name In Bangla'),
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          child: Column(
            children: <Widget>[
              AutoCompleteTextField(
                  controller: _divisionController,
                  clearOnSubmit: false,
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                  itemSubmitted: (item) {
                    _divisionController.text = item;
                  },
                  key: null,
                  suggestions: division,
                  decoration: InputDecoration(hintText: 'Division'),
                  itemBuilder: (context, item) {
                    return Container(
                      padding: EdgeInsets.all(2.0),
                      child: Row(
                        children: <Widget>[
                          Text(item),
                        ],
                      ),
                    );
                  },
                  itemSorter: (a, b) {
                    return a.compareTo(b);
                  },
                  itemFilter: (item, query) {
                    return item.toLowerCase().startsWith(query.toLowerCase());
                  })
            ],
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          child: Column(
            children: <Widget>[
              AutoCompleteTextField(
                  controller: _cityController,
                  clearOnSubmit: false,
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                  itemSubmitted: (cityItem) {
                    _cityController.text = cityItem;
                  },
                  key: null,
                  suggestions: city,
                  decoration: InputDecoration(hintText: 'City'),
                  itemBuilder: (context, cityItem) {
                    return Container(
                      padding: EdgeInsets.all(2.0),
                      child: Row(
                        children: <Widget>[
                          Text(cityItem),
                        ],
                      ),
                    );
                  },
                  itemSorter: (c, d) {
                    return c.compareTo(d);
                  },
                  itemFilter: (cityItem, query) {
                    return cityItem
                        .toLowerCase()
                        .startsWith(query.toLowerCase());
                  })
            ],
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          child: TextField(
            decoration: InputDecoration(hintText: 'Address In English'),
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          child: TextField(
            decoration: InputDecoration(hintText: 'Address In Bangla'),
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  getCurrentLocation();
                },
                color: Colors.blue[800],
                child: Icon(
                  Icons.location_on,
                  size: 20.0,
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(locationmsg),
            ],
          ),
        ),
        Container(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ 
                    Text('Services', style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16),),
                      ..._getFriends(),
                       SizedBox(height: 40,
                       ),
                      //  FlatButton(
                      //    onPressed: (){
                      //      if(_formKey.currentState.validate()){
                      //         _formKey.currentState.save();
                      //         }
                      //         },
                      //         child: Text('Submit'),
                      //         color: Colors.green,
                      // ),
                  ],
              ),
            ),
          ),
        ),
        Container(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ 
                    Text('Services', style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16),),
                      ..._getSurgeries(),
                       SizedBox(height: 40,
                       ),
                       FlatButton(
                         onPressed: (){
                           if(_formKey.currentState.validate()){
                              _formKey.currentState.save();
                              }
                              },
                              child: Text('Submit'),
                              color: Colors.green,
                      ),
                  ],
              ),
            ),
          ),
        ),
      ],
      ),
                             
        ),
         );
  }
                      
                        List<Widget> _getFriends(){
                          List<Widget> friendsTextFieldsList = [];
                          for(int i=0; i<friendsList.length; i++){
                            friendsTextFieldsList.add(
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  children: [
                                    Expanded(child: FriendTextFields(i)),
                                    SizedBox(width: 16,),
                                    // we need add button at last friends row only
                                    _addRemoveButton(i == friendsList.length-1, i),
                                  ],
                                ),
                              )
                            );
                          }
                          return friendsTextFieldsList;
                        }

                        Widget _addRemoveButton(bool add, int index){
                            return InkWell(
                              onTap: (){
                                if(add){
                                  // add new text-fields at the top of all friends textfields
                                  friendsList.insert(0, null);
                                }
                                else friendsList.removeAt(index);
                                setState((){});
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: (add) ? Colors.green : Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  (add) ? Icons.add : Icons.remove, color: Colors.white,
                                ),
                              ),
                            );
                          }


                          //surgery
                          List<Widget> _getSurgeries(){
                          List<Widget> friendsTextFieldsList = [];
                          for(int i=0; i<friendsList.length; i++){
                            friendsTextFieldsList.add(
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  children: [
                                    Expanded(child: SurgeriTextField(i)),
                                    SizedBox(width: 16,),
                                    // we need add button at last friends row only
                                    _addRemoveButton(i == friendsList.length-1, i),
                                  ],
                                ),
                              )
                            );
                          }
                          return friendsTextFieldsList;
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

// color: Colors.white,
//       child: ListView.builder(
//           itemCount: null == _divitions ? 0 : _divitions.length,
//           itemBuilder: (BuildContext context, int index) {
//             Division division = _divitions[index];
//              return ListTile(
//               title: Text(division.name),
//             );
//           }),


 // new ListView.builder(
                              //       itemCount: null == _divitions ? 0 : _divitions.length,
                              //       itemBuilder: (BuildContext context, int index) {
                              //         Division division = _divitions[index];
                              //         return new Container(
                              //           child: new Center(
                              //             child: new Column(
                              //               crossAxisAlignment: CrossAxisAlignment.stretch,
                              //               children: <Widget>[
                              //                 new Card(
                              //                   child: new Container(
                              //                     child: new Text(division.name),
                              //                     padding: const EdgeInsets.all(20.0),
                              //                   ),
                              //                 )
                              //               ],
                              //             ),
                              //           ),
                              //         );
                              //       })