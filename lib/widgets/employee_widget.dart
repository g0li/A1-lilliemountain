import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeWidget extends StatefulWidget {
  final Function onTap;

  const EmployeeWidget({Key key, this.onTap}) : super(key: key);
  @override
  _EmployeeWidgetState createState() => _EmployeeWidgetState();
}

class _EmployeeWidgetState extends State<EmployeeWidget> {
  bool val = true;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      trailing: CupertinoSwitch(
          value: val,
          onChanged: (_) {
            setState(() {
              val = _;
            });
          }),
      leading: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              'https://via.placeholder.com/80.png',
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'employee name',
              style: GoogleFonts.roboto().copyWith(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'employee@company.org',
                style: GoogleFonts.roboto().copyWith(
                  fontSize: 12,
                  color: Colors.black,
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'joining date : 31/05/2021',
              style: GoogleFonts.roboto().copyWith(
                  fontSize: 12,
                  color: Color(0xFF5C5C5C),
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
