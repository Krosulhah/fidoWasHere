import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class ReportInfo extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //todo prendi i dati dal db
    return MaterialApp(
        title: 'FidoWasHere',
        home: Scaffold(
            appBar: AppBar(
              title:Text('Report # id',textAlign: TextAlign.center,),
            ),
            body:Column(
              children: <Widget>[
                Container(
                    child:Body()
                ),
                Text('REPORTER INFO'),
                 ReportData()

              ],
            )

        )
    );
  }
}
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: InkWell(
            onTap: ()=>showDialog(context: context,
                child: Dialog(
                    child: InteractiveViewer(
                        panEnabled: false,
                        child: Image(image:AssetImage('assets/images/footprint.jpeg')))
                )),
            child:Container(

              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              width: 200.0,
              height:200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.black,
                  width: 10,
                ),
              ),
              child: Image(image:AssetImage('assets/images/footprint.jpeg')
              ),

            ) ));





  }

}
class ReportData extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  Expanded(child:ListView.separated(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {  //todo link con db

                  return ListTile(
                    title: Text('$index + DATA INFO PH', textAlign: TextAlign.center,),
                    onTap: ()=>print('ReportInfo()'),
                  );

                }, separatorBuilder: (BuildContext context, int index) {


                return SizedBox(
                  height: 10,
                );

              },



              )
    );

  }
}

