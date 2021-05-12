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

    return Scaffold(
        backgroundColor: Color(0xFFA0D523),
        body: Container(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                        print('SE HA DESLIZADO');
                        print(dir);
                        this.mostrarFormulario = true;
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 45,
                            ),
                            Text(
                              'ENTRAR',
                              style: TextStyle(
                                fontFamily: 'DMSansBold',
                                color: Colors.white,
                                fontSize: 30,
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
                            children: [
                              Text(
                                'Ingresa y comienza a platicar con tus amigos',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: 20),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: this._emailController,
                                decoration: InputDecoration(
                                    labelText: 'Correo Electrónico',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
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
                                    .hasMatch(val) != true) {
                              return "Ingresa un correo electónico valido";
                                }}
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: this._passController,
                                decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
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
                                        .log_in(_passController.text,
                                            _passController.text);

                                  // print( _passController.text );
                                },
                                splashColor: Colors.yellow,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  margin: EdgeInsets.only(top: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white,
                                  ),
                                  width: double.infinity,
                                  child: Center(
                                    child: Text('Entrar',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20)),
                                  ),
                                ),
                              )
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
