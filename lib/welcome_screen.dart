import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icamera/constant.dart';
import 'package:icamera/home_screen.dart';
import 'package:icamera/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'check_device.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  final String nickname = 'null';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences? preferences;

  bool isLoggedIn = false;
  bool isLoading = false;
  User? currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: isLight ? whiteColor : blackColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: DefaultTextStyle(
                  style: const TextStyle(
                      color: themeColor,
                      fontSize: 40.0,
                      fontFamily: 'agne',
                      fontWeight: FontWeight.bold),
                  child: Text('iCamera'),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: controlSignIn,
                child: Container(
                  child: Image.asset(
                    'images/google_login.jpg',
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              isLoading
                  ? CircularProgressIndicator(
                      color: isLight ? blackColor : whiteColor,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null>? controlSignIn() async {
    preferences = await SharedPreferences.getInstance();
    this.setState(() {
      isLoading = true;
    });
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuthentication =
        await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken);
    User? firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      // sign in success
      final QuerySnapshot resultQuery = await FirebaseFirestore.instance
          .collection("users")
          .where('id', isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;

      //save data if new user
      if (documentSnapshots.length == 0) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .set({"nickname": firebaseUser.displayName});
        currentUser = firebaseUser;
        await preferences!.setString("nickname", widget.nickname);
      } else {
        currentUser = firebaseUser;
        await preferences!
            .setString("nickname", documentSnapshots[0]["nickname"]);
        print('completed exisiting user');
      }
      Fluttertoast.showToast(msg: "Congrates! SignIn Success");
      this.setState(() {
        isLoading = false;
      });
      print('reached final to step into homescreen');
      Navigator.pushNamed(context, DeviceNo.id);
    } else {
      print('Signin failed');
      // SignIn Failed
      Fluttertoast.showToast(msg: "Try Again! SignIn Failed");
      this.setState(() {
        isLoading = false;
      });
    }
  }
}
