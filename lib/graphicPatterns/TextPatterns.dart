import 'package:dimaWork/graphicPatterns/colorManagement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextPatterns{

  static FittedBox setAppBarText(){
    return FittedBox(
        fit:BoxFit.fitWidth,
        child:Text(
          'Fido Was Here',
          style:   TextStyle(
            color:ColorManagement.setTextColor(),
            fontFamily: 'DancingScript',
      ),
    ));

  }



}