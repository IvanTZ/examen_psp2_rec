import 'package:flutter/cupertino.dart';

import '../models/user.dart';
import '../database/localDatabase.dart';

/**
 * Provider de la base de datos en Local
 * 
 * Uso los mismos nombre variables que la base de datos local para poder 
 * manejar las 2 bases de datos con la misma ventana y no crear una para 
 * cada caso
 * 
 */
class UserListProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<User> users = [];
  late User tempUser;
  late User? nou;

  UserListProvider() {
    LocalDatabase.db.database;
    allUsers();
  }

  nouUser(User user) async {
    final nouUser = User(
        name: user.name,
        email: user.email,
        address: user.address,
        phone: user.phone,
        photo:
            "https://cadena100-cdnmed.agilecontent.com/resources/jpg/1/3/1613997591631.jpg");
    final idnou = await LocalDatabase.db.insertUser(nouUser);
    nouUser.id = idnou;

    allUsers();
    print(nouUser.id);
  }

  updateUser(User user) async {
    await LocalDatabase.db.updateUser(user);
    allUsers();
  }

  allUsers() async {
    final users = await LocalDatabase.db.getAllUsers();
    this.users = [...users];
    notifyListeners();
  }

  esborraTots() async {
    final users = await LocalDatabase.db.deleteUsers();
    if (users == 1) {
      this.users = [];
    }
    allUsers();
  }

  esborraPorId(int id) async {
    await LocalDatabase.db.deleteUser(id);
    allUsers();
  }
}
