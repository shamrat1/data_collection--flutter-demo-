// To parse this JSON data, do
//
//     final doctorHelper = doctorHelperFromJson(jsonString);

import 'dart:convert';

DoctorHelper doctorHelperFromJson(String str) => DoctorHelper.fromJson(json.decode(str));

String doctorHelperToJson(DoctorHelper data) => json.encode(data.toJson());

class DoctorHelper {
    DoctorHelper({
        this.status,
        this.msg,
        this.data,
    });

    String status;
    String msg;
    Data data;

    factory DoctorHelper.fromJson(Map<String, dynamic> json) => DoctorHelper(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data.toJson(),
    };
}

class Data {
    Data({
        this.departments,
        this.expertises,
        this.designations,
        this.divisions,
        this.visitHours,
        this.visitFees,
    });

    List<Department> departments;
    List<dynamic> expertises;
    List<Department> designations;
    List<Division> divisions;
    List<Visit> visitHours;
    List<Visit> visitFees;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        departments: json["departments"] == null ? null : List<Department>.from(json["departments"].map((x) => Department.fromJson(x))),
        expertises: json["expertises"] == null ? null : List<dynamic>.from(json["expertises"].map((x) => x)),
        designations: json["designations"] == null ? null : List<Department>.from(json["designations"].map((x) => Department.fromJson(x))),
        divisions: json["divisions"] == null ? null : List<Division>.from(json["divisions"].map((x) => Division.fromJson(x))),
        visitHours: json["visit_hours"] == null ? null : List<Visit>.from(json["visit_hours"].map((x) => Visit.fromJson(x))),
        visitFees: json["visit_fees"] == null ? null : List<Visit>.from(json["visit_fees"].map((x) => Visit.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "departments": departments == null ? null : List<dynamic>.from(departments.map((x) => x.toJson())),
        "expertises": expertises == null ? null : List<dynamic>.from(expertises.map((x) => x)),
        "designations": designations == null ? null : List<dynamic>.from(designations.map((x) => x.toJson())),
        "divisions": divisions == null ? null : List<dynamic>.from(divisions.map((x) => x.toJson())),
        "visit_hours": visitHours == null ? null : List<dynamic>.from(visitHours.map((x) => x.toJson())),
        "visit_fees": visitFees == null ? null : List<dynamic>.from(visitFees.map((x) => x.toJson())),
    };
}

class Department {
    Department({
        this.id,
        this.name,
    });

    int id;
    String name;

    factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
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
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        cities: json["cities"] == null ? null : List<City>.from(json["cities"].map((x) => City.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "cities": cities == null ? null : List<dynamic>.from(cities.map((x) => x.toJson())),
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
        id: json["id"] == null ? null : json["id"],
        divisionId: json["division_id"] == null ? null : json["division_id"],
        name: json["name"] == null ? null : json["name"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "division_id": divisionId == null ? null : divisionId,
        "name": name == null ? null : name,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    };
}

class Visit {
    Visit({
        this.id,
        this.days,
        this.from,
        this.to,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    String days;
    String from;
    String to;
    DateTime createdAt;
    DateTime updatedAt;

    factory Visit.fromJson(Map<String, dynamic> json) => Visit(
        id: json["id"] == null ? null : json["id"],
        days: json["days"] == null ? null : json["days"],
        from: json["from"] == null ? null : json["from"],
        to: json["to"] == null ? null : json["to"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "days": days == null ? null : days,
        "from": from == null ? null : from,
        "to": to == null ? null : to,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    };
}
