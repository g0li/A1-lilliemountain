import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skimscope/model/services_model.dart';
import 'package:skimscope/model/user_model.dart';
import 'package:skimscope/services/auth_service.dart';

//create switch case depending if from history or edetails for
class ServiceWidget extends StatelessWidget {
  ServicesModel servicesModel;
  ServiceWidget(this.servicesModel);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, 'ceservice', arguments: servicesModel);
      },
      trailing: FaIcon(
        FontAwesomeIcons.ellipsisV,
        color: Colors.black,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(servicesModel.title,
              style: GoogleFonts.roboto().copyWith(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          StreamBuilder<UserModel>(
              stream: AuthService().getUser(servicesModel.createdBy),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('NA');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return LinearProgressIndicator();
                  default:
                    return Text(snapshot.data.name,
                        style: GoogleFonts.roboto().copyWith(
                            color: Color(0xFF5C5C5C),
                            fontSize: 12,
                            fontWeight: FontWeight.w500));
                }
              }),
          Text(servicesModel.whenCreated.toDate().toString().split(' ')[0],
              style: GoogleFonts.roboto().copyWith(
                  color: Color(0xFF5C5C5C),
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
