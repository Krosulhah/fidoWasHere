import 'package:dimaWork/reportInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class ReportSearch extends StatelessWidget {
  // This widget is the root of your application.
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
                  itemCount: 30,
                  itemBuilder: (BuildContext context, int index) {  //todo link con db

                  return ListTile(
                    trailing: Icon(Icons.keyboard_arrow_right),
                    title: Text('$index + date', textAlign: TextAlign.center,),
                    onTap: ()=>runApp(ReportInfo()),
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



