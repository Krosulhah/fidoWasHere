import 'package:dimaWork/Controllers/MailRegLoginController.dart';
import 'package:flutter/material.dart';

/*
* pagina per la registrazione di un'account
* azioni possibili:
*
*   -> indietro -> torna alla pagina di mail login
*   -> register -> user inserisce mail + psw  + rpsw -> formato mail controllato daq checker +controllo psw e rpsw uguali+ aggiunta sul db
*               -> aggiungi la mail alla sessione sotto il campo user e vai  a home page
* * */

class MailReg extends StatelessWidget {
  @override
  /**guarda mailLogin**/
  Widget build(BuildContext context) {
    return   RegPage();
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
  final TextEditingController _repeatPasswordFilter = new TextEditingController();
  String _email = "";
  String _password = "";
  String _repeatPassword = "";

  MailLoginController regController = new MailLoginController();

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
      title: new Text("REGISTRATION"),
      centerTitle: true,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          );},
      ),

    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(
                  labelText: 'Email'
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(
                  labelText: 'Password'
              ),
              obscureText: true,
            ),
          ),
          new Container(
            child: new TextField(
              controller: _repeatPasswordFilter,
              decoration: new InputDecoration(
                  labelText: 'Repeat Password'
              ),
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
              onPressed:
                  () async {
                String result=await regController.registerPressed(_email,_password,_repeatPassword,context); // runApp (MailReg());
                if (result!=null&&result.isNotEmpty)
                {
                  showDialog(
                      context: context,
                      child: new AlertDialog(
                        title: new Text(result),
                      ));
                }
              },
            ),

          ],
        ),
      );
    }


  }

  // These functions can self contain any user auth logic required, they all have access to _email and _password





//https://pub.dev/packages/postgres per info connessione