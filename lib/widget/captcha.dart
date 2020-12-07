import 'package:flutter/material.dart';
import 'package:ku_auto_grade_check/client.dart';
import 'dart:core';

class CaptchaImage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CaptchaImageState();
}

class _CaptchaImageState extends State<CaptchaImage> {
  static const url = "https://grade-std.ku.ac.th/image_capt.php";
  // static const url = "https://pirun.ku.ac.th/~b6110500241/01388263/favicon.ico";
  var _captchaImage;
  var client = new Session();
  _CaptchaImageState() {
    client
        .get(url)
        .then((response) => _captchaImage =
            Image.memory(response.bodyBytes, gaplessPlayback: true).image);
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Spacer(),
      Image(image: this._captchaImage),
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

  Future<void> getCaptchaImage() async {
    var response = await client.get(url);
    setState(() {
      _captchaImage = Image.memory(response.bodyBytes, gaplessPlayback: true).image;
    });
  }

  Future<void> onPress() async {
    await getCaptchaImage();
  }
}
