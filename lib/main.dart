import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartenergy_app/screens/loading_screen/loading.dart';
import 'package:smartenergy_app/routes/routes.dart';
import 'package:smartenergy_app/services/tbclient_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  ThingsBoardService thingsBoardService = ThingsBoardService(); // quando for usar mude o login e senha
  await thingsBoardService.isLoggedIn();
  runApp(
    MultiProvider(
      providers: [
        Provider<ThingsBoardService>.value(value: thingsBoardService),
      ],
      child: MyApp(),
    ),
  );
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
