import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // double bott = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
        backgroundColor: Color(0xFFA0D523),
        body: Container(
          // width: EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //   bott > 0
              //       ? SizedBox()
              //       :
              Expanded(
                child: Container(
                    width: size.width * 0.7,
                    child: Image.asset('assets/images/logo1.png')),
              ),
              this.mostrarFormulario == false
                  ? Dismissible(
                      key: Key('login'),
                      direction: DismissDirection.up,
                      onDismissed: (DismissDirection dir) {
                        this.mostrarFormulario = true;
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Column(
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
                    )
                  : Expanded(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ingresa y comienza a platicar con tus amigos',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: 18),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                  controller: this._emailController,
                                  decoration: InputDecoration(
                                      errorStyle:
                                          TextStyle(color: Colors.white),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 10),
                                      labelStyle: TextStyle(color: Colors.grey),
                                      labelText: 'Correo electrónico',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 0, color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 0, color: Colors.white),
                                      ),
                                      fillColor: Colors.white,
                                      filled: true),
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
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.white),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    labelStyle: TextStyle(color: Colors.grey),
                                    labelText: 'Contraseña',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          width: 0, color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          width: 0, color: Colors.white),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true),
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
                                onTap: () {
                                  if (_formKey.currentState.validate())
                                    Provider.of<AppState>(context,
                                            listen: false)
                                        .log_in(_emailController.text,
                                            _passController.text);
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
                                onTap: (){
                                   if (_formKey.currentState.validate())
                                   Provider.of<AppState>(context,
                                            listen: false)
                                        .registro(
                                            _emailController.text,
                                          _passController.text,
                                            );
                                },
                                child: Text('Registrate aqui'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ));
  }
}
