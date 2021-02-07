import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skimscope/model/equipment_model.dart';
import 'package:skimscope/model/services_model.dart';
import 'package:skimscope/services/maintenance_service.dart';
import 'package:skimscope/widgets/service_widget.dart';

class EquipmentDetailPage extends StatefulWidget {
  EquipmentModel equipment;

  EquipmentDetailPage({Key key, this.equipment}) : super(key: key);

  @override
  _EquipmentDetailPageState createState() => _EquipmentDetailPageState();
}

class _EquipmentDetailPageState extends State<EquipmentDetailPage>
    with TickerProviderStateMixin {
  bool isLive = true;
  var pc = PageController(initialPage: 0);
  GlobalKey<ScaffoldState> edKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: edKey,
      appBar: AppBar(
        title: Text('${widget.equipment.name}'),
        actions: [
          CupertinoSwitch(
              value: widget.equipment.isActive,
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
          Navigator.pushNamed(context, 'ceservice',
              arguments: widget.equipment);
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
                        widget.equipment.imageUrl,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.equipment.srNo,
                    style: GoogleFonts.roboto()
                        .copyWith(color: Colors.black, fontSize: 12),
                  ),
                  Text(
                      'doi :${(widget.equipment.installationDate as Timestamp).toDate().toString().split(' ')[0]}',
                      style: GoogleFonts.roboto().copyWith(
                          color: Color(0xFF5C5C5C),
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.equipment.name,
                      style: GoogleFonts.roboto().copyWith(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  IconButton(
                      icon: FaIcon(FontAwesomeIcons.solidEdit),
                      onPressed: () {})
                ],
              ),
              Text(
                  '${widget.equipment.siteId.name} / ${widget.equipment.facilityId.name}',
                  style: GoogleFonts.roboto().copyWith(
                      color: Color(0xFF5C5C5C),
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: FlatButton(
                          textColor: Colors.green,
                          child: Text('LIVE'),
                          onPressed: () {
                            pc.jumpToPage(0);
                          },
                        )),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: FlatButton(
                          textColor: Colors.red,
                          child: Text('CLOSED'),
                          onPressed: () {
                            pc.jumpToPage(1);
                          },
                        ))
                  ],
                ),
              ),
              StreamBuilder<List<ServicesModel>>(
                  stream: MaintenanceService()
                      .getEquipmentServices(equipmentId: widget.equipment.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Text(snapshot.error.toString());
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return ListView.separated(
                          shrinkWrap: true,
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade50,
                              child: Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                              )),
                          itemCount: 5,
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(),
                        );
                        break;
                      default:
                        List<ServicesModel> history = snapshot.data;
                        List<ServicesModel> live = snapshot.data
                            .where((element) => element.endDate == null)
                            .toList();
                        List<ServicesModel> closed = snapshot.data
                            .where((element) => element.endDate != null)
                            .toList();
                        if (history.length > 0) {
                          return Container(
                            height: 300,
                            child: PageView(
                              controller: pc,
                              children: [
                                live.length > 0
                                    ? ListView.separated(
                                        shrinkWrap: true,
                                        primary: false,
                                        itemBuilder: (context, i) =>
                                            ServiceWidget(
                                          servicesModel: live[i],
                                          globalKey: edKey,
                                        ),
                                        itemCount: live.length,
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                Divider(),
                                      )
                                    : Center(
                                        child: Text(
                                            'No Live Services for ${widget.equipment.name}'),
                                      ),
                                closed.length > 0
                                    ? ListView.separated(
                                        shrinkWrap: true,
                                        primary: false,
                                        itemBuilder: (context, i) =>
                                            ServiceWidget(
                                          servicesModel: closed[i],
                                          globalKey: edKey,
                                        ),
                                        itemCount: closed.length,
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                Divider(),
                                      )
                                    : Center(
                                        child: Text(
                                            'No closed Services for ${widget.equipment.name}'),
                                      ),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
