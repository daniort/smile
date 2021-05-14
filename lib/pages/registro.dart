import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile/data/widgets.dart';
import 'package:smile/services/appstate.dart';

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaKey,
      appBar: AppBar(title: Text('Registro')),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'Ingresa tus datos y disfruta de nuestros servicios',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontFamily: 'Roboto'),
              ),
              SizedBox(height: 20),
              TextFormField(
                  controller: this._nameController,
                  decoration:
                      myInputDecoration('Nombre completo', Colors.grey[200]),
                  keyboardType: TextInputType.emailAddress,
                  // ignore: missing_return
                  validator: (String val) {
                    if (val.isEmpty) return 'Este campo es necesario';
                  }),
              SizedBox(height: 10),
              TextFormField(
                  controller: this._emailController,
                  decoration:
                      myInputDecoration('Correo electrónico', Colors.grey[200]),
                  keyboardType: TextInputType.emailAddress,
                  // ignore: missing_return
                  validator: (String val) {
                    if (val.isEmpty) return 'Este campo es necesario';
                    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val) !=
                        true) {
                      return "Ingresa un correo electónico valido";
                    }
                  }),
              SizedBox(height: 10),
              TextFormField(
                controller: this._passController,
                decoration: myInputDecoration('Contraseña', Colors.grey[200]),
                keyboardType: TextInputType.text,
                obscureText: true,
                // ignore: missing_return
                validator: (String val) {
                  if (val.isEmpty) return 'Este campo es necesario';
                  if (val.length < 6) return 'La contraseña es muy corta';
                },
              ),
              InkWell(
                onTap: () async {
                  if (_formKey.currentState.validate()) {
                    Map<String, dynamic> _res =await Provider.of<AppState>(context, listen: false).registro(
                      _nameController.text,
                      _emailController.text,
                      _passController.text,
                    );
                    if(_res['res'])
                      Navigator.pop(context);
                    else
                    _scaKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(_res['mensaje'].toString()),
                        backgroundColor: Colors.pinkAccent,
                        duration: Duration(seconds: 7),
                      )
                    );

                  }
                },
                splashColor: Colors.limeAccent,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          blurRadius: 5.0,
                          offset: Offset(0.0, 0.75)),
                    ],
                    color: Color(0xFFA0D523),
                  ),
                  width: double.infinity,
                  child: Center(
                    child: Text('Registrar',
                        style: TextStyle(
                            fontFamily: 'DMSansBold',
                            color: Colors.white,
                            fontSize: 15)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
