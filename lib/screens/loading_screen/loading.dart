import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartenergy_app/screens/login_screen/login.dart';
import 'package:smartenergy_app/screens/login_screen/login2.dart';
import 'package:smartenergy_app/services/tbclient_service.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late ThingsBoardService thingsBoardService;

  @override
  void initState() {
    super.initState();
    thingsBoardService = Provider.of<ThingsBoardService>(context, listen: false);

    // Simulando um delay de 2 segundos antes de navegar para a tela de login
    Timer(Duration(seconds: 3), () {
      // Destruir a tela de loading e ir para a tela de login
      loadLogin();
    });
  }

  Future<void> loadLogin( ) async {
    String? login = await thingsBoardService.tbSecureStorage.getItem("login");
    String? senha = await thingsBoardService.tbSecureStorage.getItem("senha");
    if(login !=null && senha !=null){
      Navigator.pushNamed(context, '/profile');

    }
    else{
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Login2()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
