import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skimscope/model/services_model.dart';
import 'package:skimscope/providers/user_provider.dart';
import 'package:skimscope/services/maintenance_service.dart';
import 'package:skimscope/widgets/employee_widget.dart';
import 'package:skimscope/widgets/service_widget.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> sites = ['Please choose a site', 'A', 'B', 'C', 'D'];
  GlobalKey<ScaffoldState> hKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    MaintenanceService().getMyServices();
    return Scaffold(
        key: hKey,
        appBar: AppBar(
          title: Text('History'),
          actions: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.home),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    userProvider.user.role == 'Admin' ? 'admin' : 'employeeH',
                    (route) => false);
              },
            )
          ],
        ),
        body: FutureBuilder<List<ServicesModel>>(
            future: MaintenanceService().getMyServices(),
            // future: Future.delayed(Duration(seconds: 1)),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text(snapshot.error.toString());
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return ListView.separated(
                      itemBuilder: (context, i) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade100,
                            highlightColor: Colors.grey.shade50,
                            child: Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                      separatorBuilder: (context, i) => Divider(),
                      itemCount: 10);
                  break;
                default:
                  List<ServicesModel> history = [];
                  for (var item in snapshot.data) {
                    if (item.createdBy ==
                            FirebaseAuth.instance.currentUser.uid &&
                        item.endDate != null) history.add(item);
                  }
                  return history.length > 0
                      ? ListView.separated(
                          itemBuilder: (context, i) => ServiceWidget(
                                servicesModel: history[i],
                                globalKey: hKey,
                              ),
                          separatorBuilder: (context, i) => Divider(),
                          itemCount: history.length)
                      : Text('No past services');
              }
            }));
  }
}
