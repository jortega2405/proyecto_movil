
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:proyecto_movil/src/pages/login/login_controller.dart';
import 'package:proyecto_movil/src/pages/resgistration/register_controller.dart';
import 'package:proyecto_movil/src/utils/colors.dart' as utils;
import 'package:proyecto_movil/src/widget/button_app.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  RegisterController _con = new RegisterController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _con.key,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _bannerApp(),
              _textDescription(),
              _textFieldUserName(),
              _textFieldEmail(),
              _textFieldPass(),
              _textFieldConfirmPass(),
              _buttonRegister(),
            ],
          ),
        ),
      )
    );
  }

  Widget _textFieldUserName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.usernameController,
        decoration: InputDecoration(
          hintText: 'Pedro Cuentas',
          labelText: 'Nombre de usuario',
          suffixIcon: Icon(
            Icons.person_outlined,
            color: utils.Colors.appColor,
          )
        ),
      ),
    );
  }

  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.emailController,
        decoration: InputDecoration(
          hintText: 'ejemplo@ejemplo.com',
          labelText: 'Correo electronico',
          suffixIcon: Icon(
            Icons.email_outlined,
            color: utils.Colors.appColor,
          )
        ),
      ),
    );
  }

  Widget _textFieldConfirmPass(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.confirmPassController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Confirmar Contraseña',
          suffixIcon: Icon(
            Icons.lock_open_outlined,
            color: utils.Colors.appColor,
          )
        ),
      ),
    );
  }

  Widget _textFieldPass(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.passController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          suffixIcon: Icon(
            Icons.lock_open_outlined,
            color: utils.Colors.appColor,
          )
        ),
      ),
    );
  }

  Widget _textDescription(){
    return Text(
      'Registro',
      style: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold
      ),
    );
  }

  Widget _bannerApp(){
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        color: utils.Colors.appColor,
        height: MediaQuery.of(context).size.height * 0.30,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [ 
                SizedBox(height: 50),
                Image.asset(
                  'assets/img/logo.png',
                  width: 150,
                  height: 100,
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(height:100),
                Text(
                  'Donde andan?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }

  Widget _textDontHaveAccount(){
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      child: Text(
        'No tienes una cuenta?',
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey
        ),
      ),
    );
  }

  Widget _buttonRegister(){
    return ButtonApp(
      onPressed: _con.register,
      text: 'Crear Cuenta',
      color: utils.Colors.appColor,
     );
  }
}