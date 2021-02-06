import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skimscope/services/auth_service.dart';
import 'package:skimscope/widgets/api_loader.dart';
import 'package:skimscope/widgets/input_formfield_widget.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showLoader = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !showLoader,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Register'),
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
                        controller: nameController,
                        labelText: 'name',
                        keyboardType: TextInputType.visiblePassword,
                        validatorFn: (String value) {
                          if (value.isEmpty) {
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
                        keyboardType: TextInputType.visiblePassword,
                        validatorFn: (String value) {
                          if (value.isEmpty) {
                            return 'password is required';
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
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(8),
                          child: CupertinoButton(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30),
                            child: Text('Sign Up'),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                onSignup();
                              }
                            },
                          )),
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

  onSignup() async {
    FocusScope.of(context).unfocus();
    hideShowLoader(true);
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = passwordController.text.trim();

    String response = await authService.signup(
      context: context,
      emailAddress: email,
      userPassword: password,
      name: name,
    );
    hideShowLoader(false);
    print(response);
    if (response != 'Signup Successful') {
      this.showToast(response);
    } else {
      Navigator.pushNamed(context, 'admin');
    }
  }

  showToast(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
