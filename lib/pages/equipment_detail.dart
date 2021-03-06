import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skimscope/model/equipment_model.dart';
import 'package:skimscope/model/services_model.dart';
import 'package:skimscope/providers/user_provider.dart';
import 'package:skimscope/services/equipment_service.dart';
import 'package:skimscope/services/maintenance_service.dart';
import 'package:skimscope/widgets/service_widget.dart';
import 'package:encrypt/encrypt.dart' as e;

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
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      key: edKey,
      appBar: AppBar(
        title: Text('${widget.equipment.name}'),
        actions: [
          userProvider.user.role == 'Admin'
              ? StreamBuilder<bool>(
                  stream:
                      EquipmentService().wathchIsActive(widget.equipment.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return Container();
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return CircularProgressIndicator();

                        break;
                      default:
                        return CupertinoSwitch(
                            value: snapshot.data,
                            onChanged: (_) {
                              String added = _ ? ' activated' : ' deactivated';
                              EquipmentService()
                                  .toggleEquipment(_, widget.equipment.id)
                                  .then((value) {
                                edKey.currentState.hideCurrentSnackBar();
                                edKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      '${widget.equipment.name} $added',
                                      style: GoogleFonts.roboto().copyWith(
                                          color:
                                              _ ? Colors.green : Colors.red)),
                                  backgroundColor: _
                                      ? Colors.lightGreen.shade100
                                      : Colors.red.shade100,
                                ));
                              });
                            });
                    }
                  })
              : Container(),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.home),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  userProvider.user.role == 'Admin' ? 'admin' : 'employeeH',
                  (route) => false);
            },
          ),
          userProvider.user.role == 'Admin'
              ? IconButton(
                  icon: FaIcon(FontAwesomeIcons.qrcode),
                  onPressed: () {
                    // Navigator.pushNamed(context, 'employee');
                    generateQRCODE(widget.equipment);
                  },
                )
              : Container()
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
        controller: ScrollController(debugLabel: 'sclv'),
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
                  userProvider.user.role == 'Admin'
                      ? IconButton(
                          icon: FaIcon(FontAwesomeIcons.solidEdit),
                          onPressed: () {})
                      : Container()
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
                        List<ServicesModel> history = [];
                        // List<ServicesModel> history = snapshot.data;
                        if (userProvider.user.role == 'Admin')
                          history = snapshot.data;
                        else {
                          history.clear();
                          for (var item in snapshot.data) {
                            if (item.createdBy ==
                                FirebaseAuth.instance.currentUser.uid)
                              history.add(item);
                          }
                        }
                        List<ServicesModel> live = history
                            .where((element) => element.endDate == null)
                            .toList();
                        List<ServicesModel> closed = history
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
                                    : Align(
                                        alignment: Alignment.topLeft,
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
                                    : Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            'No closed Services for ${widget.equipment.name}'),
                                      ),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                              height: 300,
                              child: PageView(
                                controller: pc,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        'No Live Services for ${widget.equipment.name}'),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        'No Closed Services for ${widget.equipment.name}'),
                                  ),
                                ],
                              ));
                        }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  generateQRCODE(EquipmentModel equipment) {
    String id = equipment.id;
    final key = e.Key.fromUtf8('5D0A3B28CA2EA8D2F1A4FDBEBB7050DD');
    final iv = e.IV.fromUtf8('6D73C0D5E94CEC41EC055EDF36CC7F29');

    final encrypter = e.Encrypter(e.AES(key, mode: e.AESMode.cfb64));
    final encrypted = encrypter.encrypt(id, iv: iv);
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: FittedBox(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QrImage(
                        data: encrypted.base64,
                        version: QrVersions.auto,
                        backgroundColor: Colors.white,
                        size: 200.0,
                      ),
                      Opacity(
                        opacity: .4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'skimscope',
                            style: GoogleFonts.roboto().copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: 10,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
