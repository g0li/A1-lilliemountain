import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:skimscope/model/user_model.dart';
import 'package:skimscope/services/auth_service.dart';
import 'package:skimscope/services/common_service.dart';
import 'package:skimscope/widgets/api_loader.dart';
import 'package:skimscope/widgets/employee_widget.dart';
import 'package:skimscope/widgets/input_formfield_widget.dart';

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final authService = AuthService();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Employee workforce'),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.home),
            onPressed: () {
              // Navigator.pushNamed(context, 'employee');
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createEdit();
        },
        backgroundColor: Color(0xFFC8553D),
        child: FaIcon(
          FontAwesomeIcons.plus,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<List<UserModel>>(
          stream: authService.getAllEmployees(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.toString());
              return Center(
                child: Text('Unable to load employees, Please try again later'),
              );
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: ApiLoader(),
                );
              default:
                List<UserModel> userList = snapshot.data;
                return (userList != null && userList.length > 0)
                    ? ListView.separated(
                        itemBuilder: (context, i) => EmployeeWidget(
                          scaffoldKey: _scaffoldKey,
                          onTap: () {
                            createEdit(mode: 'edit');
                          },
                          user: userList[i],
                        ),
                        separatorBuilder: (context, i) => Divider(),
                        itemCount: userList.length,
                      )
                    : Center(
                        child: Text('No Employees found. Create to see one.'),
                      );
            }
          }),
    );
  }

  createEdit({String mode = 'create'}) {
    newMethod(mode);
  }

  Future newMethod(String mode) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) {
          return EmployeeCreate(
            mode: mode,
            scaffoldKey: _scaffoldKey,
          );
        }).then((resp) {
      if (resp != null) {
        showToast(resp);
      }
    });
  }

  // show toast
  showToast(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

class EmployeeCreate extends StatefulWidget {
  final String mode;
  final GlobalKey<ScaffoldState> scaffoldKey;
  EmployeeCreate({this.mode = 'create', @required this.scaffoldKey});

  @override
  _EmployeeCreateState createState() => _EmployeeCreateState();
}

class _EmployeeCreateState extends State<EmployeeCreate> {
  final authService = AuthService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final df = new DateFormat('dd/MM/yyyy');
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final joiningDateController = TextEditingController();
  bool showLoader = false;
  DateTime jd;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: !showLoader,
          title: Text('New Employee'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.mode != 'create')
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          height: 200,
                          child: FaIcon(
                            FontAwesomeIcons.camera,
                            color: Colors.grey,
                            size: 50,
                          ),
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://via.placeholder.com/500.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: InputFormField(
                        controller: nameController,
                        labelText: 'name',
                        keyboardType: TextInputType.text,
                        validatorFn: (String val) {
                          if (val.trim().isEmpty) {
                            return 'name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: InputFormField(
                        controller: emailController,
                        labelText: 'email',
                        keyboardType: TextInputType.emailAddress,
                        validatorFn: (String val) {
                          if (val.trim().isEmpty) {
                            return 'email is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: InputFormField(
                        controller: passwordController,
                        labelText: 'password',
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: true,
                        validatorFn: (String val) {
                          if (val.trim().isEmpty) {
                            return 'password is required';
                          }
                          if (val.trim().length < 6) {
                            return 'Minimum password length must be 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: InputFormField(
                        controller: joiningDateController,
                        labelText: 'joining date',
                        onTapFn: onSelectDate,
                        readOnly: true,
                        validatorFn: (String val) {
                          if (val.trim().isEmpty) {
                            return 'joining date is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    if (showLoader)
                      Center(
                        child: ApiLoader(),
                      ),
                    if (!showLoader)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(8),
                        child: CupertinoButton(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                          child: Text('Create'),
                          onPressed: () {
                            onCreateEmployee(context);
                          },
                        ),
                      ),
                  ]),
            ),
          ),
        ),
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
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  onSelectDate() async {
    try {
      final commonService = CommonServices();
      var date = await commonService.pickDate(context: context);
      print(date.weekday);
      setState(() {
        this.jd = date;
        joiningDateController.text = df.format(date);
      });
      print(date);
    } catch (err) {
      print(err.toString());
    }
  }

  // on create
  onCreateEmployee(BuildContext ctx) async {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      hideShowLoader(true);
      var email = emailController.text.trim();
      var password = passwordController.text;
      var name = nameController.text;

      var response = await authService.createEmployeeAccount(
        email: email,
        joiningDate: jd,
        name: name,
        password: password,
      );

      hideShowLoader(false);
      print('response');
      if (response == 'Success') {
        // success
        _formKey.currentState.reset();
        Navigator.pop(context);
      } else {
        Navigator.pop(context, response);
      }
    }
  }
}
