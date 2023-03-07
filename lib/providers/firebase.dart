import 'dart:convert';
import 'package:firebase_demo/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Firebase extends ChangeNotifier {
  final String _baseUrl =
      "examenpmm2223-default-rtdb.europe-west1.firebasedatabase.app";
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<User> persons = [];
  late User tempUser;
  late User? nou;

  Firebase() {
    getUsers();
  }

  getUsers() async {
    persons.clear();
    final url = Uri.https(_baseUrl, 'users.json');
    final response = await http.get(url);
    final Map<String, dynamic> usersMap = json.decode(response.body);

    // Mapejam la resposta del servidor, per cada usuari, el convertim a la classe i l'afegim a la llista
    usersMap.forEach((key, value) {
      final auxUser = User.fromMapFire(value);
      //auxUser.firebaseID = key;
      persons.add(auxUser);
    });

    notifyListeners();
  }

  createUser(User person) async {
    final url = Uri.https(_baseUrl, 'users.json');
    await http.post(url, body: person.toJson());
    getUsers();
  }

  updateUser(User person) async {
    final url = Uri.https(_baseUrl, 'users.json');
    await http.put(url, body: person.toJson());
    getUsers();
  }

  deleteUser(User person) async {
    final url = Uri.https(_baseUrl, 'users/${person.firebaseID}.json');
    await http.delete(url);
    getUsers();
  }
}
