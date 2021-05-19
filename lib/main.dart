import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smile/pages/chat.dart';
import 'package:smile/pages/home.dart';
import 'package:smile/pages/registro.dart';
import 'package:smile/pages/splash.dart';
import 'package:smile/services/appstate.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AppState(),
      child: MaterialApp(
        title: 'Smile',
        initialRoute: '/',
        theme: ThemeData(
            primarySwatch: Colors.lime,
            primaryColor: Color(0xFFA0D523),
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              actionsIconTheme: IconThemeData(color: Colors.white),
              color: Color(0xFFA0D523),
              // elevation: 1.0,
              textTheme: TextTheme(
                headline6: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )),
        routes: {
          "/": (BuildContext context) {
            final _state = Provider.of<AppState>(context);
            if (_state.login) {
              return HomePage();
            } else
              return SplashPage();
          },
          'chat': (_) => ChatPage(),
          'registro': (_) => RegistroPage(),
        },
      ),
    );
  }
}
