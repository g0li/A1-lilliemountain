import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Skimscope')),
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
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'password',
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
                      child: Text('Sign In'),
                      onPressed: () {
                        Navigator.pushNamed(context, 'admin');
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
            )),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
