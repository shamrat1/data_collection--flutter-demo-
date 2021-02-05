// class Helper {
//   String status;
//   String msg;
//   Data data;

//   Helper({this.status, this.msg, this.data});

//   Helper.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     msg = json['msg'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['msg'] = this.msg;
//     if (this.data != null) {
//       data['data'] = this.data.toJson();
//     }
//     return data;
//   }
// }

// class Data {
//   List<Services> services;
//   List<Surguries> surguries;
//   List<TestFacilities> testFacilities;
//   List<Divisions> divisions;

//   Data({this.services, this.surguries, this.testFacilities, this.divisions});

//   Data.fromJson(Map<String, dynamic> json) {
//     if (json['services'] != null) {
//       services = new List<Services>();
//       json['services'].forEach((v) {
//         services.add(new Services.fromJson(v));
//       });
//     }
//     if (json['surguries'] != null) {
//       surguries = new List<Surguries>();
//       json['surguries'].forEach((v) {
//         surguries.add(new Surguries.fromJson(v));
//       });
//     }
//     if (json['test_facilities'] != null) {
//       testFacilities = new List<TestFacilities>();
//       json['test_facilities'].forEach((v) {
//         testFacilities.add(new TestFacilities.fromJson(v));
//       });
//     }
//     if (json['divisions'] != null) {
//       divisions = new List<Divisions>();
//       json['divisions'].forEach((v) {
//         divisions.add(new Divisions.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.services != null) {
//       data['services'] = this.services.map((v) => v.toJson()).toList();
//     }
//     if (this.surguries != null) {
//       data['surguries'] = this.surguries.map((v) => v.toJson()).toList();
//     }
//     if (this.testFacilities != null) {
//       data['test_facilities'] =
//           this.testFacilities.map((v) => v.toJson()).toList();
//     }
//     if (this.divisions != null) {
//       data['divisions'] = this.divisions.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Services {
//   int id;
//   String name;

//   Services({this.id, this.name});

//   Services.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     return data;
//   }
// }

// class Surguries {
//   int id;
//   String name;

//   Surguries({this.id, this.name});

//   Surguries.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     return data;
//   }
// }

// class TestFacilities {
//   int id;
//   String name;

//   TestFacilities({this.id, this.name});

//   TestFacilities.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     return data;
//   }
// }

// class Divisions {
//   int id;
//   String name;
//   List<Cities> cities;

//   Divisions({this.id, this.name, this.cities});

//   Divisions.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     if (json['cities'] != null) {
//       cities = new List<Cities>();
//       json['cities'].forEach((v) {
//         cities.add(new Cities.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     if (this.cities != null) {
//       data['cities'] = this.cities.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Cities {
//   int id;
//   int divisionId;
//   String name;
//   String createdAt;
//   String updatedAt;

//   Cities({this.id, this.divisionId, this.name, this.createdAt, this.updatedAt});

//   Cities.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     divisionId = json['division_id'];
//     name = json['name'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['division_id'] = this.divisionId;
//     data['name'] = this.name;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }




import 'dart:convert';

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
        services: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
        surguries: List<Service>.from(json["surguries"].map((x) => Service.fromJson(x))),
        testFacilities: List<Service>.from(json["test_facilities"].map((x) => Service.fromJson(x))),
        divisions: List<Division>.from(json["divisions"].map((x) => Division.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
        "surguries": List<dynamic>.from(surguries.map((x) => x.toJson())),
        "test_facilities": List<dynamic>.from(testFacilities.map((x) => x.toJson())),
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
