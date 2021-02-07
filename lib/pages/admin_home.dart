import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skimscope/model/facilities_model.dart';
import 'package:skimscope/model/sites_model.dart';
import 'package:skimscope/providers/site_provider.dart';
import 'package:skimscope/services/equipment_service.dart';
import 'package:skimscope/services/facility_service.dart';
import 'package:skimscope/services/site_service.dart';
import 'package:skimscope/widgets/site_widget.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  GlobalKey<ScaffoldState> adminKey =
      GlobalKey<ScaffoldState>(debugLabel: 'aK');

  SitesModel currentSite;
  SiteProvider provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SiteProvider>(context);
    return Scaffold(
      key: adminKey,
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
          child: Padding(
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
            (provider.allSites.length < 1)
                ? Container(
                    height: 120,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, i) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade50,
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(4.0),
                                  child: Material(
                                    color: Color(0xFFF28F3B),
                                    borderRadius: BorderRadius.circular(20),
                                    child: InkWell(
                                        onTap: () {},
                                        borderRadius: BorderRadius.circular(20),
                                        child: SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '',
                                              style: GoogleFonts.roboto(
                                                  fontSize: 40,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  )
                : Container(
                    height: 120,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.allSites.length + 1,
                        itemBuilder: (context, i) {
                          if (i == provider.allSites.length)
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Material(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                    child: InkWell(
                                        onTap: () {
                                          newSite(context);
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        child: SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '+ ',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 40,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            );
                          else
                            return SiteWidget(
                                site: provider.allSites[i],
                                onTap: (cs) {
                                  setState(() {
                                    currentSite = cs;
                                  });
                                });
                        }),
                  ),
            Text(
              'Facilities',
              style: GoogleFonts.roboto().copyWith(
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor,
                  fontSize: 24),
            ),
            StreamBuilder<List<FacilitesModel>>(
                stream: FacilityService().getAllFacilities(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Text('Something went wrong');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container(
                        height: 120,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, i) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade50,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                ),
                              );
                            }),
                      );
                    default:
                      List<FacilitesModel> facilities = snapshot.data;
                      List<FacilitesModel> currentSiteData = [];
                      for (var item in facilities) {
                        if (currentSite != null) if (item.site.name
                            .contains(currentSite.name))
                          currentSiteData.add(item);
                      }
                      return Container(
                        height: 700,
                        child: ListView.builder(
                            primary: false,
                            itemCount: currentSiteData.length + 1,
                            itemBuilder: (context, i) {
                              if (i == currentSiteData.length)
                                return ListTile(
                                  onTap: () {
                                    newFacility(context);
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
                                    Navigator.pushNamed(context, 'equipment',
                                        arguments: currentSiteData[i]);
                                  },
                                  title: Text(
                                    currentSiteData[i].name,
                                    style: GoogleFonts.roboto().copyWith(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: StreamBuilder<int>(
                                      stream: EquipmentService()
                                          .getEquipmentCount(
                                              currentSiteData[i]),
                                      builder: (context, snapshotI) {
                                        if (snapshotI.hasError) return Text('');
                                        switch (snapshotI.connectionState) {
                                          case ConnectionState.waiting:
                                            return Shimmer.fromColors(
                                              child: Text(
                                                'equipment count :',
                                                style: GoogleFonts.roboto()
                                                    .copyWith(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                              ),
                                              baseColor: Colors.grey.shade300,
                                              highlightColor:
                                                  Colors.grey.shade50,
                                            );
                                            break;
                                          default:
                                            return Text(
                                              'equipment count : ${snapshotI.data}',
                                              style: GoogleFonts.roboto()
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontSize: 14),
                                            );
                                        }
                                      }),
                                  trailing: FaIcon(
                                    FontAwesomeIcons.chevronRight,
                                    color: Colors.black,
                                  ),
                                );
                            }),
                      );
                  }
                })
          ],
        ),
      )),
    );
  }

  newSite(context) {
    TextEditingController controller = TextEditingController();
    GlobalKey<FormState> siteFormKey = GlobalKey<FormState>();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('New site'),
          ),
          body: Form(
            key: siteFormKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                          controller: controller,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.trim().isEmpty)
                              return 'Please enter site name';
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'site name',
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
                            // Navigator.pop(context);
                            if (siteFormKey.currentState.validate()) {
                              SiteService()
                                  .createSite(
                                      name: controller.text,
                                      createdBy:
                                          FirebaseAuth.instance.currentUser.uid)
                                  .then((value) {
                                if (MediaQuery.of(context).viewInsets.bottom !=
                                    0) Navigator.pop(context);
                                value
                                    ? adminKey.currentState
                                        .showSnackBar(SnackBar(
                                          content: Text('Site added',
                                              style: GoogleFonts.roboto()
                                                  .copyWith(
                                                      color: Colors.green)),
                                          backgroundColor:
                                              Colors.lightGreen.shade100,
                                        ))
                                        .closed
                                        .then((value) =>
                                            Navigator.pop(context)) //issue here
                                    : adminKey.currentState
                                        .showSnackBar(SnackBar(
                                          content: Text('Something went wrong',
                                              style: GoogleFonts.roboto()
                                                  .copyWith(color: Colors.red)),
                                          backgroundColor: Colors.red.shade100,
                                        ))
                                        .closed
                                        .then((value) => Navigator.pop(
                                            context)); //issue here
                              });
                            }
                          },
                        )),
                  ]),
            ),
          ),
        );
      },
    );
  }

  newFacility(context) {
    SitesModel currentSiteBS = provider.allSites.first;
    TextEditingController controller = TextEditingController();
    GlobalKey<FormState> facilityFormKey = GlobalKey<FormState>();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setstate) => Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text('New Facility'),
            ),
            body: Form(
              key: facilityFormKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: controller,
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Please enter Facility name.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Facility name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2)),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<SitesModel>(
                            isExpanded: true,
                            items: provider.allSites.map((SitesModel val) {
                              return DropdownMenuItem<SitesModel>(
                                value: val,
                                child: Text(val.name),
                              );
                            }).toList(),
                            value: currentSiteBS,
                            onChanged: (newVal) {
                              setstate(() {
                                currentSiteBS = newVal;
                              });
                            }),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(8),
                          child: CupertinoButton(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30),
                            child: Text('Create'),
                            onPressed: () {
                              // Navigator.pop(context);
                              if (facilityFormKey.currentState.validate()) {
                                FacilityService()
                                    .createFacility(
                                        site: currentSiteBS,
                                        name: controller.text,
                                        createdBy: FirebaseAuth
                                            .instance.currentUser.uid)
                                    .then((value) {
                                  if (MediaQuery.of(context)
                                          .viewInsets
                                          .bottom !=
                                      0) Navigator.pop(context);
                                  value
                                      ? adminKey.currentState
                                          .showSnackBar(SnackBar(
                                            content: Text('Facility added',
                                                style: GoogleFonts.roboto()
                                                    .copyWith(
                                                        color: Colors.green)),
                                            backgroundColor:
                                                Colors.lightGreen.shade100,
                                          ))
                                          .closed
                                          .then((value) => Navigator.pop(
                                              context)) //issue here
                                      : adminKey.currentState
                                          .showSnackBar(SnackBar(
                                            content: Text(
                                                'Something went wrong',
                                                style: GoogleFonts.roboto()
                                                    .copyWith(
                                                        color: Colors.red)),
                                            backgroundColor:
                                                Colors.red.shade100,
                                          ))
                                          .closed
                                          .then((value) => Navigator.pop(
                                              context)); //issue here
                                });
                              }
                            },
                          )),
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
