import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class ImagePatterns{

 static Container addImage(BuildContext context){
    return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.90,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(0),
        child: FittedBox(
          alignment: Alignment.center,
          child:  SvgPicture.asset('assets/images/logo.svg'),
          fit: BoxFit.fill,
        ));
  }

 static Container addSmallerImage (BuildContext context){
   return Container(
       height: MediaQuery.of(context).size.height * 0.3,
       width: MediaQuery.of(context).size.width * 0.5,
       child:addImage(context),
   );
 }
}