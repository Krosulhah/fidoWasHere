import 'package:dimaWork/connectionHandler.dart';
import 'package:dimaWork/home.dart';
import 'package:dimaWork/mailReg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

import 'checker.dart';
import 'error.dart';


/*
* pagina di accesso all'account
* azioni possibili:
*
*   -> indietro -> torna alla pagina di accesso dell'applicazione
*   -> login -> user inserisce mail + psw  -> formato mail controllato daq checker + controllo sul db
*            -> home page
*   -> register with email -> carica la pagina per la registrazione
* * */
class MailLogIn extends StatelessWidget {
  // This widget is the root of your application.
  /***
   * ATTENZIONE non ritornare material app da nessuna parte (oltre che nel main) -> crea un nuovo navigator!
   * scaffold sempre top !
   *
   *
   * per ora login solo con luke@gmail.com luke
   ***/
  @override
  Widget build(BuildContext context) {
    return MailLogInPage(title: 'LOGIN');
  }
}

class MailLogInPage extends StatefulWidget {
  MailLogInPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MailLogInPageState createState() => _MailLogInPageState();
}

class _MailLogInPageState extends State<MailLogInPage> {
  Checker checker = new Checker();
  ConnectionHandler connectionHandler= new ConnectionHandler();
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
        title: Text('LOGIN'),

        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            );},
        ),
        
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),

        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /* Text(
              'Email:',
            ),
            
            Text(
              'Password',
            ), */
            _buildTextFields(),
            mailLogButton(context),
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

  RaisedButton mailLogButton(BuildContext context) {
    return RaisedButton(
      textColor: Colors.white,
      color: Color(0xFF6200EE),
      onPressed: () {
        _logInPressed(context);
      },
      child: Text('Log In'),
    );
  }

  Future<void> _logInPressed(BuildContext context) async {
    print(
        'The user wants enter to his existing account with $_email and $_password');
    if (_email.isEmpty || _password.isEmpty) {
      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('please fill all the required fields'),
          ));
    }else if(checker.emailValidity(_email)==false){
      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('wrong mail format'),
          ));
    }
    else { //todo connection
      var connection = connectionHandler.createConnection();
      await connection.open();
      List<List<dynamic>> results = await connection.query("SELECT * FROM public.\"User\" WHERE  mail= @amail AND psw=@apsw", substitutionValues: {
        "amail" : _email,"apsw" :_password
      });
      connection.close();



      if (results.length == 0) {
        runApp(Error());
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

  RaisedButton registerButton (BuildContext context){
    return RaisedButton(
      textColor: Colors.white,
      color: Color(0xFF6200EE),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MailReg()),
        );
      },
      child: Text('Register with mail'),


    );
  }
}
