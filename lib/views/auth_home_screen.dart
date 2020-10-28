import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/views/auth_screen.dart';
import 'package:shop/views/products_overview_screen.dart';

class AuthOrHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: auth.tryAuthLogin(),
      builder: (ctx, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }else if( snapshot.error != null){
          print(snapshot.error);
          return Scaffold(body: Center(child: Text('Houve uma falha no login!')));
        }else{
          return auth.isAuth ? ProductOverviewScreen() : AuthScreen();
        }
      },
    );
  }
}
