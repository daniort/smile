import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile/data/colors.dart';
import 'package:smile/data/widgets.dart';
import 'package:smile/services/appstate.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController correoController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _state = Provider.of<AppState>(context, listen: false);
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
                            Map _res = await _state
                                .getDataUserByEmail(correoController.text);
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
              title: Text( _state.isUser.displayName ),
              leading: Icon(Icons.person),
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
        stream: _state.getAllGrupos(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.green));
              break;
            case ConnectionState.none:
              return Text('algo salió mal');
              break;
            case ConnectionState.active:
              Map<dynamic, dynamic> _grupoMensajes =
                  snapshot.data.snapshot.value;
              if (_grupoMensajes == null) return Text('No tienes mensajes');

              List _conversaciones = new List();

              _grupoMensajes.forEach((index, data) {
                if (data['users'].contains(_state.idUser))
                  _conversaciones.add({'key': index, ...data});
              });
              _conversaciones.sort((a, b) => b['fecha'].compareTo(a['fecha']));

              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                children: [
                  for (var item in _conversaciones) newMethod(item, context),
                ],
              );
              break;
            default:
              return Text('algo salió mal');
          }
        },
      ),
    );
  }

  Widget newMethod(Map item, BuildContext context) {
    final _state = Provider.of<AppState>(context, listen: true);

    List _names = new List.from(item['names']);
    _names.remove(_state.isUser.displayName);

    List _ids = new List.from(item['users']);
    _ids.remove(_state.idUser);

    List _mensajes = new List();

    item['mensajes'].forEach((index, data) {
      _mensajes.add(data);
    });

    _mensajes.sort((a, b) => b['fecha'].compareTo(a['fecha']));

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: Colors.grey[200],
        title: Text(
          _names[0],
          overflow: TextOverflow.fade,
          maxLines: 1,
        ),
        subtitle: Text(_mensajes[0]['mensaje']),
        leading: CircleAvatar(
          backgroundColor: primario,
          child: Text(
            _names[0].substring(0, 2).toUpperCase(),
            style: TextStyle(color: Colors.white),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(_mensajes[0]['hora'], style: TextStyle(color: Colors.grey)),
            (!_mensajes[0]['visto'] && _mensajes[0]['remite'] != _state.idUser)
                ? Icon(Icons.circle_notifications, color: primario)
                : SizedBox(),
          ],
        ),
        onTap: () => Navigator.pushNamed(context, 'chat', arguments: {
          'id': _ids[0],
          'nombre': _names[0],
          'keyGrupo': item['key'],
        }),
      ),
    );
  }
}
