import 'dart:convert';

class User {
    User({
        this.id,
        this.name,
        this.email,
        this.img,
    });

    final String id;
    final String name;
    final String email;
    final String img;

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        img: json["img"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "img": img,
    };

    @override
  String toString() {
    // TODO: implement toString
    return name;
  }
}