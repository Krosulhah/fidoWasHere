import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DateContoller {
  bool selectDate(
      BuildContext context, DateTime selectedDate, DateTime picked) {
    if (picked.isAfter(DateTime.now())) {
      Fluttertoast.showToast(
          msg: "Cannot put a date that hasn't yet occoured!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          fontSize: 16.0,
          textColor: Colors.red,
          backgroundColor: Colors.white);

      return false;
    } else {
      return true;
    }
  }
}
