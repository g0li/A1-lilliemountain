import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SiteWidget extends StatefulWidget {
  bool isActive;
  final String siteName;
  SiteWidget({Key key, this.isActive = false, this.siteName}) : super(key: key);

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
            color: !widget.isActive
                ? Theme.of(context).primaryColor
                : Color(0xFFF28F3B),
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
                onTap: () {
                  setState(() {
                    widget.isActive = !widget.isActive;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      widget.siteName[0],
                      style: GoogleFonts.roboto(
                          fontSize: 40,
                          color:
                              !widget.isActive ? Colors.black : Colors.white),
                    ),
                  ),
                )),
          ),
        ),
        Text(
          widget.siteName,
          style: GoogleFonts.roboto(fontSize: 18, color: Colors.black),
        ),
      ],
    );
  }
}
