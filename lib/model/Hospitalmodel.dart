// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    Welcome({
        this.data,
    });

    Data data;

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    Data({
        this.divisions,
    });

    List<Division> divisions;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        divisions: List<Division>.from(json["divisions"].map((x) => Division.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
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
