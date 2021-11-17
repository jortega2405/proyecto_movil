import 'package:flutter/material.dart';
import 'package:proyecto_movil/src/pages/home/components/banner.dart';
import 'package:proyecto_movil/src/pages/home/components/floating_button.dart';
import 'package:proyecto_movil/src/pages/login/login_controller.dart';


class Body extends StatelessWidget {

  LoginController _con = new LoginController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.exit_to_app_outlined),
                onPressed: _con.singOut,
              ),
            ),
            SizedBox(height: 10),
            HomeBanner(),
            SizedBox(height: 30),
            HomeImage(),
          ],
        ),
      ),
    );
  }
}