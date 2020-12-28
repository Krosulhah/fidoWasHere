import 'package:dimaWork/Controllers/ReportController.dart';
import 'package:dimaWork/graphicPatterns/ImagePatterns.dart';
import 'package:dimaWork/reportSearch.dart';
import 'package:flutter/services.dart';
import 'Loading.dart';
import 'Model/fido.dart';
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
    return HomePage(title: 'Home');

  }
}

class HomePage extends StatefulWidget {

  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<State> key= new GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    ReportController reportController=new ReportController();
    return new WillPopScope(
        onWillPop: () async => Future(() => true),
        child: new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: ColorManagement.setButtonColor(),
        title: setTitle(),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              color: ColorManagement.setTextColor(),
              icon: const Icon(Icons.close),
              onPressed: () {
                SystemNavigator.pop();
              },
            );},
        ),
      ),
      body:   Container(
        color: ColorManagement.setBackGroundColor(),
        alignment: Alignment.center,
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [


              ImagePatterns.addSmallerImage(context),reportButton(), lookForFidoButton(),myReportButton(reportController),
              statisticsButton(),
             ],
          ),
      ),
    ));
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
                child: Text('Look For Fido' ,textAlign: TextAlign.center)
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
                child: Text('Report Fido' ,textAlign: TextAlign.center)
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
            builder: (_) => new Statistics(),
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


  myReportButton(ReportController reportController){
    return RaisedButton(
        textColor: ColorManagement.setTextColor(),
        color: ColorManagement.setButtonColor(),
        onPressed: ()  {_handleRetrieveMyReports(reportController);
        },shape: RoundedRectangleBorder(
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

  Future<void> _handleRetrieveMyReports(ReportController reportController) async {
    try {

      Dialogs.showLoadingDialog(context, key);//invoking login
      var res = await reportController.retrieveMyReports();
      Navigator.of(key.currentContext,rootNavigator: true).pop();//close the dialoge
      if (res != null && res is List<Fido> && res.isNotEmpty)
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => new ReportSearch(result: res),
            ));
    } catch (error) {
      print(error);
    }
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