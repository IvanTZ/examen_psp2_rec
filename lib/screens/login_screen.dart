import 'package:firebase_demo/preferences/preferences.dart';
import 'package:firebase_demo/providers/users_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/firebase.dart';

/**
 * Usé StatefulWidget porque tengo un Animantion controller y los cambios
 * se reflejan al instante
 * 
 * Esta pagina trata de un login tipico con usuario y contraseña (se hace a
 * traves de un form), 
 * con el que podemos guardar las credenciales en nuestro dispositivo mendiante
 * el uso de Preferences (se activa o desactiva al clicar en el checkbox)
 * 
 * Si clicamos en el boton de abajo, nos dirije a la pantalla Home
 */
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  final GlobalKey<FormState> _key = GlobalKey();

  final RegExp emailRegExp =
      RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');
  final RegExp contRegExp = RegExp(r'^([1-zA-Z0-1@.\s]{1,255})$');
  String? _correo;
  String? _contrasena;
  String mensaje = '';
  bool _isChecked = Preferences.remember;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginForm(context),
    );
  }

  Widget loginForm(BuildContext context) {
    final firebase = Provider.of<Firebase>(context);
    final userListProvider = Provider.of<UserListProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 300.0, //size.width * .6,
          child: Form(
            key: _key,
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (text) {
                    if (text!.length == 0) {
                      return "Correo es obligatorio";
                    } else if (!emailRegExp.hasMatch(text)) {
                      return "Formato de correo incorrecto";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  textAlign: TextAlign.left,
                  initialValue: Preferences.email,
                  decoration: InputDecoration(
                    hintText: 'Escribe tu correo',
                    labelText: 'Correo',
                    counterText: '',
                    icon:
                        Icon(Icons.email, size: 32.0, color: Colors.blue[800]),
                  ),
                  onSaved: (text) => _correo = text,
                ),
                TextFormField(
                  validator: (text) {
                    if (text!.length == 0) {
                      return "Contraseña es obligatoria";
                    } else if (text.length < 5) {
                      return "Contraseña mínimo de 5 caracteres";
                    } else if (!contRegExp.hasMatch(text)) {
                      return "Contraseña incorrecta";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  maxLength: 20,
                  textAlign: TextAlign.left,
                  initialValue: Preferences.password,
                  decoration: InputDecoration(
                    hintText: 'Escribe la contraseña',
                    labelText: 'Contraseña',
                    counterText: '',
                    icon: Icon(Icons.lock, size: 32.0, color: Colors.blue[800]),
                  ),
                  onSaved: (text) => _contrasena = text,
                ),
                CheckboxListTile(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                  title: const Text('Recuerdame'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                ElevatedButton(
                  child: Text("ENTRAR"),
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      _key.currentState!.save();
                      setState(() {
                        Preferences.remember = _isChecked;
                        if (_isChecked) {
                          Preferences.email = _correo ?? '';
                          Preferences.password = _contrasena ?? '';
                        } else {
                          Preferences.email = '';
                          Preferences.password = '';
                        }
                        Navigator.pushReplacementNamed(context, 'home');
                      });
                      mensaje = 'Gràcies \n $_correo \n $_contrasena';
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
