import 'package:core_tune/auth/login_w_google.dart';
import 'package:core_tune/splash/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

/*void firebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => SignInGoogleProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ),
      );

  /*return StreamProvider.value(
      value: AuthService().user,
      initialData: true,
      child: MaterialApp(
        title: 'Core - Tune',
        home: Wrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }*/
}

class ErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [],
    )));
  }
}
