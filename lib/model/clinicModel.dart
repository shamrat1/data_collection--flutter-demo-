// To parse this JSON data, do
//
//     final clinic = clinicFromJson(jsonString);

import 'dart:convert';

Clinic clinicFromJson(String str) => Clinic.fromJson(json.decode(str));

String clinicToJson(Clinic data) => json.encode(data.toJson());

class Clinic {
    Clinic({
        this.status,
        this.msg,
        this.data,
    });

    String status;
    String msg;
    Data data;

    factory Clinic.fromJson(Map<String, dynamic> json) => Clinic(
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
