import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  String _username = "";
  String _password = "";
  bool _showPassword = false;
  final _storage = new FlutterSecureStorage();
  _LoginPageState() {
    _usernameFilter.addListener(_usernameListen);
    _passwordFilter.addListener(_passwordListen);
  }

  Future<void> _saveValue() async {
    await _storage.write(key: 'Nontri username', value: _username);
    await _storage.write(key: 'Nontri password', value: _password);
  }

  void _usernameListen() {
    if (_usernameFilter.text.isEmpty) {
      _username = "";
    } else {
      _username = _usernameFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("KU Auto Grade Check"),
    );
  }

  Widget _buildTextFields() {
    final node = FocusScope.of(context);
    return new Container(
      child: new Column(
        children: <Widget>[
          _buildUsernameTextField(node),
          _buildPasswordTextField(node),
        ],
      ),
    );
  }

  Widget _buildUsernameTextField(node) {
    return new Container(
      child: new TextField(
        controller: _usernameFilter,
        decoration: new InputDecoration(
            labelText: 'Nontri Account', icon: Icon(Icons.person)),
        onEditingComplete: () => node.nextFocus(),
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _buildPasswordTextField(node) {
    return new Container(
        child: new TextField(
      controller: _passwordFilter,
      decoration: new InputDecoration(
          labelText: 'Password',
          icon: Icon(Icons.security),
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: this._showPassword ? Colors.blue : Colors.grey,
              ),
              onPressed: () {
                setState(() => this._showPassword = !this._showPassword);
              })),
      obscureText: !this._showPassword,
      enableSuggestions: false,
      autocorrect: false,
      onSubmitted: (_) {
        node.unfocus();
        _loginPressed();
      },
      textInputAction: TextInputAction.done,
    ));
  }

  Widget _buildButtons() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new RaisedButton(
              child: new Text(
                'Login',
                style: TextStyle(color: Color(0xFFFFFFFF)),
              ),
              onPressed: _loginPressed,
              color: Color(0xFFB2BB1E),
              ),
        ],
      ),
    );
  }

  // These functions can self contain any user auth logic required, they all have access to _username and _password

  Future<void> _loginPressed() async {
    await _saveValue();
    Navigator.pushNamed(context, '/info');
  }
}
