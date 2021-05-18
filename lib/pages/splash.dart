import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile/data/widgets.dart';
import 'package:smile/services/appstate.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool mostrarFormulario = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _scaKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double bott = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
        key: _scaKey,
        backgroundColor: Color(0xFFA0D523),
        body: Container(
          // width: EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              bott > 0
                  ? SizedBox()
                  : Container(
                      // height: size.height * 0.45,
                      padding: EdgeInsets.only(
                        top: size.height * 0.15,
                      ),
                      child: Image.asset(
                        'assets/images/logo1.png',
                        height: size.height * 0.25,
                      ),
                    ),
              this.mostrarFormulario == false
                  ? Expanded(
                      child: Dismissible(
                        background: Container(color: Colors.lightGreen),
                        key: Key('login'),
                        direction: DismissDirection.up,
                        onDismissed: (DismissDirection dir) {
                          this.mostrarFormulario = true;
                          setState(() {});
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RotationTransition(
                                turns: new AlwaysStoppedAnimation(-90 / 360),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              Text(
                                'ENTRAR',
                                style: TextStyle(
                                  fontFamily: 'DMSansBold',
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Center(
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(                                                                
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Ingresa y comienza a platicar con tus amigos',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Roboto',
                                          fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                      controller: this._emailController,
                                      decoration: myInputDecoration(
                                          'Correo electrónico', Colors.white),
                                      keyboardType: TextInputType.emailAddress,
                                      // ignore: missing_return
                                      validator: (String val) {
                                        if (val.isEmpty)
                                          return 'Este campo es necesario';
                                        if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(val) !=
                                            true) {
                                          return "Ingresa un correo electónico valido";
                                        }
                                      }),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    controller: this._passController,
                                    decoration: myInputDecoration(
                                        'Contraseña', Colors.white),
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    // ignore: missing_return
                                    validator: (String val) {
                                      if (val.isEmpty)
                                        return 'Este campo es necesario';
                                      if (val.length < 6)
                                        return 'La contraseña es muy corta';
                                    },
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      if (_formKey.currentState.validate()) {
                                        Map<String, dynamic> _res =
                                            await Provider.of<AppState>(context,
                                                    listen: false)
                                                .log_in(_emailController.text,
                                                    _passController.text);
                                        print(_res);
                                        if (_res['res'])
                                          Navigator.pop(context);
                                        else
                                          _scaKey.currentState
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text(_res['mensaje'].toString()),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 7),
                                          ));
                                      }
                                    },
                                    splashColor: Colors.limeAccent,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black54,
                                              blurRadius: 5.0,
                                              offset: Offset(0.0, 0.75)),
                                        ],
                                        color: Colors.white,
                                      ),
                                      width: double.infinity,
                                      child: Center(
                                        child: Text('Entrar',
                                            style: TextStyle(
                                                fontFamily: 'DMSansBold',
                                                color: Color(0xFFA0D523),
                                                fontSize: 15)),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () =>
                                        Navigator.pushNamed(context, 'registro'),
                                    child: Text(
                                      'Registrate aqui',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ));
  }
}
