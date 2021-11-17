import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_movil/src/pages/home/home.dart';
import 'package:proyecto_movil/src/pages/login/login.dart';
import 'package:proyecto_movil/src/pages/map/map.dart';
import 'package:proyecto_movil/src/pages/resgistration/register.dart';
import 'package:proyecto_movil/src/utils/colors.dart' as utils;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto CUC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          elevation: 0,
        ),
        primaryColor: utils.Colors.appColor,
      ),
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginPage(),
        'register': (context) => RegisterPage(),
        'map': (context) => MapPage(),
        'home': (context) => HomePage(),
      },
    );
  }
}
