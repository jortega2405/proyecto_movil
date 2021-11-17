
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  
  FirebaseAuth _firebaseAuth;


  AuthProvider(){
    _firebaseAuth = FirebaseAuth.instance;
  }

  User getUser(){
    return _firebaseAuth.currentUser;
  }

  void checkIfUserisLoggeg(BuildContext context){
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      //QUE EL USUARIO ESTA LOGUEADO
      if (user != null) {
        print("el usuario está logueado");
        Navigator.pushNamedAndRemoveUntil(context, 'map', (route) => false);
      }else{
        print("el usuario está logueado");
      }
    });

  }

  Future<bool> login(String email, String pass) async{
    String errorMsg;

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: pass
      );
      
    } catch (error) {
      print(error);
      //Correo Invalido
      //Pass incorrecto
      //Sin conexion a internet
      errorMsg = error.code;
    }
    if (errorMsg != null) {
      return Future.error(errorMsg);
    }
    return true;
  }


  Future<bool> register(String email, String pass) async{
    String errorMsg;

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: pass
      );
      
    } catch (error) {
      print(error);
      //Correo Invalido
      //Pass incorrecto
      //Sin conexion a internet
      errorMsg = error.code;
    }
    if (errorMsg != null) {
      return Future.error(errorMsg);
    }
    return true;
  }

  Future<void> singOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

}