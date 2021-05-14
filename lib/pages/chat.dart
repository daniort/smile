import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile/services/appstate.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController mensaje = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _state = Provider.of<AppState>(context, listen: true);
    final argumentos = ModalRoute.of(context).settings.arguments as Map;
    print(argumentos['id']);
    return Scaffold(
        appBar: AppBar(title: Text(argumentos['nombre'])),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _state.getMensages(argumentos['id']),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.data == null)
                    return Center(child: Text('No tienes mensajes'));

                  Map<String, dynamic> _mensajes = snapshot.data;
                  List msn = new List();
                  _mensajes.forEach((index, dato) {
                    msn.add(dato);
                  });
                  return ListView(
                    children: [
                      for (var item in msn)
                        Align(
                          alignment: item['de'] == 'iddestinatario'
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.lime,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(item['mensaje']),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            Row(
              children: [
                Flexible(child: TextField(controller: mensaje)),
                IconButton(
                  onPressed: () {
                    if (mensaje.text.isNotEmpty) {
                      _state.nuevoMensaje(mensaje.text, argumentos['id']);
                      mensaje.clear();
                    }
                    print(mensaje.text);
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ],
        ));
  }
}
