import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:skimscope/model/services_model.dart';
import 'package:skimscope/model/user_model.dart';
import 'package:skimscope/services/auth_service.dart';
import 'package:skimscope/services/maintenance_service.dart';

//create switch case depending if from history or edetails for
class ServiceWidget extends StatelessWidget {
  ServicesModel servicesModel;
  GlobalKey<ScaffoldState> globalKey;
  ServiceWidget({this.servicesModel, this.globalKey});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Row(
        children: [
          Flexible(
            flex: 3,
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, 'ceservice',
                    arguments: servicesModel);
              },
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
                            return Container();
                          default:
                            return Text(snapshot.data.name,
                                style: GoogleFonts.roboto().copyWith(
                                    color: Color(0xFF5C5C5C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500));
                        }
                      }),
                  Text(
                      servicesModel.whenCreated
                          .toDate()
                          .toString()
                          .split(' ')[0],
                      style: GoogleFonts.roboto().copyWith(
                          color: Color(0xFF5C5C5C),
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          Visibility(
            visible: servicesModel.endDate == null,
            child: Flexible(
                flex: 1,
                child: FlatButton(
                  height: 50,
                  color: Colors.transparent,
                  onPressed: () {
                    MaintenanceService()
                        .createService(
                            equipmentId: servicesModel.equipmentId,
                            title: servicesModel.title,
                            equipmentName: servicesModel.equipmentName,
                            startDate: (servicesModel.startDate),
                            endDate: Timestamp.now(),
                            mode: 'edit',
                            serviceId: servicesModel.id,
                            facility: servicesModel.facility,
                            createdBy: FirebaseAuth.instance.currentUser.uid,
                            notes: servicesModel.notes)
                        .then((value) {
                      value
                          ? globalKey.currentState.showSnackBar(SnackBar(
                              duration: Duration(milliseconds: 500),
                              content: Text('Service Updated',
                                  style: GoogleFonts.roboto()
                                      .copyWith(color: Colors.green)),
                              backgroundColor: Colors.lightGreen.shade100,
                            )) //issue here
                          : globalKey.currentState.showSnackBar(SnackBar(
                              content: Text('Something went wrong',
                                  style: GoogleFonts.roboto()
                                      .copyWith(color: Colors.red)),
                              backgroundColor: Colors.red.shade100,
                            )); //issue here
                    });
                  },
                  child: Text(
                    'Close service',
                    textAlign: TextAlign.center,
                  ),
                  textColor: Colors.red,
                )),
          )
        ],
      ),
    );
  }
}
