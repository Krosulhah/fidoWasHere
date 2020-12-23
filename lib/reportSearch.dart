import 'package:dimaWork/reportInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Model/fido.dart';

class ReportSearch extends StatelessWidget {
  // This widget is the root of your application.
  final List<Fido> result;
  ReportSearch({Key key, this.result}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FidoWasHere',
        home: Scaffold(
            appBar: AppBar(
              title: Text(
                'Reported Fidos',
                textAlign: TextAlign.center,
              ),
            ),
            body: Container(
              child: ListView.builder(
                itemCount: this.result.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => runApp(ReportInfo(result: result[index])),
                    child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
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
                                radius: 35.0,
                                backgroundImage:
                                    MemoryImage(this.result[index].getPhoto())),
                            SizedBox(width: 15.0),
                            Expanded(
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 5.0),
                                  Text(
                                    this.result[index].getDate().toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Container(
                                    child: Text(
                                      this.result[index].getFoundHere(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  );
                },
              ),
            )));
  }
}
