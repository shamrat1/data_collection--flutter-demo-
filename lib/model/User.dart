class User {
  int id;
  String name;
  String email;

  User({this.id, this.name, this.email});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson["id"],
      name: parsedJson["name"] as String,
      email: parsedJson["email"] as String,
    );
  }
}
