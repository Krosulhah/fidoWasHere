import 'package:dimaWork/connectionHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'checker.dart';
import 'home.dart';



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
  Checker checker = new Checker();
  ConnectionHandler connectionHandler= new ConnectionHandler();
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
              onPressed: _registerPressed,
            ),

          ],
        ),
      );
    }




  Future<void> _registerPressed () async {
   print('The user wants to create an accoutn with $_email and $_password');
    if(_email.isEmpty||_password.isEmpty||_repeatPassword.isEmpty){

      showDialog(context: context,
          child: new AlertDialog(
            title: new Text('please fill all the required fields'),
          ));
    }else if(checker.emailValidity(_email)==false){
      showDialog(context: context,
          child: new AlertDialog(
            title: new Text('WRONG MAIL FORMAT'),
          ));
    }
    else if(_repeatPassword!=_password){
      showDialog(context: context,
          child: new AlertDialog(
            title: new Text('the fields repeat password and password must be equal'),
          ));

    }
    else{
      var connection = connectionHandler.createConnection();
      await connection.open();

      //await connection.query("insert into user (idUser,mail,psw,fbAccount) values (@id, @email, @psw, @fb)", substitutionValues: {"id" : 1, "mail" : _email, "psw": _password, "fb" : ""});

      List<List<dynamic>> results = await connection.query("SELECT * FROM public.\"User\" WHERE  mail= @amail ", substitutionValues: {
        "amail" : _email
      });
      if(results.isEmpty)
        {
          await connection.query("INSERT INTO public.\"User\" (mail,psw) VALUES (@amail,@apsw)", substitutionValues: {
            "amail" : _email,"apsw":_password
          });

          var session = FlutterSession();
          await session.set("user", _email);

        }
      else{
      connection.close();
 showDialog(context: context,
          child: new AlertDialog(
            title: new Text('mail is already used'),
          ));}
      connection.close();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );

    }



  }
  }

  // These functions can self contain any user auth logic required, they all have access to _email and _password





//https://pub.dev/packages/postgres per info connessione