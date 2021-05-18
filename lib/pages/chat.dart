import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile/data/colors.dart';
import 'package:smile/data/widgets.dart';
import 'package:smile/services/appstate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController mensaje = new TextEditingController();
  ScrollController _miControlador = new ScrollController();

  @override
  void initState() {
    super.initState();
    // _miControlador.animateTo(_miControlador.position.maxScrollExtent,
    //     duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    final _state = Provider.of<AppState>(context, listen: true);
    final argumentos = ModalRoute.of(context).settings.arguments as Map;
    Size size = MediaQuery.of(context).size;
    print(argumentos);
    return Scaffold(
        appBar: AppBar(title: Text(argumentos['nombre'])),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _state.getGroupMensages(argumentos['keyGrupo']),
                builder: (context, snapshot) {
                  if (snapshot.data == null) return _sinMensajes();
                  List _mensajes = new List();

                  if (argumentos['keyGrupo'] == null) {
                    // trae todas las conversaciones
                      snapshot.data.snapshot.value.forEach((index, data) {
                        if (data['users'].contains(_state.idUser) &&  data['users'].contains(argumentos['id']  ) )
                          data['mensajes'].forEach((i, data) => _mensajes.add(  data ) );                       
                      });

                  } else {
                    snapshot.data.snapshot.value['mensajes']
                        .forEach((index, data) {
                      _mensajes.add(data);
                    });
                  }

                  _mensajes.sort((a, b) => b['fecha'].compareTo(a['fecha']));

                  if(_mensajes.isEmpty) return Text('no tienes mensajes');

                  return ListView(
                    controller: _miControlador,
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      for (var item in _mensajes)
                        Align(
                          alignment: item['remite'] != _state.idUser
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            width: size.width * 0.5,
                            // constraints: BoxConstraints(
                            //     maxWidth: size.width * 0.8,
                            //     minWidth: size.width * 0.4),
                            decoration: BoxDecoration(
                              borderRadius: item['remite'] != _state.idUser
                                  ? BorderRadius.only(
                                      // topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    )
                                  : BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                              color: item['remite'] == _state.idUser
                                  ? Colors.grey[200]
                                  : primario,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(item['mensaje']),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              color: Colors.grey[300],
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: mensaje,
                      decoration: myInputDecoration(
                          'Escribe un nuevo mensaje', Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (mensaje.text.isNotEmpty) {
                        _state.nuevoMensaje(mensaje.text, argumentos['id'],
                            argumentos['nombre']);
                        mensaje.clear();
                        _miControlador.animateTo(
                            _miControlador.position.minScrollExtent - 100.0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn);
                      }
                    },
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Column _sinMensajes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(FontAwesomeIcons.solidFrown, color: Colors.grey, size: 45),
        SizedBox(height: 20),
        Text(
          'Aún no tienes mensajes',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
