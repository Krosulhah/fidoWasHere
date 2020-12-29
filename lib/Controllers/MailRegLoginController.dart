
import 'package:dimaWork/checkers/checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';


import '../connectionHandler.dart';
import '../home.dart';



class MailLoginController {
  Checker checker = new Checker();
  ConnectionHandler connectionHandler = new ConnectionHandler();

  Future<String> logInPressed(BuildContext context, String _email,
      String _password) async {
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

      return "";
    }
  }

  Future<String> registerPressed(String _email, String _password,
      String _repeatPassword, BuildContext context) async {
    if (_email.isEmpty || _password.isEmpty || _repeatPassword.isEmpty) {
      return ('please fill all the required fields');
    } else if (checker.emailValidity(_email) == false) {
      return ('WRONG MAIL FORMAT');
    }
    else if (_repeatPassword != _password) {
      return ('the fields repeat password and password must be equal');
    }

    else {
      var connection = connectionHandler.createConnection();
      await connection.open();


      List<List<dynamic>> results = await connection.query(
          "SELECT * FROM public.\"User\" WHERE  mail= @amail ",
          substitutionValues: {
            "amail": _email
          });
      if (results.isEmpty) {
        await connection.query(
            "INSERT INTO public.\"User\" (mail,psw) VALUES (@amail,@apsw)",
            substitutionValues: {
              "amail": _email, "apsw": _password
            });

        var session = FlutterSession();
        await session.set("user", _email);
      }
      else {
        connection.close();
        return ('mail is already used');
      }
      connection.close();
      return "";
    }
  }


}
