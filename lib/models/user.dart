import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

/**
 * Model del Usuario que tratamos
 * 
 * Para firebase uso otro fromJSon para diferenciar la ID
 */
class User {
  User({
    this.id,
    this.firebaseID,
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.photo,
  });

  int? id;
  String? firebaseID;
  String name;
  String email;
  String address;
  String phone;
  String photo;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));
  factory User.fromJsonFire(String str) => User.fromMapFire(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        address: json["address"],
        phone: json["phone"],
        photo: json["photo"],
      );

  factory User.fromMapFire(Map<String, dynamic> json) => User(
        firebaseID: json["id"],
        name: json["name"],
        email: json["email"],
        address: json["address"],
        phone: json["phone"],
        photo: json["photo"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "email": email,
        "address": address,
        "phone": phone,
        "photo": photo,
      };

  User copy() => User(
      id: id,
      name: name,
      email: email,
      address: address,
      phone: phone,
      photo: photo);
}
