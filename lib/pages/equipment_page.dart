import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skimscope/model/equipment_model.dart';
import 'package:skimscope/model/facilities_model.dart';
import 'package:skimscope/model/services_model.dart';
import 'package:skimscope/model/sites_model.dart';
import 'package:skimscope/model/user_model.dart';
import 'package:skimscope/services/auth_service.dart';
import 'package:skimscope/services/equipment_service.dart';
import 'package:skimscope/services/facility_service.dart';
import 'package:skimscope/services/maintenance_service.dart';

class EquipmentPage extends StatelessWidget {
  FacilitesModel currentFacility;
  EquipmentPage(this.currentFacility);
//   @override
//   _EquipmentPageState createState() => _EquipmentPageState();
// }

// class _EquipmentPageState extends State<EquipmentPage> {
  final picker = ImagePicker();
  File _image;
  SitesModel currentSite;
  DateTime selectedDate = DateTime.now();
  String sdValue = DateTime.now().toString().split(' ')[0];
  GlobalKey<ScaffoldState> eKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // currentFacility = ModalRoute.of(context).settings.arguments;
    currentSite = currentFacility.site;
    return Scaffold(
        key: eKey,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentFacility.name,
                style: GoogleFonts.roboto().copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              StreamBuilder<int>(
                  stream: EquipmentService().getEquipmentCount(currentFacility),
                  builder: (context, snapshotI) {
                    if (snapshotI.hasError) return Text('');
                    switch (snapshotI.connectionState) {
                      case ConnectionState.waiting:
                        return Shimmer.fromColors(
                          child: Text(
                            'equipment count :',
                            style: GoogleFonts.roboto()
                                .copyWith(color: Colors.black, fontSize: 14),
                          ),
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade50,
                        );
                        break;
                      default:
                        return Text(
                          'equipment count : ${snapshotI.data}',
                          style: GoogleFonts.roboto()
                              .copyWith(fontSize: 14, color: Colors.white),
                        );
                    }
                  }),
            ],
          ),
          actions: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.home),
              onPressed: () {
                // Navigator.pushNamed(context, 'employee');
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            TextEditingController name = TextEditingController();
            TextEditingController srNo = TextEditingController();
            TextEditingController doI = TextEditingController();
            GlobalKey<FormState> eFormKey = GlobalKey<FormState>();
            GlobalKey<ScaffoldState> addEKey = GlobalKey<ScaffoldState>();
            showModalBottomSheet(
                isDismissible: false,
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return WillPopScope(
                    onWillPop: () {
                      _image = null;
                      return Future.value(true);
                    },
                    child: StatefulBuilder(
                      builder: (context, setstate) => Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: Scaffold(
                          key: addEKey,
                          appBar: AppBar(
                            title: Text('New Equipment'),
                          ),
                          body: SingleChildScrollView(
                            child: Form(
                              key: eFormKey,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28.0, vertical: 16),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: FlatButton(
                                          onPressed: () {
                                            getImage(setstate);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 200,
                                            child: _image == null
                                                ? FaIcon(
                                                    FontAwesomeIcons.camera,
                                                    color: Colors.grey,
                                                    size: 50,
                                                  )
                                                : Image.file(
                                                    _image,
                                                    height: 200,
                                                    fit: BoxFit.fill,
                                                  ),
                                            width: 200,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                color: Colors.grey.shade300),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: TextFormField(
                                            controller: name,
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value.trim().isEmpty)
                                                return 'Please enter equipment name';
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'Equipment name',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2)),
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: TextFormField(
                                            controller: srNo,
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value.trim().isEmpty)
                                                return 'Please enter serial number';
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'S/N',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2)),
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: InkWell(
                                          onTap: () {
                                            _selectDate(context,
                                                setstate); // Call Function that has showDatePicker()
                                          },
                                          child: IgnorePointer(
                                            child: TextFormField(
                                                controller: doI,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                  labelText: sdValue,
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 2)),
                                                )),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            enabled: false,
                                            decoration: InputDecoration(
                                              labelText:
                                                  'Facility : ${currentFacility.name}',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2)),
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            enabled: false,
                                            decoration: InputDecoration(
                                              labelText:
                                                  'Site : ${currentSite.name}',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2)),
                                            )),
                                      ),
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.all(8),
                                          child: CupertinoButton(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              child: Text('Create'),
                                              onPressed: () {
                                                // Navigator.pop(context);
                                                if (eFormKey.currentState
                                                        .validate() &&
                                                    _image != null)
                                                  createEquipment(
                                                      name, srNo, context);
                                                else if (_image == null)
                                                  addEKey.currentState
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Please provide with equipment image',
                                                        style: GoogleFonts
                                                                .roboto()
                                                            .copyWith(
                                                                color: Colors
                                                                    .red)),
                                                    backgroundColor:
                                                        Colors.red.shade100,
                                                  ));
                                              })),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          },
          backgroundColor: Color(0xFFC8553D),
          child: FaIcon(
            FontAwesomeIcons.plus,
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          child: StreamBuilder<List<EquipmentModel>>(
              stream: EquipmentService().getAllEquipments(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Something went wrong');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, i) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade50,
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 8),
                            title: Text(
                              'asdasd',
                              style: GoogleFonts.roboto()
                                  .copyWith(color: Colors.black, fontSize: 12),
                            ),
                          ),
                        ),
                        itemCount: 10,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                    );

                    break;
                  default:
                    List<EquipmentModel> equipments = snapshot.data;
                    return StatefulBuilder(
                      builder: (context, setstate) {
                        return ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setstate(() {
                              equipments[index].isExpanded = !isExpanded;
                            });
                          },
                          children: equipments
                              .map<ExpansionPanel>((EquipmentModel item) {
                            return ExpansionPanel(
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  onTap: () {
                                    setstate(() {
                                      equipments[equipments.indexOf(item)]
                                          .isExpanded = !isExpanded;
                                    });
                                  },
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 8),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.srNo,
                                        style: GoogleFonts.roboto().copyWith(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                      Text(item.name,
                                          style: GoogleFonts.roboto().copyWith(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${item.siteId.name} / ${item.facilityId.name}',
                                              style: GoogleFonts.roboto()
                                                  .copyWith(
                                                      color: Color(0xFF5C5C5C),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                          Text(
                                              'doi :${(item.installationDate as Timestamp).toDate().toString().split(' ')[0]}',
                                              style: GoogleFonts.roboto()
                                                  .copyWith(
                                                      color: Color(0xFF5C5C5C),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              body: StreamBuilder<List<ServicesModel>>(
                                  stream: MaintenanceService()
                                      .getEquipmentServices(
                                          equipmentId: item.id),
                                  builder: (context, snapshotB) {
                                    if (snapshotB.hasError)
                                      return Text('Something went wrong');
                                    switch (snapshotB.connectionState) {
                                      case ConnectionState.waiting:
                                        return Shimmer.fromColors(
                                            child: ListTile(),
                                            baseColor: Colors.grey.shade300,
                                            highlightColor:
                                                Colors.grey.shade50);
                                        break;
                                      default:
                                        List<ServicesModel> data =
                                            snapshotB.data;
                                        ServicesModel last;
                                        try {
                                          last = snapshotB.data.lastWhere(
                                              (element) =>
                                                  element.endDate != null);
                                        } catch (e) {
                                          last = null;
                                        }
                                        int lastIndex =
                                            snapshotB.data.lastIndexOf(
                                          last,
                                        );
                                        return ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        'service since installation :',
                                                        style:
                                                            GoogleFonts.roboto()
                                                                .copyWith(
                                                          color:
                                                              Color(0xFF5C5C5C),
                                                          fontSize: 12,
                                                        )),
                                                    Text(
                                                        (lastIndex + 1)
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.roboto()
                                                                .copyWith(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              last != null
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                              'last service by :',
                                                              style: GoogleFonts
                                                                      .roboto()
                                                                  .copyWith(
                                                                color: Color(
                                                                    0xFF5C5C5C),
                                                                fontSize: 12,
                                                              )),
                                                          StreamBuilder<
                                                                  UserModel>(
                                                              stream: AuthService()
                                                                  .getUser(last
                                                                      .createdBy),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasError)
                                                                  return Text(
                                                                      'NA');
                                                                switch (snapshot
                                                                    .connectionState) {
                                                                  case ConnectionState
                                                                      .waiting:
                                                                    return Container();
                                                                  default:
                                                                    return Text(
                                                                        snapshot
                                                                            .data
                                                                            .name,
                                                                        style: GoogleFonts.roboto().copyWith(
                                                                            color: Color(
                                                                                0xFF5C5C5C),
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500));
                                                                }
                                                              }),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                              last != null
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8),
                                                      child: Row(
                                                        children: [
                                                          Text('service date: ',
                                                              style: GoogleFonts
                                                                      .roboto()
                                                                  .copyWith(
                                                                color: Color(
                                                                    0xFF5C5C5C),
                                                                fontSize: 12,
                                                              )),
                                                          Text(
                                                              last.endDate
                                                                  .toDate()
                                                                  .toString()
                                                                  .split(
                                                                      ' ')[0],
                                                              style: GoogleFonts
                                                                      .roboto()
                                                                  .copyWith(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                              )),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                              Row(
                                                children: [
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    flex: 1,
                                                    child: FlatButton(
                                                      onPressed: () {
                                                        showAlertDialog(
                                                            context, item);
                                                      },
                                                      child: Text(
                                                        'DELETE',
                                                        style:
                                                            GoogleFonts.roboto()
                                                                .copyWith(
                                                          color:
                                                              Color(0xFFC8553D),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: FlatButton(
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                            context, 'edetails',
                                                            arguments: item);
                                                      },
                                                      child: Text(
                                                        'MORE',
                                                        style:
                                                            GoogleFonts.roboto()
                                                                .copyWith(
                                                          color:
                                                              Color(0xFFC8553D),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                    }
                                  }),
                              isExpanded: item.isExpanded,
                            );
                          }).toList(),
                        );
                      },
                    );
                }
              }),
        )));
  }

  createEquipment(name, srNo, context) {
    EquipmentService()
        .createEquipment(
            facilityId: currentFacility,
            site: currentSite,
            name: name.text,
            srNo: srNo.text,
            installationDate: selectedDate,
            createdBy: FirebaseAuth.instance.currentUser.uid,
            image: _image)
        .then((value) {
      if (MediaQuery.of(context).viewInsets.bottom != 0) Navigator.pop(context);
      value
          ? eKey.currentState
              .showSnackBar(SnackBar(
                content: Text('Equipment added',
                    style: GoogleFonts.roboto().copyWith(color: Colors.green)),
                backgroundColor: Colors.lightGreen.shade100,
              ))
              .closed
              .then((value) => Navigator.pop(context)) //issue here
          : eKey.currentState
              .showSnackBar(SnackBar(
                content: Text('Something went wrong',
                    style: GoogleFonts.roboto().copyWith(color: Colors.red)),
                backgroundColor: Colors.red.shade100,
              ))
              .closed
              .then((value) => Navigator.pop(context)); //issue here
    });
  }

  getImage(setstate) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setstate(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _selectDate(BuildContext context, setstate) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setstate(() {
        selectedDate = picked;
        sdValue = picked.toString().split(' ')[0];
      });
    print(sdValue);
  }

  showAlertDialog(BuildContext context, EquipmentModel equipmentModel) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        EquipmentService()
            .deleteEquipment(equipmentId: equipmentModel.id)
            .then((value) {
          if (value) {
            Navigator.pop(context);
            eKey.currentState.showSnackBar(SnackBar(
              duration: Duration(milliseconds: 1000),
              content: Text('Service Updated',
                  style: GoogleFonts.roboto().copyWith(color: Colors.green)),
              backgroundColor: Colors.lightGreen.shade100,
            ));
          } //issue here
          else {
            Navigator.pop(context);
            eKey.currentState.showSnackBar(SnackBar(
              duration: Duration(milliseconds: 1000),
              content: Text('Something went wrong',
                  style: GoogleFonts.roboto().copyWith(color: Colors.red)),
              backgroundColor: Colors.red.shade100,
            ));
          }
        });
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("DELETE ${equipmentModel.name}"),
      content: Text("Would you like to proceed ahead?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
