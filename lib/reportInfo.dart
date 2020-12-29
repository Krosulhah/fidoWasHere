import 'package:dimaWork/Controllers/ReportController.dart';
import 'package:dimaWork/ThankyouScreen.dart';
import 'package:dimaWork/graphicPatterns/infoBuilder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Loading.dart';
import 'Model/fido.dart';
import 'graphicPatterns/colorManagement.dart';
import 'home.dart';

class ReportInfo extends StatelessWidget {
  final Fido result;
  ReportInfo({Key key, this.result}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => Future(() => true),
        child:new Scaffold(
      backgroundColor: ColorManagement.setBackGroundColor(),
        resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              title: setTitle('Report # ' + result.getId().toString()),
              backgroundColor: ColorManagement.setButtonColor(),
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
              ),
            body: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                    ),
                    child:Column(
                        children:[
                          InfoBuilder.addSpace(),
                          buildPhoto(context, result),
                          InfoBuilder.addSpace(),
                          addReporterCard(context)
                        ])),
                InfoBuilder.addSpace(),
                Container(
                  padding: EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  color: ColorManagement.setTextColor(),
                ),
                InfoBuilder.addSpace(),
                Expanded(child:buildData(context, result),)
              ],
            )));


  }

  Card addReporterCard(BuildContext context){
    return InfoBuilder.buildCard("Reporter:",InfoBuilder.buildNiceText(result.getReporter(), context),context);
  }



}

Column buildPhoto(BuildContext context,Fido result) {
   return Column(
        children: [InkWell(
            onTap: () => showDialog(
                context: context,
                child: Dialog(
                    child: InteractiveViewer(
                        panEnabled: false,
                        child: Image.memory(result.getPhoto())))),
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.3,
              child:Container(
                padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorManagement.setTextColor(),
                  width: 5,
                ),
              ),

              child: FittedBox(
                fit: BoxFit.fill,
                child:Image.memory(result.getPhoto())
              )
            )
            )

        ),

    ]);

  }


SingleChildScrollView buildData(BuildContext context, Fido result){
  ReportController controller=new ReportController();
    return  SingleChildScrollView(child:Column(
      children: [
        InfoBuilder.addSpace(),
        if (result.getName() != null && result.getName()!=" ")
          buildNameCard(context,result),
        InfoBuilder.addSpace(),
        buildBreedCard(context,result),
        InfoBuilder.addSpace(),
        buildCoatColorCard(context,result),
        InfoBuilder.addSpace(),
        buildGenderCard(context,result),
        InfoBuilder.addSpace(),
        buildDateCard(context,result),
        InfoBuilder.addSpace(),
        buildFoundHereCard(context,result),
        InfoBuilder.addSpace(),
        actualAddress(result,context),
        FutureBuilder<bool>(
            future: controller.canClose(result.getReporter()),
            builder: (context,  snapshot) {
              if (snapshot.hasData&&snapshot.data)
                return closeButtonBuild(context, controller,result);
              else
                return Text('');
    }

    )
      ],
    ));



  }

  Card buildNameCard(BuildContext context, Fido result){
    return InfoBuilder.buildCard("Name:",InfoBuilder.buildNiceText(result.getName(), context),context);}
  Card buildBreedCard(BuildContext context, Fido result){
    return InfoBuilder.buildCard("Breed:",InfoBuilder.buildNiceText(result.getBreed(), context),context);}
  Card buildCoatColorCard(BuildContext context, Fido result){
    return InfoBuilder.buildCard("Coat color:",InfoBuilder.buildNiceText(result.getColour(), context),context);}
  Card buildGenderCard(BuildContext context, Fido result){
    return InfoBuilder.buildCard("Gender:",InfoBuilder.buildNiceText(result.getSex(), context),context);}
  Card buildDateCard(BuildContext context, Fido result){
    return InfoBuilder.buildCard("Date:",InfoBuilder.buildNiceText(result.getDate().toString(), context),context);}
  Card buildFoundHereCard(BuildContext context, Fido result){
    return InfoBuilder.buildCard("Found here:",InfoBuilder.buildNiceText(result.getFoundHere(), context),context);}

RaisedButton closeButtonBuild(context,controller,result) {
      return RaisedButton(
          textColor: ColorManagement.setTextColor(),
          color: ColorManagement.setButtonColor(),
          onPressed: () {
            _handleClose(context,controller,result);
          }, shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
          child:Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.5,
              child:
              Align(
                  alignment: Alignment.center,
                  child: Text('Close Report' ,textAlign: TextAlign.center)
              )
          )
      );
  }



final GlobalKey<State> key= new GlobalKey<State>();
Future<void> _handleClose(BuildContext context, ReportController controller,Fido result)async{
  try {
    Dialogs.showLoadingDialog(context, key);//invoking login
    await controller.closeReport(result);
    Navigator.of(key.currentContext,rootNavigator: true).pop();//close the dialoge
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  ThankYou(result.getType()),
        ));
  } catch (error) {
    print(error);
  }
}


  Widget actualAddress(Fido result,BuildContext context) {
    if (result.getMoved()) {
      return InfoBuilder.boldNiceText("The reporter has not move the Fido",context);
    }
    return InfoBuilder.buildCard("Brought to: ",InfoBuilder.buildNiceText(result.broughtTo, context), context);
  }


FittedBox setTitle(String text){
  return FittedBox(
      fit:BoxFit.fitWidth,
      child:Text(
        text,
        style:   TextStyle(
          color:ColorManagement.setTextColor(),
        ),
      )
  );
}