import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'constant.dart';
import 'main.dart';
import 'package:icamera/welcome_screen.dart';

import 'open_full_photo.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class HomeScreen extends StatefulWidget {
  String input_id;
  static String id = 'home_screen';
  HomeScreen(this.input_id);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<void> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            clipBehavior: Clip.hardEdge,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                color: themeColor,
                padding: EdgeInsets.only(bottom: 10, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30,
                        color: whiteColor,
                      ),
                      margin: EdgeInsets.only(bottom: 10),
                    ),
                    Text(
                      'Exit App',
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Really?',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: themeColor,
                      ),
                      margin: EdgeInsets.only(right: 10),
                    ),
                    Text(
                      'No',
                      style: TextStyle(
                          color: themeColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: themeColor,
                      ),
                      margin: EdgeInsets.only(right: 10),
                    ),
                    Text(
                      'Yes',
                      style: TextStyle(
                          color: themeColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isLight ? themeColor : darkThemeColor,
          centerTitle: true,
          leading: IconButton(
            icon: Switch(
              value: isLight,
              onChanged: (value) {
                setState(() {
                  isLight = value;
                });
              },
              activeTrackColor: Colors.grey,
              activeColor: Colors.white,
              inactiveTrackColor: Colors.grey,
              inactiveThumbColor: Colors.black,
            ),
            onPressed: () => "",
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 70,
              ),
              Text('iCamera',
                  style: TextStyle(
                      fontSize: 25, color: isLight ? whiteColor : blackColor)),
              SizedBox(
                width: 20,
              ),
              RawMaterialButton(
                padding: EdgeInsets.only(left: 20),
                onPressed: logoutUser,
                child: Icon(
                  Icons.logout,
                  size: 30,
                  color: isLight ? whiteColor : blackColor,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          color: isLight ? whiteColor : blackColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 25,
              ),
              BubbleStream(widget.input_id),
            ],
          ),
        ),
      ),
    );
  }

  GoogleSignIn googleSignIn = GoogleSignIn();
  Future<Null>? logoutUser() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, WelcomeScreen.id, (Route<dynamic> route) => false);
    Fluttertoast.showToast(msg: "Logged Out!");
  }
}

class BubbleStream extends StatelessWidget {
  String input_id;
  BubbleStream(this.input_id);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('links').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        List<Bubble> messageWidgets = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: themeColor,
            ),
          );
        }
        final messages = snapshot.data!.docs;
        int t = 0;
        for (var message in messages) {
          if (message.get('id') == input_id) {
            final url = message.get('link');
            final userTime = message.get('time');
            final messageWidget = Bubble(url, userTime);
            messageWidgets.add(messageWidget);
            t++;
          }
        }
        if (t == 0) {
          Fluttertoast.showToast(msg: 'Not Found any image!');
        }
        return Expanded(
          child: ListView(
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class Bubble extends StatelessWidget {
  Bubble(this.url, this.time);

  final String url;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            height: 250,
            width: 300,
            decoration: BoxDecoration(
              color: isLight ? Colors.teal.shade100 : Colors.teal.shade700,
              borderRadius: BorderRadius.circular(35),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  time,
                  style: TextStyle(
                      color: isLight ? blackColor : whiteColor,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.only(bottom: 18),
                height: 280,
                width: 280,
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullPhotoView(url)));
                    },
                    child: Image.network(url)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
