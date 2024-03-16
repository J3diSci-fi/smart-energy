import 'package:flutter/material.dart';
import 'package:smartenergy_app/screens/config_screen/config.dart';
import 'package:smartenergy_app/screens/dasbhboard_screen/dashboard.dart';
import 'package:smartenergy_app/screens/login_screen/login.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/profile':
        return MaterialPageRoute(builder: (_) => DashboardPage());
      case '/configs':
        return MaterialPageRoute(builder: (_) => ConfigPage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(child: Text('Rota não encontrada')),
                ));
    }
  }
}
