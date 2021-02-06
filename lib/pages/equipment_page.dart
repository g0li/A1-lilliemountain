import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skimscope/model/equipment_model.dart';

class EquipmentPage extends StatefulWidget {
  @override
  _EquipmentPageState createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  List<String> sites = ['Please choose a site', 'A', 'B', 'C', 'D'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                'Facility 1',
                style: GoogleFonts.roboto().copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              Text(
                'equipment count : 10',
                style: GoogleFonts.roboto()
                    .copyWith(fontSize: 14, color: Colors.white),
              ),
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
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return Container(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 200,
                                      child: FaIcon(
                                        FontAwesomeIcons.camera,
                                        color: Colors.grey,
                                        size: 50,
                                      ),
                                      width: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            'https://via.placeholder.com/500.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: TextFormField(
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
                                    child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          labelText: 'Date of Installation',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2)),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButton<String>(
                                        isExpanded: true,
                                        items: sites.map((String val) {
                                          return new DropdownMenuItem<String>(
                                            value: val,
                                            child: new Text(val),
                                          );
                                        }).toList(),
                                        hint: Text("Please choose a facility"),
                                        onChanged: (newVal) {}),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButton<String>(
                                        isExpanded: true,
                                        items: sites.map((String val) {
                                          return new DropdownMenuItem<String>(
                                            value: val,
                                            child: new Text(val),
                                          );
                                        }).toList(),
                                        hint: Text("Please choose a site"),
                                        onChanged: (newVal) {}),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(8),
                                      child: CupertinoButton(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(30),
                                        child: Text('Create'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )),
                                ]),
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
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                eData[index].isExpanded = !isExpanded;
              });
            },
            children: eData.map<ExpansionPanel>((EquipmentModel item) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        eData[eData.indexOf(item)].isExpanded = !isExpanded;
                      });
                    },
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.srNo,
                          style: GoogleFonts.roboto()
                              .copyWith(color: Colors.black, fontSize: 12),
                        ),
                        Text(item.name,
                            style: GoogleFonts.roboto().copyWith(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item.siteId} / ${item.facilityId}',
                                style: GoogleFonts.roboto().copyWith(
                                    color: Color(0xFF5C5C5C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)),
                            Text('doi :${item.installationDate}',
                                style: GoogleFonts.roboto().copyWith(
                                    color: Color(0xFF5C5C5C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                body: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Text('service since last installation :',
                                style: GoogleFonts.roboto().copyWith(
                                  color: Color(0xFF5C5C5C),
                                  fontSize: 12,
                                )),
                            Text('5',
                                style: GoogleFonts.roboto().copyWith(
                                  color: Colors.black,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Text('last service by :',
                                style: GoogleFonts.roboto().copyWith(
                                  color: Color(0xFF5C5C5C),
                                  fontSize: 12,
                                )),
                            Text(' employee name',
                                style: GoogleFonts.roboto().copyWith(
                                  color: Colors.black,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Text('service date:',
                                style: GoogleFonts.roboto().copyWith(
                                  color: Color(0xFF5C5C5C),
                                  fontSize: 12,
                                )),
                            Text(' 31/5/2021',
                                style: GoogleFonts.roboto().copyWith(
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
                            Navigator.pushNamed(context, 'edetails',
                                arguments: item);
                          },
                          child: Text(
                            'MORE',
                            style: GoogleFonts.roboto().copyWith(
                                color: Color(0xFFC8553D),
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                isExpanded: item.isExpanded,
              );
            }).toList(),
          ),
        )));
  }
}

List<EquipmentModel> eData = [
  EquipmentModel(
    createdBy: '',
    facilityId: 'facility 1',
    id: '3413413465t',
    installationDate: '23/4/2012',
    isActive: true,
    name: 'Equipment name',
    siteId: 'site 1 ',
    srNo: 'SN-00851#232',
  ),
  EquipmentModel(
    createdBy: '',
    facilityId: 'facility 1',
    id: '3413413465t',
    installationDate: '23/4/2012',
    isActive: true,
    name: 'Equipment name',
    siteId: 'site 1 ',
    srNo: 'SN-00851#232',
  ),
  EquipmentModel(
    createdBy: '',
    facilityId: 'facility 1',
    id: '3413413465t',
    installationDate: '23/4/2012',
    isActive: true,
    name: 'Equipment name',
    siteId: 'site 1 ',
    srNo: 'SN-00851#232',
  ),
  EquipmentModel(
    createdBy: '',
    facilityId: 'facility 1',
    id: '3413413465t',
    installationDate: '23/4/2012',
    isActive: true,
    name: 'Equipment name',
    siteId: 'site 1 ',
    srNo: 'SN-00851#232',
  ),
  EquipmentModel(
    createdBy: '',
    facilityId: 'facility 1',
    id: '3413413465t',
    installationDate: '23/4/2012',
    isActive: true,
    name: 'Equipment name',
    siteId: 'site 1 ',
    srNo: 'SN-00851#232',
  ),
];
