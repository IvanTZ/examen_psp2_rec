import 'package:firebase_demo/preferences/preferences.dart';
import 'package:firebase_demo/providers/users_list_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/firebase.dart';
import '../ui/input_decorations.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final usersProvLocal = Provider.of<UserListProvider>(context, listen: true);
    final usersProvFire = Provider.of<Firebase>(context, listen: true);
    final provider;
    if (Preferences.online) {
      provider = usersProvFire;
    } else {
      provider = usersProvLocal;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(provider.tempUser!.photo)),
              ),
            ),
            Text('Nom: ${provider.tempUser!.name}'),
            Text('Email: ${provider.tempUser!.email}'),
            SizedBox(height: 10),
            Text('Address: ${provider.tempUser!.address}'),
            SizedBox(height: 30),
            Text('Telefon: ${provider.tempUser!.phone}'),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
