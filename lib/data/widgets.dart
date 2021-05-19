import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile/data/colors.dart';
import 'package:smile/services/appstate.dart';

InputDecoration myInputDecoration(String label, Color col) {
  return InputDecoration(
    errorStyle: TextStyle(color: Colors.white),
    contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
    labelStyle: TextStyle(color: Colors.grey),
    // labelText: label,
    hintText: label,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(width: 0, color: Colors.white),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(width: 0, color: Colors.white),
    ),
    fillColor: col,
    filled: true,
  );
}

Drawer myDrawer(BuildContext context) {
  final _state = Provider.of<AppState>(context, listen: false);
  return Drawer(
    child: Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 50),
          color: primario,
          child: Image.asset(
            'assets/images/logo2.png',
            height: 100,
          ),
        ),
        ListTile(
          title: Text(_state.isUser.displayName),
          leading: Icon(Icons.person),
        ),
        ListTile(
          title: Text('Cerrar sesión'),
          leading: Icon(Icons.exit_to_app),
          onTap: () => _state.logout(),
        ),
        Expanded(child: SizedBox()),
        Container(
          width: double.infinity,
          color: Colors.grey[200],
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text('    '),
        )
      ],
    ),
  );
}

FloatingActionButton myBotonFlotante(
    BuildContext context, TextEditingController mycontrolador) {
  final _state = Provider.of<AppState>(context, listen: false);
  return FloatingActionButton(
    backgroundColor: primario,
    child: Icon(Icons.add, color: Colors.white),
    onPressed: () {
      // abrrir un modal para agrega run nuevo usaurio
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    title: Text('Nuevo Mensaje'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text('Para:'),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: mycontrolador,
                      decoration: myInputDecoration(
                          'Escribre un correo electrónico', Colors.grey[200]),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (mycontrolador.text.isNotEmpty) {
                        Map _res =
                            await _state.getDataUserByEmail(mycontrolador.text);
                        print(_res);
                        if (_res != null) {
                          mycontrolador.clear();
                          Navigator.pop(context);
                          Navigator.pushNamed(context, 'chat', arguments: {
                            'id': _res['idAuth'],
                            'nombre': _res['name'],
                            'keyGrupo': null,
                          });
                        }
                      }
                    },
                    splashColor: Colors.limeAccent,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 5.0,
                              offset: Offset(0.0, 0.75)),
                        ],
                        color: Color(0xFFA0D523),
                      ),
                      width: double.infinity,
                      child: Center(
                        child: Text('Continuar',
                            style: TextStyle(
                                fontFamily: 'DMSansBold',
                                color: Colors.white,
                                fontSize: 15)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
