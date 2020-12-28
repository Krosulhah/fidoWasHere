import 'package:dimaWork/graphicPatterns/infoBuilder.dart';
import 'package:dimaWork/reportInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Model/fido.dart';
import 'graphicPatterns/TextPatterns.dart';
import 'graphicPatterns/colorManagement.dart';

class ReportSearch extends StatelessWidget {
  // This widget is the root of your application.
  final List<Fido> result;
  ReportSearch({Key key, this.result}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => Future(() => true),
        child: new Scaffold(
        resizeToAvoidBottomInset: false,
            appBar: AppBar(
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

            ),
            body: Container(
              color: ColorManagement.setBackGroundColor(),

              child: ListView.builder(
                itemCount: this.result.length,
                itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        child:Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        margin: EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: ColorManagement.setSeparatorColor(),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            CircleAvatar(
                                radius: min(MediaQuery.of(context).size.height * 0.07, MediaQuery.of(context).size.width * 0.07),
                                backgroundImage:MemoryImage(this.result[index].getPhoto())),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                color: ColorManagement.setSeparatorColor(),
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [buildNiceText(this.result[index].getDate().toString(), context)],
                                    ),
                                    InfoBuilder.addSpace(),
                                    Row(
                                      children: [buildNiceRedText(this.result[index].getFoundHere(), context)],
                                    ),
                                  ],
                        )
                            )
                          ]
                        )

                  ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportInfo(result: result[index]))));

                }
                )
            )
    ));



                }
}

double min(double a, double b ){
  if (a<b)
    return a;
  return b;
}

FittedBox setTitle(){
  return FittedBox(
      fit:BoxFit.fitWidth,
      child:Text(
        'REPORTED FIDOS',
        style:   TextStyle(
          color:ColorManagement.setTextColor(),
        ),
      )
  );
}

Container buildNiceText(String text,BuildContext context){
  return Container(
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width*0.7,
    child:Text(text,
    style: TextStyle(
    color:ColorManagement.setTextColor(),
    ),
    )
  );
}

Container buildNiceRedText(String text,BuildContext context) {
  return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width*0.7,
      child: Text(text,
        style: TextStyle(
          color: ColorManagement.setMarkerColor(),
        ),
      ));
}