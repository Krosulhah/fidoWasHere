import 'package:dimaWork/Controllers/FBcontroller.dart';
import 'package:dimaWork/mailLogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
* pagina di accesso all'applicazione
* azioni possibili:
*
*   -> chiudere app -> press sulla freccia nell'appbar
*   -> accesso con mail -> porta alla pagina di login tramite mail
*   -> accesso con facebook -> richiede login tramite credenziali FB
* */
//TODO login with FB
//todo aggiungi widget con nome app

void main() {
  runApp(MyHomePage());
}




class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
        title: 'FidoWasHere',

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    home: new HomePage());}}

    class HomePage extends StatelessWidget{
      @override
      Widget build(BuildContext context) {
  return new Scaffold(
      appBar: AppBar(
        title: Text( 'FIDO WAS HERE'),
        leading: Builder(
        builder: (BuildContext context) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          //Navigator.pop(context);
          SystemNavigator.pop();
          },
      );},
        ),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.

      ),

        body:
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: new AssetImage('assets/images/footprint.jpeg'), fit: BoxFit.cover)),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.
            spaceEvenly,
            children: <Widget>[
              Text('FidoWasHere',),  //todo aggiungi widget con nome app


              Row( //buttons row
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [mailButton(context),fbButton(context)],


              ),
            ],
          ),
        )
    );

  }
}

  RaisedButton mailButton (BuildContext context){
    return RaisedButton(
      textColor: Colors.white,
      color: Color(0xFF6200EE),
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(builder:
              (BuildContext context) => new MailLogIn()));

        },
      child: Text('Access with mail'),


    );
  }

  RaisedButton fbButton (BuildContext context) {
    FBcontroller fbcontroller = new FBcontroller();
    return RaisedButton(
      textColor: Colors.white,
      color: Color(0xFF6200EE),
      onPressed: () async {
        String result = await fbcontroller.fbLogIn(context);
        if(result!=null&&result.isNotEmpty)
          {
            showDialog(
                context: context,
                child: new AlertDialog(
                  title: new Text(result),
                ));
          }
      },
      child: Text('Access with FB'),
    );



  }

