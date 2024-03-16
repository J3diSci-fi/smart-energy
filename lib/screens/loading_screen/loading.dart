import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smartenergy_app/screens/login_screen/login.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    // Simulando um delay de 2 segundos antes de navegar para a tela de login
    Timer(Duration(seconds: 2), () {
      // Destruir a tela de loading e ir para a tela de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
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
