import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smile/pages/chat.dart';
import 'package:smile/pages/home.dart';
import 'package:smile/pages/splash.dart';
import 'package:smile/services/appstate.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// void main() => runApp(MyApp());

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //rest of the code
   runApp(MyApp());
  }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Firebase.initializeApp();
    return ChangeNotifierProvider(
      create: (BuildContext context) => AppState(),
      child: MaterialApp(
        title: 'Smile Chat',
        initialRoute: '/',
        theme: ThemeData(primarySwatch: Colors.lime,
        primaryColor: Color(0xFFA0D523),
        ),
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
