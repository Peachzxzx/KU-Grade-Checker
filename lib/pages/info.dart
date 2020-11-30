import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  var _id;
  var _password;
  final _storage = new FlutterSecureStorage();
  _InfoPageState() {
    _getData();
  }

  Future<void> _getData() async {
    String ids = await _storage.read(key: 'Nontri username');
    String passwords = await _storage.read(key: 'Nontri password');
    setState(() {
      _id = ids;
      _password = passwords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Nontri Account")),
      body: new Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            new Container(child: Text("Username: $_id")),
            new Container(child: Text("Password: $_password")),
            _buildLogoutButtons()
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButtons() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new RaisedButton(
              child: new Text(
                'Logout',
                style: TextStyle(color: Color(0xFFFFFFFF)),
              ),
              onPressed: _logoutPressed,
              color: Color(0xFFFF0000)),
        ],
      ),
    );
  }

  Future<void> _logoutPressed() async {
    await _storage.deleteAll();
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }
}
