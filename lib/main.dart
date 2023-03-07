import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'preferences/preferences.dart';
import 'providers/firebase.dart';
import 'providers/users_list_provider.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserListProvider()),
    ChangeNotifierProvider(create: (_) => Firebase()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: 'login',
      routes: {
        'home': (_) => const HomeScreen(),
        'detail': (_) => DetailScreen(),
        'nou': (_) => NouUser(),
        'login': (_) => LoginPage(),
      },
    );
  }
}
