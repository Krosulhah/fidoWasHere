import 'package:dimaWork/Controllers/FBcontroller.dart';
import 'package:dimaWork/graphicPatterns/ImagePatterns.dart';
import 'package:dimaWork/graphicPatterns/TextPatterns.dart';
import 'package:dimaWork/graphicPatterns/colorManagement.dart';
import 'package:dimaWork/mailLogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

// ignore: slash_for_doc_comments
/**--------------------------------------------------------------------------------//
* pagina di accesso all'applicazione
* azioni possibili:
*
*   -> chiudere app -> press sulla freccia nell'appbar
*   -> accesso con mail -> porta alla pagina di login tramite mail
*   -> accesso con facebook -> richiede login tramite credenziali FB
 * ------------------------------------------------------------------------------**/



void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'FidoWasHere',
    home: new MyApp());}
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 3,
        navigateAfterSeconds: new HomePage(),
        title:Text(
          'Fido Was Here',
          style:   TextStyle(
            color:ColorManagement.setTextColor(),
            fontFamily: 'DancingScript',
            fontSize: MediaQuery.of(context).size.width*0.09
          ),),
        backgroundColor: ColorManagement.setBackGroundColor(),
        loaderColor: ColorManagement.setSeparatorColor()
    );
  }
}


    class HomePage extends StatelessWidget{
      @override
      Widget build(BuildContext context) {
        return new Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              title: TextPatterns.setAppBarText(),
              backgroundColor: ColorManagement.setButtonColor(),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    color: ColorManagement.setTextColor(),
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () {
                      SystemNavigator.pop();
                      },
                  );
                  },
              ),
            ),
            backgroundColor: ColorManagement.setBackGroundColor(),
            body:
            Container(
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                buildNiceText(),
                  ImagePatterns.addImage(context),
                  Row( //buttons row
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                          children: <Widget>[
                            mailButton(context),
                            fbButton(context)]),
                    ]
              ),
            ],
          ),
        )
    );
  }
}




  FittedBox buildNiceText(){
    return FittedBox(
      fit:BoxFit.fitWidth,
      alignment: Alignment.center,
      child: Text(
        'Fido Was Here',
        style: TextStyle(
          fontFamily: 'DancingScript',
          fontSize: 40,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = Colors.black,
        ),
      )
  );
}


  RaisedButton mailButton (BuildContext context){
    return RaisedButton(
      textColor: ColorManagement.setTextColor(),
      color: ColorManagement.setButtonColor(),
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(builder:
              (BuildContext context) => new MailLogIn()));
          },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child:Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.5,
          child:
          Align(
              alignment: Alignment.center,
              child: Text('Access with mail' ,textAlign: TextAlign.center)
          )

        )
      );
  }

  RaisedButton fbButton (BuildContext context) {
    FBcontroller fbcontroller = new FBcontroller();
    return RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        textColor: ColorManagement.setTextColor(),
        color: Colors.blue,
        onPressed: () async {
          String result = await fbcontroller.fbLogIn(context);
          if(result!=null&&result.isNotEmpty) {
            showDialog(
                context: context,
                child: new AlertDialog(
                  title: new Text(result),
                )
            );
          }
      },
        child: Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    alignment:Alignment.centerLeft,
                    child:FaIcon(FontAwesomeIcons.facebook)),
                Container(
                    alignment:Alignment.centerLeft,
                    child:Text('Facebook login')
                ),
              ],
        )
    ));


  }



