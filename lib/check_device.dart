import 'package:flutter/material.dart';
import 'package:icamera/constant.dart';
import 'package:icamera/main.dart';
import 'home_screen.dart';

class DeviceNo extends StatefulWidget {
  static String id = 'deviceno';

  @override
  State<DeviceNo> createState() => _DeviceNoState();
}

class _DeviceNoState extends State<DeviceNo> {
  String device_id = '';

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
                  style: TextStyle(
                      color: isLight ? themeColor : darkThemeColor,
                      fontSize: 40.0,
                      fontFamily: 'agne',
                      fontWeight: FontWeight.bold),
                  child: Text('iCamera'),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 28.0, horizontal: 15),
                child: TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    device_id = value;
                  },
                  style: kFieldstyle,
                  decoration: fieldDecoration('Enter device ID'),
                ),
              ),
              RawMaterialButton(
                fillColor: themeColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Text('Verify'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(device_id)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
