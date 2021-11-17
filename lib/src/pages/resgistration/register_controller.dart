import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:proyecto_movil/src/models/user.dart';
import 'package:proyecto_movil/src/providers/auth_provider.dart';
import 'package:proyecto_movil/src/providers/user_provider.dart';
import 'package:proyecto_movil/src/utils/progress_dialog.dart';
import 'package:proyecto_movil/src/utils/snackbar.dart' as utils;

class RegisterController {
  
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController confirmPassController = new TextEditingController();

  AuthProvider _authProvider;
  UserProvider _userProvider;
  ProgressDialog _progressDialog;

  Future init(BuildContext context) {
    this.context = context;
    _authProvider = new AuthProvider();
    _userProvider = new UserProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
  }

  void register() async{
    String username = usernameController.text;
    String email = emailController.text.trim();
    String pass = passController.text.trim();
    String confirmPass = confirmPassController.text.trim();


    print('Email: $email password: $pass');
    if (username.isEmpty && email.isEmpty && pass.isEmpty && confirmPass.isEmpty) {
      print('todos los campos son obligatorios');
      utils.Snackbar.showSnackbar(context, key, 'Todos los campos son obligatorios');
      return;
    }
    if (confirmPass != pass) {
      utils.Snackbar.showSnackbar(context, key, 'Las contraseñas no coinciden');
      print('Las contraseñas no coinciden');
      return;
    }
    if (pass.length < 6) {
      utils.Snackbar.showSnackbar(context, key, 'La contraseña debe tener por lo menos 6 caracteres');
      print('La contraseña debe tener por lo menos 6 caracteres');
      return;
    }

    _progressDialog.show();


    try {
      bool isRegister = await _authProvider.register(email, pass);
      if (isRegister) {
        User user = new User(
          id: _authProvider.getUser().uid,
          email: _authProvider.getUser().email,
          username: username,
          password: pass,
        );

        await _userProvider.create(user);

        _progressDialog.hide();
        print('El usuario se registró correctamente');
        utils.Snackbar.showSnackbar(context, key, 'El usuario se registró correctamente');
        
      }else{

        _progressDialog.hide();
        print('El usuario no se pudo resgistrar');
         utils.Snackbar.showSnackbar(context, key, 'El usuario no se pudo resgistrar');
      }
    } catch (error) {
      _progressDialog.hide();
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
      print("'Error: $error");
    }
  }

  
}