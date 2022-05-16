import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icamera/check_device.dart';
import 'package:icamera/constant.dart';
import 'package:icamera/main.dart';
import 'package:icamera/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash_screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  GoogleSignIn googleSignIn = GoogleSignIn();

  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      checkSignedIn();
    });
  }

  void checkSignedIn() async {
    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, DeviceNo.id);
      return;
    }
    Navigator.pushReplacementNamed(context, WelcomeScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "images/app_icon.jpg",
              width: 300,
              height: 300,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "You are about to enter a Whole New Experince!",
              style: TextStyle(color: isLight ? themeColor : darkThemeColor),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: isLight ? themeColor : darkThemeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
