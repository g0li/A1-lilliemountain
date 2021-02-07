import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skimscope/model/equipment_model.dart';
import 'package:skimscope/providers/user_provider.dart';
import 'package:skimscope/services/auth_service.dart';
import 'package:encrypt/encrypt.dart' as e;
import 'package:skimscope/services/equipment_service.dart';

class EmployeeHomePage extends StatelessWidget {
  EquipmentModel tempEquipment = EquipmentModel(
    createdBy: '',
    facilityId: 'facility 1',
    id: '3413413465t',
    installationDate: '23/4/2012',
    isActive: true,
    name: 'Equipment name',
    siteId: 'site 1 ',
    srNo: 'SN-00851#232',
  );
  final df = new DateFormat('dd/MM/yyyy');
  final authService = AuthService();
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Hello ${userProvider.user != null ? userProvider.user.name : 'User'}'),
          actions: [
            IconButton(
                icon: FaIcon(FontAwesomeIcons.signOutAlt),
                onPressed: () {
                  authService.signout(context: context);
                })
          ],
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            if (userProvider.user != null)
              ListTile(
                leading: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        userProvider.user.imageUrl ??
                            'https://via.placeholder.com/80x80.png',
                      ),
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        userProvider.user.name,
                        style: GoogleFonts.roboto().copyWith(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          userProvider.user.email,
                          style: GoogleFonts.roboto().copyWith(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'joining date : ${df.format(userProvider.user.joiningDate.toDate())}',
                        style: GoogleFonts.roboto().copyWith(
                            fontSize: 12,
                            color: Color(0xFF5C5C5C),
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                    onPressed: () {
                      FlutterBarcodeScanner.scanBarcode(
                              "#ff6666", "Cancel", false, ScanMode.DEFAULT)
                          .then((barcode) {
                        final key =
                            e.Key.fromUtf8('5D0A3B28CA2EA8D2F1A4FDBEBB7050DD');
                        final iv =
                            e.IV.fromUtf8('6D73C0D5E94CEC41EC055EDF36CC7F29');

                        final encrypter =
                            e.Encrypter(e.AES(key, mode: e.AESMode.cfb64));
                        final decrypted = encrypter.decrypt64(barcode, iv: iv);
                        EquipmentService()
                            .getEquipment(decrypted)
                            .listen((event) {
                          Navigator.pushNamed(context, 'edetails',
                              arguments: event);
                        });
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.qrcode,
                            size: 60,
                            color: Theme.of(context).primaryColor,
                          ),
                          Text('Scan',
                              style: GoogleFonts.roboto().copyWith(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor))
                        ],
                      ),
                    )),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'history');
                    },
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.history,
                            size: 60,
                            color: Theme.of(context).primaryColor,
                          ),
                          Text('History',
                              style: GoogleFonts.roboto().copyWith(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor))
                        ],
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
