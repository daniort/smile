import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile/data/widgets.dart';
import 'package:smile/services/appstate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    // print(argumentos['id']);
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
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.solidFrown, color: Colors.grey, size: 45),
                        SizedBox(height: 20),
                        Text('Aún no tienes mensajes', style: TextStyle(color:Colors.grey),),
                      ],
                    );

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
                        _state.nuevoMensaje(mensaje.text, argumentos['id']);
                        mensaje.clear();
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
}
