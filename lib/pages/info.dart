import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ku_auto_grade_check/functions/createMaterialColor.dart';

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
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('KU Auto Grade Check',
                  style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                color: createMaterialColor(Color(0xFF006664)),
              ),
            ),
            ListTile(
              leading: Icon(Icons.wifi),
              title: Text('Request Page'),
              onTap: () {
                Navigator.pushNamed(context, '/request');
              },
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Close'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
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
