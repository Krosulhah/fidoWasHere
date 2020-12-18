import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_session/flutter_session.dart';

import '../home.dart';

class FBcontroller{

  final facebookLogin = FacebookLogin();
  Map userProfile;

 Future <String> fbLogIn(BuildContext context) async {
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get("https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token");
        final profile = jsonDecode(graphResponse.body);
        if(profile!=null){

          userProfile = profile;
          var session = FlutterSession();
          await session.set("user",userProfile['email']);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );

        }break;



      case FacebookLoginStatus.cancelledByUser:
        return 'azione cancellata';

      case FacebookLoginStatus.error:
        return 'impossibile effettuare il login tramite FB';
    }
  }


}