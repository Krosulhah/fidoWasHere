import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:splashscreen/splashscreen.dart';

import 'graphicPatterns/colorManagement.dart';
import 'home.dart';

class ThankYou extends StatelessWidget {

  ThankYou(this.res) ;
  final String res;
  @override
  Widget build(BuildContext context) {
    print(res);
    return MyThankYou(res:res);}
}
class MyThankYou extends StatefulWidget {
  final String res;
  MyThankYou({Key key, this.res}) : super(key: key);
  @override
  _MyThankYouState createState() => new _MyThankYouState();
}

class _MyThankYouState extends State<MyThankYou> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 4,
      navigateAfterSeconds:  new HomePage(),
      imageBackground: setImage(widget.res),
      backgroundColor: ColorManagement.setBackGroundColor(),
      loaderColor: ColorManagement.setSeparatorColor(),
      loadingText: Text(
        'THANK YOU',textAlign: TextAlign.center,
        style: TextStyle(
          color: ColorManagement.setTextColor()
        ),
      ),

    );
  }


 AssetImage setImage(String res){
    print(res);
    if (res=="dog")
      return (AssetImage("assets/images/dogt.jpg"));
    return (AssetImage("assets/images/catt.jpg"));
  }
}