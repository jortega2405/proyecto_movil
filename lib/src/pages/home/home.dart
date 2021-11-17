import 'package:flutter/material.dart';
import 'package:proyecto_movil/src/pages/home/components/body.dart';
import 'package:proyecto_movil/src/components/botton_navigation_bar.dart';

import '../../../enums.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    ); 
    
  }
}