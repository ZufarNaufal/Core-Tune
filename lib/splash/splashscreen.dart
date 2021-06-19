import 'package:core_tune/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: LoginPage(),
      duration: 5000,
      imageSize: 900,
      imageSrc: "assets/images/logo-core-tune.png",
      backgroundColor: Colors.black,
    );
  }
}
