import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateEditServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'start time',
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
                    decoration: InputDecoration(
                      labelText: 'end time',
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
                    decoration: InputDecoration(
                      labelText: 'equipment',
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
                    decoration: InputDecoration(
                      labelText: 'facility',
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
                    decoration: InputDecoration(
                      labelText: 'site',
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
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
