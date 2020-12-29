import 'package:dimaWork/Controllers/MailRegLoginController.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'Loading.dart';
import 'package:dimaWork/connectionHandler.dart';
import 'graphicPatterns/colorManagement.dart';
import 'home.dart';
import 'package:dimaWork/graphicPatterns/TextPatterns.dart';
// ignore: slash_for_doc_comments
/**--------------------------------------------------------------------------------------------------------------//
* pagina per la registrazione di un'account
* azioni possibili:
*   -> indietro -> torna alla pagina di mail login
*   -> register -> user inserisce mail + psw  + rpsw -> controllo -> aggiunta sul db
*               -> vai  a home page
*-------------------------------------------------------------------------------------------------------------**/

class MailReg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return   RegPage();
  }
}


class RegPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RegPageState();
}


class _RegPageState extends State<RegPage> {

  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  final TextEditingController _repeatPasswordFilter = new TextEditingController();
  String _email = "";
  String _password = "";
  String _repeatPassword = "";
  bool conn;
  var subscription;

  MailLoginController regController = new MailLoginController();

  _RegPageState()  {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
    _repeatPasswordFilter.addListener(_repeatPasswordListen);
    conn=check();
  }
  check(){
    bool c= ConnectionHandler().isConnected(Connectivity().checkConnectivity());
    return c;

  }


  @override
  initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(()  {
        conn= ConnectionHandler().isConnected(result);
      });
    }
    );
  }

// Be sure to cancel subscription after you are done
  @override
  dispose() {
    super.dispose();

    subscription.cancel();
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


  final GlobalKey<State> key = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => Future(() => true),
        child:new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildBar(context),
      body: Container(
        alignment: Alignment.center,
        color: ColorManagement.setBackGroundColor(),
        padding: EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),

          ],
        ),
      ),
    ));
  }


  Widget _buildBar(BuildContext context) {
    return new AppBar(
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

    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _emailFilter,
              cursorColor: ColorManagement.setTextColor(),
              decoration: new InputDecoration(
                  labelText: 'Email'
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              cursorColor: ColorManagement.setTextColor(),
              decoration: new InputDecoration(
                  labelText: 'Password'
              ),
              obscureText: true,
            ),
          ),
          new Container(
            child: new TextField(
              controller: _repeatPasswordFilter,
              cursorColor: ColorManagement.setTextColor(),
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


  RaisedButton _buildButtons() {
    return RaisedButton(
        textColor: ColorManagement.setTextColor(),
        color: ColorManagement.setButtonColor(),
        onPressed:
            () {
          _handleReg();
        }
        ,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.05,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Sign Up'),
              ],
            ))
    );
  }

  Future<void>  _handleReg() async {
    if (conn) {
      try {
        Dialogs.showLoadingDialog(context, key);
        String result = await regController.registerPressed(
            _email, _password, _repeatPassword, context); // runApp (MailReg());

        Navigator.of(context, rootNavigator: true)
            .pop(); //close the dialoge
        if (result != null && result.isNotEmpty) {

         TextPatterns.showAlert(result, context);
        }
        else
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
      } catch (error) {
        print(error);
      }
    }else TextPatterns.showInternetAlert(context);

  }

  FittedBox setTitle() {
    return FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          'REGISTRATION',
          style: TextStyle(
            color: ColorManagement.setTextColor(),
          ),
        )
    );
  }
}