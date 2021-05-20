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
      floatingActionButton: myBotonFlotante(context, correoController),
      drawer: myDrawer(context),
      appBar: AppBar(backgroundColor: primario),
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
                  for (var item in _conversaciones)
                    itemConversacion(item, context),
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

  Widget itemConversacion(Map item, BuildContext context) {
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
        tileColor:
            (!_mensajes[0]['visto'] && _mensajes[0]['remite'] != _state.idUser)
                ? Colors.grey[200]
                : Colors.grey[100],
        title: Text(
          _names[0].toUpperCase(),
          overflow: TextOverflow.fade,
          maxLines: 1,
        ),


        subtitle: (_mensajes[0].containsKey('imagen') && _mensajes[0]['imagen'] == true)
            ? Row(
              children: [
                Icon(Icons.image, color: Colors.grey[400]),
                Text('Foto'),
              ],
            )
            : Text(
                _mensajes[0]['mensaje'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),



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
