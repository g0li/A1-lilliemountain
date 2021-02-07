import 'package:flutter/material.dart';

class CommonServices {
  // Common date picker function which returns date
  Future<DateTime> pickDate({
    @required BuildContext context,
    bool restrictFutureDate = false,
    String labelText = 'Select Date',
  }) {
    int currentYear = DateTime.now().year;
    DateTime firstDate = DateTime(currentYear - 1);
    DateTime lastDate = DateTime.now();

    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
      fieldHintText: labelText,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColor,
            accentColor: Color(0xff588B8B),
            colorScheme: ColorScheme.light(
              primary: Color(0xff588B8B),
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child,
        );
      },
    ).then((DateTime selectedDate) {
      return selectedDate;
    }).catchError((err) {
      print('Error in date picker, ${err.toString()}');
      return null;
    });
  }
}
