import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile/services/appstate.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _state = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Cerrar sesión'),
              leading: Icon(Icons.exit_to_app),
              onTap: () => _state.logout(),
            ),
          ],
        ),
      ),
      appBar: AppBar(backgroundColor: Color(0xFFA0D523)),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: ListTile(
              tileColor: Colors.grey[200],
              title: Text('Sarah Merino'),
              leading: CircleAvatar(
                backgroundColor: Colors.lime,
              ),
              onTap: () => Navigator.pushNamed(context, 'chat'),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: ListTile(
              tileColor: Colors.grey[200],
              title: Text('Sarah Merino'),
              leading: CircleAvatar(backgroundColor: Colors.lime),
              // onTap: () => _state.logout(),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: ListTile(
              tileColor: Colors.grey[200],
              title: Text('Sarah Merino'),
              leading: CircleAvatar(backgroundColor: Colors.lime),
              // onTap: () => _state.logout(),
            ),
          ),
        ],
      ),
    );
  }
}
