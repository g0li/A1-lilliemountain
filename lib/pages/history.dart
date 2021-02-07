import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skimscope/widgets/employee_widget.dart';
import 'package:skimscope/widgets/service_widget.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> sites = ['Please choose a site', 'A', 'B', 'C', 'D'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.home),
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('employeeH', (route) => false);
            },
          )
        ],
      ),
      body: ListView.separated(
          itemBuilder: (context, i) => Container(),
          // itemBuilder: (context, i) => ServiceWidget(),
          separatorBuilder: (context, i) => Divider(),
          itemCount: 10),
    );
  }
}
