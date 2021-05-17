import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile/data/colors.dart';
import 'package:smile/data/widgets.dart';
import 'package:smile/services/appstate.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _state = Provider.of<AppState>(context, listen: false);
    TextEditingController correoController = new TextEditingController();
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
                          controller: correoController,
                          decoration: myInputDecoration(
                              'Escribre un correo electrónico',
                              Colors.grey[200]),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (correoController.text.isNotEmpty) {
                            Map _res = await _state.getDataUserByEmail(correoController.text);
                            print(_res);
                            if (_res != null) {
                              correoController.clear();
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
                          margin: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
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
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              color: primario,
              child: Image.asset(
                'assets/images/logo2.png',
                height: 100,
              ),
            ),
            ListTile(
              title: Text('Cerrar sesión'),
              leading: Icon(Icons.exit_to_app),
              onTap: () => _state.logout(),
            ),
          ],
        ),
      ),
      appBar: AppBar(backgroundColor: Color(0xFFA0D523)),
      body: StreamBuilder(
        stream: _state.getAllUser(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // print(snapshot.data.snapshot.value);
          Map<dynamic, dynamic> _users = snapshot.data.snapshot.value;
          List us = new List();
          _users.forEach((index, dato) {
            us.add({"key": index, ...dato});
          });
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            children: [
              for (var item in us)
                if (item['idAuth'] != _state.idUser)
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      tileColor: Colors.grey[200],
                      title: Text(
                        item['name'],
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                      subtitle: Text('Hola, Buenos días!'),
                      leading: CircleAvatar(
                        backgroundColor: primario,
                        child: Text(
                          item['name'].substring(0, 2),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('2:00 p.m.',
                              style: TextStyle(color: Colors.grey)),
                          Icon(Icons.circle_notifications, color: primario)
                        ],
                      ),
                      onTap: () => Navigator.pushNamed(context, 'chat',
                          arguments: {
                            'id': item['idAuth'],
                            'nombre': item['name'],
                            'keyGrupo':null,
                          }),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
