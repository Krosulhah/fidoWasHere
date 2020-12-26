import 'package:dimaWork/Controllers/ReportController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'colorManagement.dart';

class InfoBuilder {
ReportController reportController;



static Container selectTypeInfo(BuildContext context,List<Color>_color,int element,String img){
  return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.40,
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorManagement.setBackGroundColor(),
        border: Border.all(
          color: _color[element],
          width: 10,
        ),
      ),
      child: FittedBox(
        child: SvgPicture.asset(img),
        fit: BoxFit.fill,
      ));


}

static Card buildCard(String text, var build,BuildContext context){
  return Card(
      elevation: 8.0,
      color: ColorManagement.setButtonColor(),
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child:Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              borderRadius:BorderRadius.all(Radius.circular(16.0)),
              color:ColorManagement.setSeparatorColor()),
          child:Column(mainAxisAlignment: MainAxisAlignment.center, children:
          [buildNiceText(text,context),
            addSpace(),
            build,
            addSpace()
          ]
          )
      )
  );
}


static Container buildNiceText(String text,BuildContext context){
  return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width*0.4,
      child: Text(text,
        style: TextStyle(
          color:ColorManagement.setTextColor(),
        ),
      ));
}


static Container addSpace(){
  return Container(
    height: 5.0,
    width: 2.0,
  );
}

static Container selectSexInfo(BuildContext context,List<Color>_colorSex,int element,String img){
  return Container(

    height: MediaQuery.of(context).size.height * 0.1,
    width: MediaQuery.of(context).size.width * 0.18,
    padding: EdgeInsets.all(20),
    margin: EdgeInsets.all(20),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: ColorManagement.setBackGroundColor(),
      border: Border.all(
        color: _colorSex[element],
        width: 5,
      ),
    ),
    child:
      FittedBox(
        child: Image(
          image: AssetImage(img),
          fit: BoxFit.fill,
        ))
  );
}

static Container boldNiceText(String text,BuildContext context){
  return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width*0.4,
      child:Text(text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color:ColorManagement.setTextColor(),
        ),
      ));
}




}
