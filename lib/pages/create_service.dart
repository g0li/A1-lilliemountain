import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skimscope/model/equipment_model.dart';
import 'package:skimscope/model/facilities_model.dart';
import 'package:skimscope/services/facility_service.dart';
import 'package:skimscope/services/maintenance_service.dart';

class CreateEditServicePage extends StatelessWidget {
  TextEditingController title = TextEditingController();
  TextEditingController notes = TextEditingController();
  EquipmentModel equipment;
  CreateEditServicePage(this.equipment);
  GlobalKey<ScaffoldState> cesKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
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
                              startDate: DateTime.now(),
                              endDate: null,
                              facility: equipment.facilityId,
                              createdBy: FirebaseAuth.instance.currentUser.uid,
                              notes: notes.text)
                          .then((value) {
                        Navigator.pop(context);

                        value
                            ? cesKey.currentState
                                .showSnackBar(SnackBar(
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
  }
}
