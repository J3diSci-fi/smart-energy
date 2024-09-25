import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
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
    // Simulando um delay de 2 segundos antes de navegar para a tela de login
    Timer(Duration(seconds: 3), () {
      // Destruir a tela de loading e ir para a tela de login
      loadLogin();
    });
  }

  Future<void> loadLogin() async {
    try {
      String? login = await ThingsBoardService.tbSecureStorage.getItem("login");
      String? senha = await ThingsBoardService.tbSecureStorage.getItem("senha");
      if (login != null && senha != null) {
        Navigator.pushNamed(context, '/profile');
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login2()));
      }
    } catch (e) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login2()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          "assets/Lottie/Animation - 1716598015016.json",
          width: 150,
          height: 150,
          fit: BoxFit.cover, // ou BoxFit.fill, dependendo do que você preferir
        ),
      ),
    );
  }
}
