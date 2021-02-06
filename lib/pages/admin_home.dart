import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skimscope/widgets/site_widget.dart';

class AdminHomePage extends StatelessWidget {
  List<String> sites = ['Please choose a site', 'A', 'B', 'C', 'D'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skimscope'),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.hardHat),
            onPressed: () {
              Navigator.pushNamed(context, 'employee');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: Stream.fromFuture(
            Future.delayed(Duration(seconds: 2)),
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return AbsorbPointer(
                  absorbing: true,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              primary: false,
                              scrollDirection: Axis.horizontal,
                              itemCount: 3 + 1,
                              itemBuilder: (context, i) {
                                return Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade50,
                                    child: SiteWidget(siteName: '  '));
                              }),
                        ),
                        Container(
                          height: 700,
                          child: ListView.builder(
                              primary: false,
                              itemCount: 1,
                              itemBuilder: (context, i) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade50,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushNamed(context, 'equipment');
                                    },
                                    title: Text(
                                      'facility',
                                      style: GoogleFonts.roboto().copyWith(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      'equipment count : 0  ',
                                      style: GoogleFonts.roboto().copyWith(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                    trailing: FaIcon(
                                      FontAwesomeIcons.chevronRight,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                );
              default:
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sites',
                        style: GoogleFonts.roboto().copyWith(
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).primaryColor,
                            fontSize: 24),
                      ),
                      Container(
                        height: 120,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            primary: false,
                            scrollDirection: Axis.horizontal,
                            itemCount: 3 + 1,
                            itemBuilder: (context, i) {
                              if (i == 3)
                                return Container(
                                  margin: const EdgeInsets.all(4.0),
                                  child: Material(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                    child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Scaffold(
                                                appBar: AppBar(
                                                  title: Text('New site'),
                                                ),
                                                body: Form(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 28.0,
                                                        vertical: 16),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            child:
                                                                TextFormField(
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .text,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'site name',
                                                                      border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              10),
                                                                          borderSide: BorderSide(
                                                                              color: Colors.black,
                                                                              width: 2)),
                                                                    )),
                                                          ),
                                                          Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8),
                                                              child:
                                                                  CupertinoButton(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                child: Text(
                                                                    'Create'),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              )),
                                                        ]),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        child: SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '+ ',
                                              style: GoogleFonts.roboto(
                                                  fontSize: 40,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )),
                                  ),
                                );
                              else
                                return SiteWidget(
                                    isActive: i % 2 == 0, siteName: 'mumbai');
                            }),
                      ),
                      Container(
                        height: 700,
                        child: ListView.builder(
                            primary: false,
                            itemCount: 3 + 1,
                            itemBuilder: (context, i) {
                              if (i == 3)
                                return ListTile(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Scaffold(
                                          appBar: AppBar(
                                            title: Text('New Facility'),
                                          ),
                                          body: Form(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 28.0,
                                                      vertical: 16),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Facility name',
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 2)),
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: DropdownButton<
                                                              String>(
                                                          isExpanded: true,
                                                          items: sites.map(
                                                              (String val) {
                                                            return new DropdownMenuItem<
                                                                String>(
                                                              value: val,
                                                              child:
                                                                  new Text(val),
                                                            );
                                                          }).toList(),
                                                          hint: Text(
                                                              "Please choose a location"),
                                                          onChanged:
                                                              (newVal) {}),
                                                    ),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: CupertinoButton(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          child: Text('Create'),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        )),
                                                  ]),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  title: Text(
                                    'new facility',
                                    style: GoogleFonts.roboto().copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  trailing: FaIcon(
                                    FontAwesomeIcons.plus,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                );
                              else
                                return ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(context, 'equipment');
                                  },
                                  title: Text(
                                    'facility $i',
                                    style: GoogleFonts.roboto().copyWith(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(
                                    'equipment count : 10',
                                    style: GoogleFonts.roboto().copyWith(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  trailing: FaIcon(
                                    FontAwesomeIcons.chevronRight,
                                    color: Colors.black,
                                  ),
                                );
                            }),
                      )
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
