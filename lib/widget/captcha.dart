import 'package:flutter/material.dart';

class CaptchaImage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CaptchaImageState();
}

class _CaptchaImageState extends State<CaptchaImage> {
  static const url = "https://grade-std.ku.ac.th/image_capt.php";
  static int count = 0;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Spacer(),
      Image.network("$url?v=$count", gaplessPlayback: true),
      Expanded(
          child: Container(
        alignment: Alignment.centerLeft,
        child: IconButton(
          iconSize: 15,
          icon: Icon(Icons.replay),
          onPressed: onPress,
        ),
      )),
    ]);
  }

  void onPress() {
    setState(() {
      count++;
    });
  }
}