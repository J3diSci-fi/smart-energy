import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smartenergy_app/screens/infoScreen/infoScreen.dart';

class Splashscreen extends StatelessWidget {
  final Map<String, String> device;
  const Splashscreen({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(
            child: LottieBuilder.asset(
                "assets/Lottie/Animation - 1712852951040.json"),
          )
        ],
      ),
      nextScreen: InfoScreen(device: device),
      splashIconSize: 180,
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
    );
  }
}
