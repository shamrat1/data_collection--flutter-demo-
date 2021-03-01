class DataPost {
  final String name;
  final String nameBn;
  final int divisionId;
  final int cityId;
  final String addressLine1;
  final String addressLine2;
  final String image;
  final int receptionPhone;
  final int locationLat;
  final int locationLng;
  final String branchName;
  final List<String> services;
  final List<String> surgeries;
  final List<String> testFacilities;

  DataPost(String responseString, 
      {this.name,
      this.nameBn,
      this.divisionId,
      this.cityId,
      this.addressLine1,
      this.addressLine2,
      this.image,
      this.receptionPhone,
      this.locationLat,
      this.locationLng,
      this.branchName,
      this.services,
      this.surgeries,
      this.testFacilities});

  factory DataPost.fromJson(Map<String, dynamic> json) {
    // return DataPost(
    //   name:json['name'],
    //   nameBn: json['nameBn'],
    //   divisionId: json['divisionId'],
    //   cityId: json['cityId'],
    //   addressLine1: json['addressLine1'],
    //   addressLine2: json['addressLine2'],
    //   image: json['image'],
    //   receptionPhone: json['receptionPhone'],
    //   locationLat: json['locationLat'],
    //   locationLng: json['locationLng'],
    //   branchName: json['branchName'],
    //   services: json['services'],
    //   surgeries: json['surgeries'],
    //   testFacilities: json['testFacilities'],
    // );
  }
}
