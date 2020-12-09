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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FIDO WAS HERE',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MailLogIn()),
        );
      },
      child: Text('Access with mail'),


    );
  }

  RaisedButton fbButton (BuildContext context) {
    return RaisedButton(
      textColor: Colors.white,
      color: Color(0xFF6200EE),
      onPressed: () {
      //TODO login with FB
      },
      child: Text('Access with FB'),
    );

  }

