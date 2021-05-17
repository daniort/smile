import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile/data/colors.dart';
import 'package:smile/services/appstate.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _state = Provider.of<AppState>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primario,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // abrir modal para nuevo user
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
                            'nombre': item['name']
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