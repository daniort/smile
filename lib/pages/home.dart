import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile/services/appstate.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _state = Provider.of<AppState>(context, listen: false);
    Size size = MediaQuery.of(context).size;
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
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: ListTile(
              tileColor: Colors.grey[200],
              title: Text('Sarah Merino'),
              leading: CircleAvatar(backgroundColor: Colors.limeAccent),
              onTap: () => Navigator.pushNamed(context, 'chat'),
            ),
          ),
        ],
      ),
    );
  }
}

// Container(
//             margin: EdgeInsets.only(bottom: 10),
//             child: ListTile(
//               dense: true,
//               tileColor: Colors.grey[200],
//               subtitle: Text('Holiii!!'),
//               title: Text('Sarah Merino'),
//               leading: CircleAvatar(backgroundColor: Colors.lightGreen),
//               onTap: () => Navigator.pushNamed(context, 'chat'),
//               trailing: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Text('12:30 p.m.', style: TextStyle(color: Colors.grey)),
//                   Icon(Icons.circle_notifications, color: Color(0xFFA0D523))
//                 ],
//               ),
//             ),
//           ),



// Container(
//               color: Colors.lime,
//               padding: EdgeInsets.symmetric(vertical: 20),
//               width: size.width * 0.5,
//               child: Image.asset('assets/images/logo2.png', height: size.height * 0.15,),
//             ),