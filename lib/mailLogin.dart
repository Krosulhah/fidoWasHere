


import 'package:dimaWork/graphicPatterns/TextPatterns.dart';
import 'package:dimaWork/mailReg.dart';
import 'package:flutter/material.dart';
import 'Controllers/MailRegLoginController.dart';
import 'package:dimaWork/connectionHandler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Loading.dart';
import 'graphicPatterns/colorManagement.dart';
import 'home.dart';

// ignore: slash_for_doc_comments
/**--------------------------------------------------------------------------------------------------------//
* pagina di accesso all'account
* azioni possibili:
*
*   -> indietro -> torna alla pagina di accesso dell'applicazione
*   -> login -> user inserisce mail + psw  -> controllo formato mail e inserimento campi + db -> home page
*   -> register with email -> carica la pagina per la registrazione
* --------------------------------------------------------------------------------------------------------**/
class MailLogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MailLogInPage(title: 'LOGIN');
  }
}

class MailLogInPage extends StatefulWidget {
  MailLogInPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MailLogInPageState createState() => _MailLogInPageState();
}

class _MailLogInPageState extends State<MailLogInPage> {

  MailLoginController loginController = new MailLoginController();
  bool isLoggedIn = false;
  String username;
  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  String _email = "";
  String _password = "";


  _MailLogInPageState() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);

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
  final GlobalKey<State> key= new GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => Future(() => true),
        child:Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: ColorManagement.setButtonColor(),
        centerTitle: true,
        title: setTitle(),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              color: ColorManagement.setTextColor(),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body:   Container(
        alignment: Alignment.center,
        color: ColorManagement.setBackGroundColor(),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTextFields(),
            _mailLogButton(context),
            registerButton(context),

          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              cursorColor: ColorManagement.setTextColor(),
              controller: _emailFilter,
              decoration: new InputDecoration(labelText: 'Email'),
            ),
          ),
          new Container(
            child: new TextField(
              cursorColor: ColorManagement.setTextColor(),
              controller: _passwordFilter,
              decoration: new InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ),
        ],
      ),
    );
  }

  RaisedButton _mailLogButton(BuildContext context) {
    return RaisedButton(
        textColor: ColorManagement.setTextColor(),
        color: Colors.redAccent,
        onPressed: () {_handleSubmit(context);
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    alignment:Alignment.centerLeft,
                    child:FaIcon(FontAwesomeIcons.envelope)
                ),
                Container(
                    alignment:Alignment.centerLeft,
                    child:Text('Sign In')
                ),
              ],
            )));
  }

  RaisedButton registerButton(BuildContext context) {
    return RaisedButton(
      textColor: ColorManagement.setTextColor(),
      color: ColorManagement.setButtonColor(),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MailReg()),
        );
      },shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Sign Up'),
              ],
            ))
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {



    try {

      Dialogs.showLoadingDialog(context, key);//invoking login
      String result=await loginController.logInPressed(context,_email,_password);
      Navigator.of(context,rootNavigator: true).pop();//close the dialoge
      if (result!=null&&result.isNotEmpty)
      {
        TextPatterns.showAlert(result, context);
      }else
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (error) {
      print(error);
    }
  }


}





FittedBox setTitle(){
  return FittedBox(
      fit:BoxFit.fitWidth,
      child:Text(
        'LOGIN',
        style:   TextStyle(
          color:ColorManagement.setTextColor(),
        ),
      )
  );
}

