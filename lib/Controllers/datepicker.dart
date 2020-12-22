import 'package:dimaWork/Controllers/DateController.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {
  static const _YEAR = 365;
  DatePicker({Key key, this.selectedDate, this.onChanged, this.dateContoller})
      : super(key: key);
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;

  DateContoller dateContoller;

  Future<Null> isCorrectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    await Future.delayed(Duration(milliseconds: 100));
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: _YEAR * 10)),
      lastDate: DateTime.now().add(Duration(days: _YEAR * 10)),
    );
    if (picked != null && picked != selectedDate) {
      if (dateContoller.selectDate(context, selectedDate, picked)) {
        onChanged(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
      Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.7,
          child: InkWell(
              onTap: () => isCorrectDate(context),
              child: InputDecorator(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              DateFormat.yMMMMEEEEd().format(selectedDate),
                              style: Theme.of(context).textTheme.body1,
                            )),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Icon(Icons.today),
                        )
                      ]))))
    ]);
  }
}
