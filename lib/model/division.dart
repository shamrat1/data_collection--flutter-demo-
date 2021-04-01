// To parse this JSON data, do
//
//     final divisionData = divisionDataFromJson(jsonString);

import 'dart:convert';

DivisionData divisionDataFromJson(String str) => DivisionData.fromJson(json.decode(str));

String divisionDataToJson(DivisionData data) => json.encode(data.toJson());

class DivisionData {
    DivisionData({
        this.status,
        this.msg,
        this.data,
    });

    String status;
    String msg;
    List<Datum> data;

    factory DivisionData.fromJson(Map<String, dynamic> json) => DivisionData(
        status: json["status"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.id,
        this.name,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    String name;
    DateTime createdAt;
    DateTime updatedAt;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
