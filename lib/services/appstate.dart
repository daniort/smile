import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseDatabase realDB = new FirebaseDatabase();
  User _user;

  bool _login = false;
  get login => this._login;

  void log_in(String email, String pass) async {
    try {
      this._user = (await _auth.signInWithEmailAndPassword(email: email, password: pass)).user;
      print("===========LOGINNNN=======");
      print(this._user.email);
      if (this._user != null)
        this._login = true;
      else
        this._login = false;
      notifyListeners();
    } catch (e) {
      print("====>>>>>>>>>>>>>>>>><<<");
      print(e);
    }
  }

  void logout() {
    this._login = false;
    notifyListeners();
  }

  Future<void> registro(String email, String pass) async {
    print(email);
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password:pass);
      // result.user.sendEmailVerification();
      print(result.user);
      


    // ENVIAR DATOS A FIREBASE PARA REGISTARR
    notifyListeners();
  }
}

// Future<void> _signInWithEmailAndPassword() async {
//   try {
//     final User user = (await _auth.signInWithEmailAndPassword(
//       email: _emailController.text,
//       password: _passwordController.text,
//     ))
//         .user;

//     Scaffold.of(context).showSnackBar(
//       SnackBar(
//         content: Text('${user.email} signed in'),
//       ),
//     );
//   } catch (e) {
//     Scaffold.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Failed to sign in with Email & Password'),
//       ),
//     );
//   }
// }
