import 'package:flutter/material.dart';
import 'package:smile/pages/chat.dart';
import 'package:smile/pages/home.dart';
import 'package:smile/pages/splash.dart';
import 'package:smile/services/appstate.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AppState(),
      child: MaterialApp(
        title: 'Smile Chat',
        initialRoute: '/',
        routes: {
          "/": (BuildContext context) {
            final _state = Provider.of<AppState>(context);
            if (_state.login) {
              return HomePage();
            } else
              return SplashPage();
          },
          'chat': (_) => ChatPage(),
        },
      ),
    );
  }
}
