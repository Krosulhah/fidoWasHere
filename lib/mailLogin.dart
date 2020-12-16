import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

import 'Statistics.dart';

class MailReg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'FidoWasHere',
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new RegPage(),
    );
  }
}

class RegPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RegPageState();
}

// Used for controlling whether the user is loggin or creating an account

class _RegPageState extends State<RegPage> {
  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  final TextEditingController _repeatPasswordFilter =
      new TextEditingController();
  String _email = "";
  String _password = "";
  String _repeatPassword = "";

  _RegPageState() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
    _repeatPasswordFilter.addListener(_repeatPasswordListen);
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  void _repeatPasswordListen() {
    if (_repeatPasswordFilter.text.isEmpty) {
      _repeatPassword = "";
    } else {
      _repeatPassword = _repeatPasswordFilter.text;
    }
  }

  // Swap in between our two forms, registering and logging in

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
      title: new Text("FidoWasHere"),
      centerTitle: true,
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(labelText: 'Email'),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ),
          new Container(
            child: new TextField(
              controller: _repeatPasswordFilter,
              decoration: new InputDecoration(labelText: 'Repeat Password'),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new RaisedButton(
            child: new Text('Register'),
            onPressed: _registerPressed,
          ),
        ],
      ),
    );
  }

  Future<void> _registerPressed() async {
    print('The user wants to create an account with $_email and $_password');
    if (_email.isEmpty || _password.isEmpty || _repeatPassword.isEmpty) {
      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('please fill all the required fields'),
          ));
    } else if (_repeatPassword != _password) {
      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text(
                'the fields repeat password and password must be equal'),
          ));
    } else {
      var connection =
          PostgreSQLConnection(
              "ec2-52-31-233-101.eu-west-1.compute.amazonaws.com",
              5432,
              "d546e3qrqkclh8",
              username: "talusgwyiskbzs",
              password:
                  "12b36d512f0f4a6f25f266b6d30bc19851f00e50c76d03f3d1fc5f1d3f1d0530",
              timeoutInSeconds: 30,
              queryTimeoutInSeconds: 30,
              timeZone: 'UTC',
              useSSL: true);
      await connection.open();

      //await connection.query("insert into user (idUser,mail,psw,fbAccount) values (@id, @email, @psw, @fb)", substitutionValues: {"id" : 1, "mail" : _email, "psw": _password, "fb" : ""});

      await connection.query("select * from user");
      connection.close();
      runApp(Statistics());
    }
  }
}

// These functions can self contain any user auth logic required, they all have access to _email and _password

//https://pub.dev/packages/postgres per info connessione
