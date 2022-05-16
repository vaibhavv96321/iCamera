import 'package:flutter/material.dart';
import 'package:icamera/constant.dart';
import 'package:icamera/main.dart';
import 'package:photo_view/photo_view.dart';

class FullPhotoView extends StatelessWidget {
  String url;
  FullPhotoView(@required this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLight ? whiteColor : blackColor,
      appBar: AppBar(
        backgroundColor: Colors.white54,
        iconTheme: IconThemeData(
          color: themeColor,
        ),
        title: Text(
          'Image Full Size',
          style: TextStyle(color: themeColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(url),
        ),
      ),
    );
  }
}
