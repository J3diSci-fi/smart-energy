import 'package:flutter/material.dart';
import 'package:smartenergy_app/screens/loading_screen/loading.dart';
import 'package:smartenergy_app/routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Energy',
      home: LoadingPage(), // Inicializa com a tela de loading
      initialRoute: '/',
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
