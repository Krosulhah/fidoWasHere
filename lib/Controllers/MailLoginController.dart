
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

import '../checker.dart';
import '../connectionHandler.dart';
import '../home.dart';

class MailLoginController{
  Checker checker = new Checker();
  ConnectionHandler connectionHandler = new ConnectionHandler();


  Future<String> logInPressed(BuildContext context,String _email, String _password) async {

    if (_email.isEmpty || _password.isEmpty) {
      return ('please fill all the required fields');
          }
    if (checker.emailValidity(_email) == false) {
      return ('wrong mail format');
    }
      var connection = connectionHandler.createConnection();
      await connection.open();
      List<List<dynamic>> results = await connection.query(
          "SELECT * FROM public.\"User\" WHERE  mail= @amail AND psw=@apsw",
          substitutionValues: {"amail": _email, "apsw": _password});
      connection.close();

      if (results.length == 0) {
        return ('no result');
      } else {
        var session = FlutterSession();
        await session.set("user", _email);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }

  }


}

