import 'package:dimaWork/reportSearch.dart';
import 'package:flutter/material.dart';

import 'MailReg.dart';

class LoginReg extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FidoWasHere',
        home: Scaffold(
            appBar: AppBar(
              title:Text('FidoWasHere'),
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

                    children: [mailButton(),fbButton()],


                  ),
                ],
              ),
            )
        ));
  }
}

RaisedButton mailButton (){
    return RaisedButton(
      textColor: Colors.white,
      color: Color(0xFF6200EE),
      onPressed: () {
        runApp (MailReg());
      },
      child: Text('Access with mail'),


    );
  }


RaisedButton fbButton () {
    return RaisedButton(
      textColor: Colors.white,
      color: Color(0xFF6200EE),
      onPressed: () {
        runApp(ReportSearch());
      },
      child: Text('Access with FB'),
    );

}