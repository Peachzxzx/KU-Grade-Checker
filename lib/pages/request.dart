import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RequestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Request Page")),
      body: new Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[_buildSendRequestButtons()],
        ),
      ),
    );
  }

  Widget _buildSendRequestButtons() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new RaisedButton(
              child: new Text(
                'Send Request',
                style: TextStyle(color: Color(0xFFFFFFFF)),
              ),
              onPressed: _sendRequestPressed,
              color: Color(0xFFFF0000)),
        ],
      ),
    );
  }

  Future<void> _sendRequestPressed() async {
    print("Sent");
  }
}
