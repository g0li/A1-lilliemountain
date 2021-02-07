import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skimscope/model/user_model.dart';
import 'package:skimscope/providers/user_provider.dart';
import 'dart:convert';

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
      var message = 'Some error occured, please try agian later';
      if (err != null && err.message != null) {
        message = err.message;
      }
      return message;
    } catch (err) {
      var message = 'Some error occured, please try agian later';
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
      print(err.toString());
      var message = 'Some error occured, please try agian later';
      if (err != null && err.message != null) {
        message = err.message;
      }
      return message;
    } catch (err) {
      print(err.toString());
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

  // create employee account
  Future<String> createEmployeeAccount({
    @required String email,
    @required String password,
    @required String name,
    @required DateTime joiningDate,
  }) async {
    try {
      final HttpsCallable httpsCallable =
          FirebaseFunctions.instance.httpsCallable('addEmployeeAccount');

      dynamic res = await httpsCallable({
        'email': email,
        'password': password,
        'name': name,
        'joiningDate': joiningDate.toIso8601String(),
      });

      var result = res.data;
      print(result.toString());

      if (result['status'] == 1) {
        return 'User creation successful';
      } else {
        var errorMessage = 'Some error occured, please try again later';
        if (result != null &&
            result['error'] != null &&
            result['error']['errorInfo'] != null &&
            result['error']['errorInfo']['message'] != null) {
          errorMessage = result['error']['errorInfo']['message'];
        }
        return errorMessage;
      }
    } catch (err) {
      print('Error creating employee account: ${err.toString()}');
      return 'Some error occured, Please try again later';
    }
  }

  // change employee password
  Future<String> changeEmployeePassword({
    @required String userId,
    @required String password,
  }) async {
    try {
      final httpsCallable =
          FirebaseFunctions.instance.httpsCallable('changeEmpPassword');
      dynamic res = await httpsCallable(<String, dynamic>{
        'userId': userId,
        'password': password.trim(),
      });

      var result = res.data;
      print(result.toString());

      if (result['status'] == 1) {
        return 'Success';
      } else {
        return 'Some error occured, please try again later';
      }
    } catch (err) {
      print('Error in change password: ${err.toString()}');
      var errorMessage = 'Some error occured, please try again later';
      if (err != null &&
          err['error'] != null &&
          err['error']['errorInfo'] != null &&
          err['error']['errorInfo']['message'] != null) {
        errorMessage = err['error']['errorInfo']['message'];
      }
      print('Error in modify Employee account: ${err.toString()}');
      return errorMessage;
    }
  }

  // modify employee account (change status to active / inactive)
  Future<bool> modifyEmployeeAccount({
    @required bool isActive,
    @required String userId,
  }) async {
    try {
      final httpsCallable =
          FirebaseFunctions.instance.httpsCallable('modifyUser');
      dynamic res = await httpsCallable(<String, dynamic>{
        'userId': userId,
        'isActive': isActive,
      });

      var result = res.data;
      print(result.toString());

      if (result['status'] == 1) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print('Error in modify Employee account: ${err.toString()}');
      return false;
    }
  }

  // Get all users
  Stream<List<UserModel>> getAllEmployees() {
    try {
      var empRef = db
          .collection('users')
          .where('role', isEqualTo: 'Employee')
          .snapshots();
      var list = empRef.map(
          (d) => d.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
      return list;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  // Get all admins
  Stream<List<UserModel>> getAllAdmins() {
    try {
      var adminRef =
          db.collection('users').where('role', isEqualTo: 'Admin').snapshots();
      var list = adminRef.map(
          (d) => d.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
      return list;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
}
