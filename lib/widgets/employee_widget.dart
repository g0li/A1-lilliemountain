import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:skimscope/model/user_model.dart';
import 'package:skimscope/services/auth_service.dart';

class EmployeeWidget extends StatefulWidget {
  final Function onTap;
  final UserModel user;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const EmployeeWidget({
    Key key,
    this.onTap,
    @required this.user,
    @required this.scaffoldKey,
  }) : super(key: key);
  @override
  _EmployeeWidgetState createState() => _EmployeeWidgetState();
}

class _EmployeeWidgetState extends State<EmployeeWidget> {
  final df = new DateFormat('dd/MM/yyyy');
  bool val = true;
  bool showLoader = false;
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      trailing: CupertinoSwitch(
          value: val,
          onChanged: showLoader
              ? null
              : (_) async {
                  var changeStatus = await onEditEmployee();
                  setState(() {
                    val = changeStatus ? _ : !_;
                  });
                }),
      leading: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              'https://via.placeholder.com/80.png',
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
              widget.user.name,
              style: GoogleFonts.roboto().copyWith(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                widget.user.email,
                style: GoogleFonts.roboto().copyWith(
                  fontSize: 12,
                  color: Colors.black,
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'joining date : ${df.format(widget.user.joiningDate.toDate())}',
              style: GoogleFonts.roboto().copyWith(
                  fontSize: 12,
                  color: Color(0xFF5C5C5C),
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  // hide show loader
  hideShowLoader(bool val) {
    setState(() {
      showLoader = val;
    });
  }

  // show toast
  showToast(String message) {
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  // on create
  Future<bool> onEditEmployee() async {
    hideShowLoader(true);
    var res = await authService.modifyEmployeeAccount(
      isActive: !widget.user.isActive,
      userId: widget.user.id,
    );
    if (!res) {
      showToast('Some error occured, please try again later');
      return false;
    }
    hideShowLoader(false);
    return true;
  }
}
