import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:icamera/constant.dart';
import 'package:icamera/home_screen.dart';
import 'package:icamera/splash_screen.dart';
import 'package:icamera/welcome_screen.dart';

import 'check_device.dart';

bool isLight = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ICamera());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: isLight ? themeColor : darkThemeColor,
        systemNavigationBarColor: whiteColor),
  );
}

class ICamera extends StatelessWidget {
  const ICamera({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        HomeScreen.id: (context) => HomeScreen(''),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        DeviceNo.id: (context) => DeviceNo(),
      },
    );
  }
}
