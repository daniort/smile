


import 'package:flutter/material.dart';

class AppState with ChangeNotifier {

  bool _login = false;
  get login => this._login;

  void log_in(String email, String pass){

    this._login = true;
    notifyListeners();
  }

  void logout(){
    this._login = false;
    notifyListeners();
  }

  void registro(){
    // ENVIAR DATOS A FIREBASE PARA REGISTARR
    notifyListeners();
  }



}