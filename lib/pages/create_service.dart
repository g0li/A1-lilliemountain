import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skimscope/model/equipment_model.dart';
import 'package:skimscope/model/facilities_model.dart';
import 'package:skimscope/model/services_model.dart';
import 'package:skimscope/services/facility_service.dart';
import 'package:skimscope/services/maintenance_service.dart';

class CreateEditServicePage extends StatelessWidget {
  TextEditingController title = TextEditingController();
  TextEditingController notes = TextEditingController();
  EquipmentModel equipment;
  ServicesModel servicesModel;
  CreateEditServicePage({this.equipment, this.servicesModel}) {
    if (servicesModel != null) {
      title = TextEditingController(text: servicesModel.title);
      notes = TextEditingController(text: servicesModel.notes);
    } else {
      title = TextEditingController();
      notes = TextEditingController();
    }
  }
  GlobalKey<ScaffoldState> cesKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (equipment != null)
      return Scaffold(
        key: cesKey,
        appBar: AppBar(
          title: Text('New Service'),
          actions: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.home),
              onPressed: () {
                // Navigator.pushNamed(context, 'employee');
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                      controller: title,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                      controller: notes,
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 6,
                      decoration: InputDecoration(
                        labelText: 'notes',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                      enabled: false,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: equipment.name,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: equipment.facilityId.name,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: equipment.siteId.name,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                      )),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(8),
                    child: CupertinoButton(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                      child: Text('Create'),
                      onPressed: () {
                        // Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => Center(
                                  child: SizedBox(
                                    child: CircularProgressIndicator(),
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                            barrierDismissible: false);
                        MaintenanceService()
                            .createService(
                                equipmentId: equipment.id,
                                title: title.text,
                                equipmentName: equipment.name,
                                startDate: Timestamp.now(),
                                endDate: null,
                                facility: equipment.facilityId,
                                createdBy:
                                    FirebaseAuth.instance.currentUser.uid,
                                notes: notes.text)
                            .then((value) {
                          Navigator.pop(context);

                          value
                              ? cesKey.currentState
                                  .showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 500),
                                    content: Text('Service Added',
                                        style: GoogleFonts.roboto()
                                            .copyWith(color: Colors.green)),
                                    backgroundColor: Colors.lightGreen.shade100,
                                  ))
                                  .closed
                                  .then((value) =>
                                      Navigator.pop(context)) //issue here
                              : cesKey.currentState
                                  .showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 500),
                                    content: Text('Something went wrong',
                                        style: GoogleFonts.roboto()
                                            .copyWith(color: Colors.red)),
                                    backgroundColor: Colors.red.shade100,
                                  ))
                                  .closed
                                  .then((value) =>
                                      Navigator.pop(context)); //issue here
                        });
                      },
                    )),
              ],
            ),
          ),
        ),
      );
    else
      return Scaffold(
        key: cesKey,
        appBar: AppBar(
          title: Text('Update Service'),
          actions: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.home),
              onPressed: () {
                // Navigator.pushNamed(context, 'employee');
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                      controller: title,
                      keyboardType: TextInputType.text,
                      enabled: servicesModel.endDate == null,
                      decoration: InputDecoration(
                        labelText: 'title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                      controller: notes,
                      enabled: servicesModel.endDate == null,
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 6,
                      decoration: InputDecoration(
                        labelText: 'notes',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                      enabled: false,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: servicesModel.equipmentName,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: servicesModel.facility.name,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: servicesModel.facility.site.name,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                      )),
                ),
                Visibility(
                  visible: servicesModel.endDate == null,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(8),
                      child: CupertinoButton(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                        child: Text('Update'),
                        onPressed: () {
                          // Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) => Center(
                                    child: SizedBox(
                                      child: CircularProgressIndicator(),
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                              barrierDismissible: false);
                          MaintenanceService()
                              .createService(
                                  mode: 'update',
                                  serviceId: servicesModel.id,
                                  equipmentId: servicesModel.equipmentId,
                                  equipmentName: servicesModel.equipmentName,
                                  title: title.text,
                                  startDate: servicesModel.startDate,
                                  endDate: null,
                                  facility: servicesModel.facility,
                                  createdBy:
                                      FirebaseAuth.instance.currentUser.uid,
                                  notes: notes.text)
                              .then((value) {
                            Navigator.pop(context);

                            value
                                ? cesKey.currentState
                                    .showSnackBar(SnackBar(
                                      duration: Duration(milliseconds: 500),
                                      content: Text('Service Updated',
                                          style: GoogleFonts.roboto()
                                              .copyWith(color: Colors.green)),
                                      backgroundColor:
                                          Colors.lightGreen.shade100,
                                    ))
                                    .closed
                                    .then((value) =>
                                        Navigator.pop(context)) //issue here
                                : cesKey.currentState
                                    .showSnackBar(SnackBar(
                                      duration: Duration(milliseconds: 500),
                                      content: Text('Something went wrong',
                                          style: GoogleFonts.roboto()
                                              .copyWith(color: Colors.red)),
                                      backgroundColor: Colors.red.shade100,
                                    ))
                                    .closed
                                    .then((value) =>
                                        Navigator.pop(context)); //issue here
                          });
                        },
                      )),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
