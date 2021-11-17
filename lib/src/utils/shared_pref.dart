import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class SharedPref {
  
  void save (String key, String value)async{
    final pref = await SharedPreferences.getInstance();
    pref.setString(key, json.encode(value));
  }

  Future<dynamic>read (String key)async{
    final pref = await SharedPreferences.getInstance();
    return json.decode(pref.getString(key));
  }

  //Nombre - true - false
  //SI EXISTE UN VALOR CON UNA KEY ESTABLECIDA
  Future<bool> contains(String key)async{
    final pref = await SharedPreferences.getInstance();
    return pref.containsKey(key);
  }

  Future<bool> remove(String key) async{
    final pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }

}