import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skimscope/services/auth_service.dart';
import 'package:skimscope/widgets/api_loader.dart';
import 'package:skimscope/widgets/input_formfield_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showLoader = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !showLoader,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Skimscope'),
          automaticallyImplyLeading: !showLoader,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/minilogo.png',
                height: 50,
                width: MediaQuery.of(context).size.width,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: InputFormField(
                        controller: emailController,
                        labelText: 'email',
                        keyboardType: TextInputType.emailAddress,
                        validatorFn: (String value) {
                          if (value.isEmpty) {
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
                        isPassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        validatorFn: (String value) {
                          print('called validator');
                          if (value.isEmpty) {
                            return 'password is required';
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(8),
                              child: CupertinoButton(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30),
                                child: Text('Sign In'),
                                onPressed: () {
                                  print(_formKey.currentState.validate());
                                  if (_formKey.currentState.validate()) {
                                    onLogin();
                                  }
                                  // Navigator.pushNamed(context, 'admin');
                                },
                              )),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(8),
                              child: CupertinoButton(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30),
                                child: Text('Temp Sign In Employee'),
                                onPressed: () {
                                  Navigator.pushNamed(context, 'employeeH');
                                },
                              )),
                          CupertinoButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'register');
                            },
                            child: Text(
                              'Sign UP',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
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

  // on login
  onLogin() async {
    FocusScope.of(context).unfocus();
    print('called');
    hideShowLoader(true);
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    String response = await authService.login(
        context: context, userEmail: email, userPassword: password);
    hideShowLoader(false);
    print(response);
    if (response != 'Login Successful') {
      this.showToast(response);
    } else {
      Navigator.pushNamed(context, 'admin');
    }
  }

  // show toast
  showToast(String message) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
