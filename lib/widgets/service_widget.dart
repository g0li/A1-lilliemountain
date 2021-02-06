import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

//create switch case depending if from history or edetails for
class ServiceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, 'ceservice');
      },
      trailing: FaIcon(
        FontAwesomeIcons.ellipsisV,
        color: Colors.black,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Service Title',
              style: GoogleFonts.roboto().copyWith(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          Text('employee name',
              style: GoogleFonts.roboto().copyWith(
                  color: Color(0xFF5C5C5C),
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          Text('31/10/2021',
              style: GoogleFonts.roboto().copyWith(
                  color: Color(0xFF5C5C5C),
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
