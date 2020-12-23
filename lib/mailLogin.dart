
import 'package:dimaWork/mailReg.dart';
import 'package:flutter/material.dart';
import 'Controllers/MailRegLoginController.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'graphicPatterns/colorManagement.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: new Container(
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
        ],
      ),
    );
  }

  RaisedButton _mailLogButton(BuildContext context) {
    return RaisedButton(
        textColor: ColorManagement.setTextColor(),
        color: Colors.redAccent,
        onPressed: () async {
          String result=await loginController.logInPressed(context,_email,_password);
          if (result!=null&&result.isNotEmpty)
            {
              showDialog(
                  context: context,
                  child: new AlertDialog(
                    title: new Text(result),
                  ));
            }
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
              children: [
                Text('Sign Up'),
              ],
            ))
    );
  }
}

FittedBox setTitle(){
  return FittedBox(
      fit:BoxFit.fitWidth,
      child:Text(
        'Fido Was Here',
        style:   TextStyle(
          color:ColorManagement.setTextColor(),
        ),
      )
  );
}
