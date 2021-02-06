import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skimscope/model/user_model.dart';
import 'package:skimscope/providers/user_provider.dart';

class AuthService {
  final db = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  // Signup
  Future<String> signup({
    @required String emailAddress,
    @required String userPassword,
    @required String name,
    @required BuildContext context,
  }) async {
    try {
      final email = emailAddress.trim().toLowerCase();
      final password = userPassword.trim();

      // Register user to firebase auth
      final res = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      var currentDateTime = Timestamp.now().toDate();
      var currentTimestamp = Timestamp.now();

      // save user data to firestore
      await db.doc('users/${res.user.uid}').set({
        'id': res.user.uid,
        'email': email,
        'name': name,
        'joiningDate': currentDateTime,
        'whenCreated': currentTimestamp,
        'isActive': true,
        'role': 'Admin',
      });

      UserModel user = UserModel(
        email: email,
        id: res.user.uid,
        name: name,
        joiningDate: currentDateTime,
        isActive: true,
        role: 'Admin',
        whenCreated: currentTimestamp,
        whenModified: null,
      );

      // save current user in user provider
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.user = user;

      return 'Signup Successful';
    } on PlatformException catch (err) {
      print('Error in signup: ${err.message}');
      return err.message;
    } catch (err) {
      print('Error in signup: ${err.toString()}');
      var message = 'Some error occured, please try again later';
      if (err != null && err.message != null) {
        message = err.message;
      }
      return message;
    }
  }

  // login
  Future<String> login({
    @required String userEmail,
    @required String userPassword,
    @required BuildContext context,
    String type = 'Employee',
  }) async {
    try {
      final email = userEmail.trim().toLowerCase();
      final password = userPassword.trim();

      // login
      var user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      // get user claims
      var claims = await firebaseAuth.currentUser.getIdTokenResult();
      if (claims.claims['isActive'] == false) {
        return 'Unauthorized';
      }

      // save user data to provider
      if (user != null) {
        var docSnapshot = await db.doc('users/${user.user.uid}').get();
        if (docSnapshot.exists && docSnapshot.data() != null) {
          UserModel userModel = UserModel.fromFirestore(docSnapshot);
          var userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.user = userModel;
        }
      }

      print('Login success: ${user.toString()}');
      return 'Login Successful';
    } on PlatformException catch (err) {
      return err.message ?? 'Some error occured, Please try again later';
    } catch (err) {
      var message = 'Some error occured, please try agian later';
      if (err != null && err.message != null) {
        message = err.message;
      }
      return message;
    }
  }

  // signout
  signout({@required BuildContext context}) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.user = null;
      await firebaseAuth.signOut();
    } catch (err) {
      print(err.toString());
      await firebaseAuth.signOut();
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.user = null;
      await firebaseAuth.signOut();
    }
  }
}
