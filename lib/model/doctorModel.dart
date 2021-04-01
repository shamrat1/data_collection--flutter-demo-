// To parse this JSON data, do
//
//     final doctorHelper = doctorHelperFromJson(jsonString);

import 'dart:convert';

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

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);


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
    List<Department> expertises;
    List<Department> designations;
    List<Division> divisions;
    List<VisitHour> visitHours;
    List<VisitFee> visitFees;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        departments: List<Department>.from(json["departments"].map((x) => Department.fromJson(x))),
        expertises: List<Department>.from(json["expertises"].map((x) => Department.fromJson(x))),
        designations: List<Department>.from(json["designations"].map((x) => Department.fromJson(x))),
        divisions: List<Division>.from(json["divisions"].map((x) => Division.fromJson(x))),
        visitHours: List<VisitHour>.from(json["visit_hours"].map((x) => VisitHour.fromJson(x))),
        visitFees: List<VisitFee>.from(json["visit_fees"].map((x) => VisitFee.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "departments": List<dynamic>.from(departments.map((x) => x.toJson())),
        "expertises": List<dynamic>.from(expertises.map((x) => x.toJson())),
        "designations": List<dynamic>.from(designations.map((x) => x.toJson())),
        "divisions": List<dynamic>.from(divisions.map((x) => x.toJson())),
        "visit_hours": List<dynamic>.from(visitHours.map((x) => x.toJson())),
        "visit_fees": List<dynamic>.from(visitFees.map((x) => x.toJson())),
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
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
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

class VisitFee {
    VisitFee({
        this.id,
        this.type,
        this.fee,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    String type;
    String fee;
    DateTime createdAt;
    DateTime updatedAt;

    factory VisitFee.fromJson(Map<String, dynamic> json) => VisitFee(
        id: json["id"],
        type: json["type"],
        fee: json["fee"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "fee": fee,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class VisitHour {
    VisitHour({
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

    factory VisitHour.fromJson(Map<String, dynamic> json) => VisitHour(
        id: json["id"],
        days: json["days"],
        from: json["from"],
        to: json["to"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "days": days,
        "from": from,
        "to": to,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
