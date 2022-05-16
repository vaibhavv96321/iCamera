import 'package:flutter/material.dart';

const themeColor = Colors.teal;
const whiteColor = Colors.white;
const blackColor = Colors.black;
final darkThemeColor = Colors.teal.shade900;

const kFieldstyle = TextStyle(
  color: Colors.black,
);

InputDecoration fieldDecoration(String fillText) {
  return InputDecoration(
    hintText: fillText,
    hintTextDirection: TextDirection.ltr,
    hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: themeColor, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: themeColor, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );
}
