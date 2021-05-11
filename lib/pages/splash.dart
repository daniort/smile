import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
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
              Container(
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
              )
            ],
          ),
        ));
  }
}
// sdfsdfdf
