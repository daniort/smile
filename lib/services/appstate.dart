import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference _db = new FirebaseDatabase().reference();
  User _user;
  String _idUser = '';

  bool _login = false;
  get login => this._login;
  get idUser => this._idUser;

  Future<Map<String, dynamic>> log_in(String email, String pass) async {
    try {
      UserCredential _result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      this._user = _result.user;
      this._idUser = this._user.uid;
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
      print(error.code);
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
        _db.child('users').push().set({
          'name': nombre.toUpperCase(),
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
      print(error.code);
      return {'res': false, 'mensaje': error.message};
    }
  }

  Future<void> nuevoMensaje(
      String mensaje, String idDestinatario, String nombredestino) async {
    try {

      String _keyGrupo;
      Map res = (await _db.child('grupo-mensajes').once()).value;
      if (res == null) {
        _keyGrupo = await _crearGrupo(mensaje, idDestinatario,
            this._idUser, this._user.displayName, nombredestino);
        await agregarMensajeAlGrupo(_keyGrupo, mensaje, idDestinatario, this._idUser);
      }else{
          res.forEach((index, data){
            List _users = data['users'];
            if( _users.contains( this._idUser) &&  _users.contains(idDestinatario ))
              _keyGrupo = index;
          });
           await agregarMensajeAlGrupo(_keyGrupo, mensaje, idDestinatario, this._idUser);
      }

    } catch (e) {
      print(e);
    }
  }

  agregarMensajeAlGrupo(String keyGrupo, String mensaje, String idDestinatario,
      String idUser) async {
    await _db
        .child('grupo-mensajes')
        .child(keyGrupo)
        .child('mensajes')
        .push()
        .set({
      'mensaje': mensaje,
      'fecha': DateTime.now().millisecondsSinceEpoch,
      'hora': "${DateTime.now().hour}:${DateTime.now().minute}",
      'remite': this._idUser,
      'destino': idDestinatario,
      'visto': false
    }).then((data) async {
       await _db
        .child('grupo-mensajes')
        .child(keyGrupo).update({
          'fecha': DateTime.now().millisecondsSinceEpoch,
        });
    });
  }

  Future<String> _crearGrupo(String mensaje, String idDestinatario,
      String idUser, String displayName, String nombredestino) async {
    DatabaseReference referencia = _db.child('grupo-mensajes').push();
    await _db.child('grupo-mensajes').child(referencia.key).set({
      'fecha': DateTime.now().millisecondsSinceEpoch,
      'users': [idDestinatario, idUser],
      'names': [displayName, nombredestino]
    });

    return referencia.key;
  }

  Stream getMensages(String idDestinatario) {
    try {
      return _db
          .child('mensajes')
          .orderByChild('de')
          .equalTo(_idUser)
          .orderByChild('para')
          .equalTo(idDestinatario)
          .onValue;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream getAllUser() {
    return _db.child('users').onValue;
  }

  Future<Map> getDataUserByEmail(String email) async {
    try {
      DataSnapshot res =
          await _db.child('users').orderByChild('email').equalTo(email).once();
      Map info;
      res.value.forEach((index, data) {
        info = data;
      });
      return info;
    } catch (e) {
      return null;
    }
  }

  Stream getGroupMensages(String keyGrupo, String idDestinatario) {
    if(keyGrupo != null)
    return _db.child('grupo-mensajes').child(keyGrupo).onValue;
    else
    return  _db.child('grupo-mensajes').onValue;

  }
}
