import 'package:firebase_demo/models/models.dart';
import 'package:firebase_demo/preferences/preferences.dart';
import 'package:firebase_demo/providers/users_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/firebase.dart';
import '../ui/input_decorations.dart';

class NouUser extends StatelessWidget {
  NouUser({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user;
    if (Preferences.online) {
      user = Provider.of<Firebase>(context, listen: true);
      print("En Fire");
    } else {
      user = Provider.of<UserListProvider>(context, listen: true);
      print("En local");
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Nou User Screen'),
      ),
      body: _UserForm(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (Preferences.online) {
            user.createUser(user.nou!);
          } else {
            user.nouUser(user.nou!);
          }
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class _UserForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userForm;
    if (Preferences.online) {
      userForm = Provider.of<Firebase>(context, listen: true);
      print("En Fire");
    } else {
      userForm = Provider.of<UserListProvider>(context, listen: true);
      print("En Local");
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: userForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                initialValue: userForm.tempUser.name,
                onChanged: (value) => userForm.nou.name = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El nombre és obligatori';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre', labelText: 'Nombre:'),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: userForm.tempUser.email,
                onChanged: (value) => userForm.nou.email = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El email és obligatori';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'email', labelText: 'email:'),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: userForm.tempUser.address,
                onChanged: (value) => userForm.nou.address = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El direccion és obligatoria';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'adresa', labelText: 'adresa:'),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: userForm.tempUser.phone,
                onChanged: (value) => userForm.nou.phone = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El telefon és obligatori';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'tel', labelText: 'tel:'),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: userForm.tempUser.photo,
                onChanged: (value) => userForm.nou.photo = //imagen por defecto
                    "https://cadena100-cdnmed.agilecontent.com/resources/jpg/1/3/1613997591631.jpg",
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'La foto és obligatoria';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'foto', labelText: 'foto:'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 5),
              blurRadius: 5),
        ],
      );
}
