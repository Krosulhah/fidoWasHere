import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Model/fido.dart';

class ReportInfo extends StatelessWidget {
  final Fido result;
  ReportInfo({Key key, this.result}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //todo prendi i dati dal db
    return MaterialApp(
        title: 'FidoWasHere',
        home: Scaffold(
            appBar: AppBar(
              title: Text(
                'Report # ' + result.getId().toString(),
                textAlign: TextAlign.center,
              ),
            ),
            body: Column(
              children: <Widget>[
                Container(child: Body(result: result)),
                Text('REPORTER :' + result.getReporter()),
                ReportData(result: result)
              ],
            )));
  }
}

class Body extends StatelessWidget {
  final Fido result;
  Body({Key key, this.result}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
        child: InkWell(
            onTap: () => showDialog(
                context: context,
                child: Dialog(
                    child: InteractiveViewer(
                        panEnabled: false,
                        child: Image.memory(result.getPhoto())))),
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(15),
              width: 200.0,
              height: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.black,
                  width: 10,
                ),
              ),
              child: Image.memory(result.getPhoto()),
            )));
  }
}

class ReportData extends StatelessWidget {
  final Fido result;
  ReportData({Key key, this.result}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        if (result.getName() != null && result.getName().isNotEmpty)
          Row(
            children: [
              Text(
                'Name:  ' + result.getName(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        Row(
          children: [
            Text(
              'Breed:  ' + result.getBreed(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Coat color:  ' + result.getColour(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Sex:  ' + result.getSex(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Found on:  ' + result.getDate().toString(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Found here:  ' + result.getFoundHere(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actualAddress(result)
      ],
    ));
  }

  actualAddress(Fido result) {
    if (result.broughtHome) {
      return Row(
        children: [
          Text(
            'The reporter has brought the Fido\'s at their home',
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
    return Row(
      children: [
        Text(
          'Brought To:  ' + result.getBroughtTo(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
