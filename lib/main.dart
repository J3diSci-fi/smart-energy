import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartenergy_app/api/firebase_api.dart';
import 'package:smartenergy_app/firebase_options.dart';
import 'package:smartenergy_app/screens/loading_screen/loading.dart';
import 'package:smartenergy_app/routes/routes.dart';
import 'package:smartenergy_app/services/tbclient_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  ThingsBoardService thingsBoardService = ThingsBoardService();
   await thingsBoardService.isLoggedIn();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); 
  await FirebaseApi().initNotifications();
 
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
