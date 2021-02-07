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
import 'package:skimscope/model/sites_model.dart';
import 'package:skimscope/services/equipment_service.dart';
import 'package:skimscope/services/facility_service.dart';

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
                          appBar: AppBar(
                            title: Text('New Equipment'),
                          ),
                          body: SingleChildScrollView(
                            child: Form(
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
                                                createEquipment(
                                                    name, srNo, context);
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
                              body: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      child: Row(
                                        children: [
                                          Text(
                                              'service since last installation :',
                                              style:
                                                  GoogleFonts.roboto().copyWith(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              )),
                                          Text('5',
                                              style:
                                                  GoogleFonts.roboto().copyWith(
                                                color: Colors.black,
                                                fontSize: 14,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      child: Row(
                                        children: [
                                          Text('last service by :',
                                              style:
                                                  GoogleFonts.roboto().copyWith(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              )),
                                          Text(' employee name',
                                              style:
                                                  GoogleFonts.roboto().copyWith(
                                                color: Colors.black,
                                                fontSize: 14,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      child: Row(
                                        children: [
                                          Text('service date:',
                                              style:
                                                  GoogleFonts.roboto().copyWith(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              )),
                                          Text(' 31/5/2021',
                                              style:
                                                  GoogleFonts.roboto().copyWith(
                                                color: Colors.black,
                                                fontSize: 14,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: CupertinoButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, 'edetails',
                                              arguments: item);
                                        },
                                        child: Text(
                                          'MORE',
                                          style: GoogleFonts.roboto().copyWith(
                                              color: Color(0xFFC8553D),
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
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
}
