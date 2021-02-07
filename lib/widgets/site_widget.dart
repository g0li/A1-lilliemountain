import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skimscope/model/sites_model.dart';

class SiteWidget extends StatefulWidget {
  SitesModel site;
  SiteWidget({Key key, this.site, this.onTap}) : super(key: key);
  final Function onTap;
  @override
  _SiteWidgetState createState() => _SiteWidgetState();
}

class _SiteWidgetState extends State<SiteWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(4.0),
          child: Material(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
                onTap: () {
                  setState(() {
                    // widget.isCurrent = !widget.site.isActive;
                    widget.onTap(widget.site);
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      widget.site.name[0],
                      style:
                          GoogleFonts.roboto(fontSize: 40, color: Colors.white),
                    ),
                  ),
                )),
          ),
        ),
        Text(
          widget.site.name,
          style: GoogleFonts.roboto(fontSize: 18, color: Colors.black),
        ),
      ],
    );
  }
}
