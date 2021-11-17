import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:proyecto_movil/src/providers/auth_provider.dart';
import 'package:proyecto_movil/src/utils/progress_dialog.dart';
import 'package:proyecto_movil/src/utils/shared_pref.dart';
import 'package:proyecto_movil/src/utils/snackbar.dart' as utils;

class LoginController {
  
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  AuthProvider _authProvider;
  ProgressDialog _progressDialog;
  SharedPref _sharedPref;

  Future init(BuildContext context) async {
    this.context = context;
    _authProvider = new AuthProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
    _sharedPref = new SharedPref();
  }

  void goToRegisterPage(){
    Navigator.pushNamed(context, 'register');
  }

  void singOut() async{
    await _authProvider.singOut();
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

  void login() async{
    String email = emailController.text.trim();
    String pass = passController.text.trim();

    print('Email: $email password: $pass');

    _progressDialog.show();
    try {
      bool isLogin = await _authProvider.login(email, pass);
      _progressDialog.hide();
      if (isLogin) {
        print('El usuario esta logueado');
        utils.Snackbar.showSnackbar(context, key, 'Inicio de sesion exitoso');
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      }else{
        print('El usuario no se pudo autenticar');
        utils.Snackbar.showSnackbar(context, key, 'El usuario no se pudo autenticar');
      }
    } catch (error) {
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
      _progressDialog.hide();
      print("Error: $error");
    }
  }

  
}