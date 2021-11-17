


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_movil/src/models/user.dart';

class UserProvider {

  CollectionReference _ref;

  UserProvider(){
    _ref = FirebaseFirestore.instance.collection('User');
  }
  Future<void> create(User user){
    String errorMsg;
    try {
      return _ref.doc(user.id).set(user.toJson());
    } catch (error) {
      errorMsg = error.code;
    }

    if (errorMsg != null) {
      return Future.error(errorMsg);
    }
    
  }
}