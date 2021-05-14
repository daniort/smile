import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference _db = new FirebaseDatabase().reference();
  User _user;

  bool _login = false;
  get login => this._login;

  Future<Map<String, dynamic>> log_in(String email, String pass) async {
    try {
      UserCredential _result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      this._user = _result.user;
      if (this._user != null) {
        this._login = true;
        notifyListeners();
        return {'res': false, 'mensaje': 'Todo good :D.'};
      } else {
        return {'res': false, 'mensaje': 'Algo salió mal.'};
      }
    } catch (e) {
      // print(e.hashCode);
      // print(e.runtimeType);
      // print(e);
      FirebaseAuthException error = e;
      // print(error.code);
      return {'res': false, 'mensaje': error.message};
    }
  }

  void logout() {
    this._login = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> registro(
      String nombre, String email, String pass) async {
    try {
      print(email);
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      result.user.updateProfile(displayName: nombre);
      if (result.user != null) {
        _db.child('users').set({
          'user': nombre,
          'email': email,
          'idAuth': result.user.uid,
        });
        print(result.user);
        return {'res': true, 'mensaje': 'Todo bien, todo correcto'};
      } else {
        return {'res': false, 'mensaje': 'Algo salió mal.'};
      }
    } catch (e) {
     FirebaseAuthException error = e;
      // print(error.code);
      return {'res': false, 'mensaje': error.message};      
    }
  }
}




// 185768934
// I/flutter (13529): {res: false, mensaje: [firebase_auth/wrong-password] The password is invalid or the user does not have a password.}


