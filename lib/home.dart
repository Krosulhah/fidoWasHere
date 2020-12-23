
import 'package:dimaWork/checkers/loginValidityChecker.dart';
import 'package:dimaWork/graphicPatterns/ImagePatterns.dart';
import 'package:dimaWork/myReport.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session/flutter_session.dart';

import 'Statistics.dart';
import 'package:flutter/material.dart';
import 'graphicPatterns/colorManagement.dart';
import 'reportPet.dart';
import 'lookForFido.dart';

class Home extends StatelessWidget {
  // ignore: slash_for_doc_comments, slash_for_doc_comments, slash_for_doc_comments
  /**-------------------------------------------------------------------------------------------------------//
* pagina per l'accesso alle funzionalita' dell'app
* azioni possibili:
*
*   -> indietro -> esce dall'applicazione
*   -> report -> reportPet

    -> look for fido -> lookForFido
    -> statistics -> Statistics
*-----------------------------------------------------------------------------------------------------------**/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Home'),
    );
  }
}

class HomePage extends StatefulWidget {

  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    /*** check if user has logged in*/
    LoginValidityChecker loginChecker=new LoginValidityChecker();
    loginChecker.isLoggedIn(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: ColorManagement.setButtonColor(),
        title: setTitle(),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              color: ColorManagement.setTextColor(),
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                SystemNavigator.pop();
              },
            );},
        ),
      ),
      body: Container(
        color: ColorManagement.setBackGroundColor(),
        alignment: Alignment.center,
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ImagePatterns.addSmallerImage(context),reportButton(), lookForFidoButton(),myReportButton(),
              statisticsButton(),
             ],
          ),
      ),
    );
  }



  RaisedButton lookForFidoButton() {
    return RaisedButton(
      textColor: ColorManagement.setTextColor(),
      color: ColorManagement.setButtonColor(),
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => new LookForFido(),
          )), shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child:Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.5,
            child:
            Align(
                alignment: Alignment.center,
                child: Text('Look For Fifo' ,textAlign: TextAlign.center)
            )
        )
    );
  }

  RaisedButton reportButton() {
    return RaisedButton(
      textColor: ColorManagement.setTextColor(),
      color: ColorManagement.setButtonColor(),
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => new ReportPet(),
          )), shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child:Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.5,
            child:
            Align(
                alignment: Alignment.center,
                child: Text('Report Fifo' ,textAlign: TextAlign.center)
            )
        )
    );
  }


  RaisedButton statisticsButton() {
    return RaisedButton(
      textColor: ColorManagement.setTextColor(),
      color: ColorManagement.setButtonColor(),
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => new Statistics(
              //replace by New Contact Screen
            ),
          )), shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child:Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.5,
            child:
            Align(
                alignment: Alignment.center,
                child: Text('Statistics' ,textAlign: TextAlign.center)
            )
        )
    );
  }

  myReportButton(){
    return RaisedButton(
        textColor: ColorManagement.setTextColor(),
        color: ColorManagement.setButtonColor(),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => new MyReport(),
            )), shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child:Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.5,
            child:
            Align(
                alignment: Alignment.center,
                child: Text('My Report' ,textAlign: TextAlign.center)
            )
        )
    );
  }

}

FittedBox setTitle(){
  return FittedBox(
      fit:BoxFit.fitWidth,
      child:Text(
        'FIDO WAS HERE',
        style:   TextStyle(
          color:ColorManagement.setTextColor(),
        ),
      )
  );
}