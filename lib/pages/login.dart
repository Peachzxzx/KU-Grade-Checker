import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ku_auto_grade_check/widget/captcha.dart';
import 'package:ku_auto_grade_check/client.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  final TextEditingController _captchaFilter = new TextEditingController();
  String _username = "";
  String _password = "";
  String _captcha = "";
  bool _showPassword = false;
  final _storage = new FlutterSecureStorage();
  _LoginPageState() {
    _usernameFilter.addListener(_usernameListen);
    _passwordFilter.addListener(_passwordListen);
    _captchaFilter.addListener(_captchaListen);
  }
  FocusNode passwordFocusNode;
  FocusNode captchaFocusNode;

  var client = Session();
  @override
  void initState() {
    super.initState();

    passwordFocusNode = FocusNode();
    captchaFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    passwordFocusNode.dispose();
    captchaFocusNode.dispose();

    super.dispose();
  }

  Future<void> _saveValue() async {
    await _storage.write(key: 'Nontri username', value: _username);
    await _storage.write(key: 'Nontri password', value: _password);
  }

  void _usernameListen() {
    if (_usernameFilter.text.isEmpty) {
      _username = "";
    } else if (_usernameFilter.text.length > 11) {
      _usernameFilter.text = _username;
    } else if (!(_usernameFilter.text.startsWith(new RegExp(r'[bg]')))) {
      _username = "";
    } else {
      _username = _usernameFilter.text;
    }
    _usernameFilter.selection = new TextSelection.fromPosition(
        new TextPosition(offset: _usernameFilter.text.length));
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
    _passwordFilter.selection = new TextSelection.fromPosition(
        new TextPosition(offset: _passwordFilter.text.length));
  }

  void _captchaListen() {
    if (_captchaFilter.text.isEmpty) {
      _captcha = "";
    } else if (_captchaFilter.text.length > 4) {
      _captchaFilter.text = _captcha;
    } else {
      _captcha = _captchaFilter.text;
    }
    _captchaFilter.selection = new TextSelection.fromPosition(
        new TextPosition(offset: _captchaFilter.text.length));
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
          _buildCaptchaField(node),
          new CaptchaImage(),
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
          onEditingComplete: () => node.requestFocus(passwordFocusNode),
          textInputAction: TextInputAction.next,
          inputFormatters: [
            new FilteringTextInputFormatter.allow(RegExp("[bg0-9]")),
          ]),
    );
  }

  Widget _buildPasswordTextField(node) {
    return new Container(
        child: new TextField(
      focusNode: passwordFocusNode,
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
      onEditingComplete: () => node.requestFocus(captchaFocusNode),
      obscureText: !this._showPassword,
      enableSuggestions: false,
      autocorrect: false,
      textInputAction: TextInputAction.next,
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
  Future<void> login() async {
    var url = 'https://grade-std.ku.ac.th/GSTU_login_.php';
    try {
      Session.headers['User-Agent'] =
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:83.0) Gecko/20100101 Firefox/83.0";
      Session.headers['Host'] = 'grade-std.ku.ac.th';
      Session.headers['Origin'] = 'https://grade-std.ku.ac.th';
      Session.headers['Referer'] = 'https://grade-std.ku.ac.th/GSTU_login_.php';
      var response = await client.post(url, {
        'UserName': _usernameFilter.text,
        'Password': _passwordFilter.text,
        'zone': '0',
        'captcha': _captchaFilter.text
      });
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      Session.headers.remove('Host');
      Session.headers.remove('Origin');
      Session.headers.remove('Referer');
      response = await client.get(
        "https://grade-std.ku.ac.th/GSTU_course_.php",
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } finally {}
  }

  Future<void> _loginPressed() async {
    await login();
    await _saveValue();
    Navigator.pushNamed(context, '/info');
  }

  Widget _buildCaptchaField(node) {
    return new Container(
      child: new TextField(
          focusNode: captchaFocusNode,
          keyboardType: TextInputType.number,
          controller: _captchaFilter,
          decoration:
              new InputDecoration(labelText: 'Captcha', icon: Icon(Icons.lock)),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            node.unfocus();
            _loginPressed();
          },
          inputFormatters: [
            new FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          ]),
    );
  }
}
