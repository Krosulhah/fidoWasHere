
import 'package:dimaWork/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

class LoginValidityChecker{

  void isLoggedIn(BuildContext context) async{
    var session = FlutterSession();
    String user = await session.get("user");
    if(user==null||user.isEmpty)
      {
        //l'utente non è loggato lo portiamo alla pagina di errore
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Error()),
        );
      }
  }
}