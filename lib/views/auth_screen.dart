import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shop/widgets/auth_card.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(215, 117, 255, 1),
                Color.fromRGBO(255, 188, 117, 1),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 45),
                    Container(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'Minha Loja',
                          style: TextStyle(
                            fontFamily: 'Anton',
                            color: Theme.of(context).accentTextTheme.headline6.color,
                            fontSize: 45,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0,2),
                          ),
                        ],
                      ),
                      transform: Matrix4.rotationZ(-8 * pi / 1800)..translate(-5.0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 45,
                      ),
                      margin: EdgeInsets.only(bottom: 20),
                    ),
                    AuthCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
