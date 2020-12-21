import 'package:dimaWork/reportInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Model/fido.dart';



class ReportSearch extends StatelessWidget {
  // This widget is the root of your application.
  final List<Fido>result;
  ReportSearch({Key key,this.result}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FidoWasHere',
        home: Scaffold(
            appBar: AppBar(
              title:Text('Reported Fidos',textAlign: TextAlign.center,),
            ),
            body:
            Container(
              child:
              ListView.separated(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: this.result.length,
                  itemBuilder: (BuildContext context, int index) {  //todo link con db

                  return ListTile(
                    trailing: Icon(Icons.keyboard_arrow_right),
                    title: Text(this.result[index].getId().toString() +" - "+this.result[index].getDate().toString(), textAlign: TextAlign.center,),
                    onTap: ()=>runApp(ReportInfo(result:result[index])),
                  );

                }, separatorBuilder: (BuildContext context, int index) {


                 return SizedBox(
                height: 10,
                );

              },



                ),

              )

            )
        );
  }
}



