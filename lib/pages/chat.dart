import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile/data/colors.dart';
import 'package:smile/data/widgets.dart';
import 'package:smile/services/appstate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController mensaje = new TextEditingController();
  ScrollController _miControlador = new ScrollController();
  File _image;
  final picker = ImagePicker();

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
        appBar: AppBar(
          title: Text(argumentos['nombre']),
          actions: [
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () async {
                final pickedFile =
                    await picker.getImage(source: ImageSource.camera);

                if (pickedFile != null) {
                  String _url =
                      await _state.guardarImagen(File(pickedFile.path));
                  if (_url != null) {
                    _state.nuevoMensaje(argumentos['keyGrupo'],_url, argumentos['id'], argumentos['nombre'], true);
                  }
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.image),
              onPressed: () async {
                final pickedFile =
                    await picker.getImage(source: ImageSource.gallery);

                    // await picker.getVideo(source: ImageSource.camera );

                if (pickedFile != null) {
                  String _url =
                      await _state.guardarImagen(File(pickedFile.path));
                  if (_url != null) {
                    _state.nuevoMensaje(argumentos['keyGrupo'],
                        _url, argumentos['id'], argumentos['nombre'], true);
                  }
                }
              },
            ),
            //  IconButton(
            //   icon: Icon(Icons.camera ),
            //   onPressed: () async {
            //     final pickedFile =
            //         await picker.getVideo(source: ImageSource.camera );

            //     if (pickedFile != null) {
            //       String _url =
            //           await _state.guardarImagen(File(pickedFile.path));
            //       if (_url != null) {
            //         _state.nuevoMensaje(
            //             _url, argumentos['id'], argumentos['nombre'], true);
            //       }
            //     }
            //   },
            // ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _state.getGroupMensages(argumentos['keyGrupo']),
                builder: (context, snapshot) {
                  if (snapshot.data == null) return _sinMensajes();
                  List _mensajes = new List();
                  String _keyGrupo = argumentos['keyGrupo'];

                  if (argumentos['keyGrupo'] == null) {
                    snapshot.data.snapshot.value.forEach((index, data) {
                      if (data['users'].contains(_state.idUser) &&
                          data['users'].contains(argumentos['id'])) {
                        _keyGrupo = index;
                        data['mensajes'].forEach((index, data) =>
                            _mensajes.add({'key': index, ...data}));
                      }
                    });
                  } else {
                    snapshot.data.snapshot.value['mensajes']
                        .forEach((index, data) {
                      _mensajes.add({'key': index, ...data});
                    });
                  }

                  _mensajes.sort((a, b) => b['fecha'].compareTo(a['fecha']));
                  if (_mensajes.isEmpty) return Text('no tienes mensajes');
                  if (!_mensajes[0]['visto'] &&
                      _mensajes[0]['destino'] == _state.idUser)
                    _state.cambiaraVisto(_keyGrupo, _mensajes[0]['key']);

                  return ListView(
                    controller: _miControlador,
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    children: [
                      for (var item in _mensajes)
                        Align(
                          alignment: item['remite'] != _state.idUser
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            margin: EdgeInsets.symmetric(vertical: 2),
                            constraints: BoxConstraints(
                              maxWidth: size.width * 0.7,
                              minWidth: size.width * 0.3,
                            ),
                            decoration: item['remite'] != _state.idUser
                                ? _youBoxDecoration()
                                : _meBoxDecoration(),
                            child: (item.containsKey('imagen') &&
                                    item['imagen'] == true)
                                ? Image.network(item['mensaje'], width: size.height * 0.25,)
                                : Text(item['mensaje']),
                            // Text('esto es una image')
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
                        _state.nuevoMensaje(argumentos['keyGrupo'],mensaje.text, argumentos['id'],
                            argumentos['nombre'], false);
                        mensaje.clear();
                        _miControlador.animateTo(
                            _miControlador.position.minScrollExtent,
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

  BoxDecoration _youBoxDecoration() {
    return BoxDecoration(
      color: primario,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(10),
        bottomRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
    );
  }

  BoxDecoration _meBoxDecoration() {
    return BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
    );
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
