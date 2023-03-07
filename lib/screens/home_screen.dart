import 'package:firebase_demo/models/user.dart';
import 'package:firebase_demo/providers/firebase.dart';
import 'package:firebase_demo/providers/users_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../preferences/preferences.dart';
import '../widgets/widgets.dart';
import '../ui/ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usersProvLocal = Provider.of<UserListProvider>(context, listen: true);
    final usersProvFire = Provider.of<Firebase>(context, listen: true);

    User temp;
    List<User> usersLocal = [];

    if (Preferences.online) {
      usersLocal = usersProvFire.persons;
    } else {
      usersLocal = usersProvLocal.users;
    }
    /*
    if (usersLocal.isEmpty) {
      usersFire.forEach((userFire) {
        usersProvLocal.nouUser(userFire);
      });
    }
    */

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'home'),
              icon: const Icon(Icons.logout)),
          Checkbox(
              value: Preferences.online,
              onChanged: (value) {
                Preferences.online = value!;
                Navigator.pushReplacementNamed(context, 'home');
              }),
        ],
      ),
      body: Preferences.online
          ? ListView.builder(
              itemCount: usersLocal.length,
              itemBuilder: ((context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  child: GestureDetector(
                    child: UserCard(user: usersLocal[index]),
                    onTap: () {
                      usersProvFire.tempUser = usersLocal[index].copy();
                      Navigator.of(context).pushNamed('detail');
                    },
                  ),
                  onDismissed: (direction) {
                    print('ID del borrado: ${usersLocal[index].firebaseID}');
                    usersProvFire.deleteUser(usersLocal[index]);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${usersLocal[index].name} esborrat')));
                  },
                );
              }),
            )
          : ListView.builder(
              itemCount: usersLocal.length,
              itemBuilder: ((context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  child: GestureDetector(
                    child: UserCard(user: usersLocal[index]),
                    onTap: () {
                      usersProvLocal.tempUser = usersLocal[index].copy();
                      usersProvLocal.nou = usersLocal[index].copy();
                      Navigator.of(context).pushNamed('detail');
                    },
                  ),
                  onDismissed: (direction) {
                    print('ID del borrado: ${usersLocal[index].id}');
                    usersProvLocal.esborraPorId(usersLocal[index].id!);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${usersLocal[index].name} esborrat')));
                  },
                );
              }),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Cream un usuari temporal nou, per diferenciar-lo d'un ja creat,
          // per que aquest no tindrà id enUsera, i d'aquesta forma sabrem
          // discernir al detailscreen que estam creant un usuari nou i no
          // modificant un existent
          temp = User(
              id: 0, name: '', email: '', address: '', phone: '', photo: '');
          usersProvLocal.tempUser = temp;
          usersProvFire.tempUser = temp;
          usersProvFire.nou = temp;
          Navigator.of(context).pushNamed('nou');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
