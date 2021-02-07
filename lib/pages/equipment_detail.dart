import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skimscope/model/equipment_model.dart';
import 'package:skimscope/widgets/service_widget.dart';

class EquipmentDetailPage extends StatelessWidget {
  EquipmentModel equipment;

  EquipmentDetailPage({Key key, this.equipment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${equipment.name}'),
        actions: [
          CupertinoSwitch(
              value: equipment.isActive,
              onChanged: (_) {
                // setState(() {
                //   widget.equipment.isActive = _;
                // });
              }),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.home),
            onPressed: () {
              // Navigator.pushNamed(context, 'employee');
            },
          ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.qrcode),
            onPressed: () {
              // Navigator.pushNamed(context, 'employee');
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'ceservice');
        },
        backgroundColor: Color(0xFFC8553D),
        child: FaIcon(
          FontAwesomeIcons.plus,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  height: 400,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                      image: NetworkImage(
                        equipment.imageUrl,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    equipment.srNo,
                    style: GoogleFonts.roboto()
                        .copyWith(color: Colors.black, fontSize: 12),
                  ),
                  Text(
                      'doi :${(equipment.installationDate as Timestamp).toDate().toString().split(' ')[0]}',
                      style: GoogleFonts.roboto().copyWith(
                          color: Color(0xFF5C5C5C),
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(equipment.name,
                      style: GoogleFonts.roboto().copyWith(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  IconButton(
                      icon: FaIcon(FontAwesomeIcons.solidEdit),
                      onPressed: () {})
                ],
              ),
              Text('${equipment.siteId.name} / ${equipment.facilityId.name}',
                  style: GoogleFonts.roboto().copyWith(
                      color: Color(0xFF5C5C5C),
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              Divider(),
              Text('history',
                  style: GoogleFonts.roboto().copyWith(
                      color: Color(0xFF5C5C5C),
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, i) => ServiceWidget(),
                itemCount: 5,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
