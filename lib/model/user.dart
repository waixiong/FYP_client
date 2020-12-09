import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
    User({
        this.id,
        this.name,
        this.email,
        this.img,
    });

    @HiveField(0)
    final String id;
    @HiveField(1)
    final String name;
    @HiveField(2)
    final String email;
    @HiveField(3)
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