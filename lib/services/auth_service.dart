import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AuthService {
  final db = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  // Signup
  Future<String> signup({
    @required String emailAddress,
    @required String userPassword,
    @required String name,
  }) async {
    try {
      final email = emailAddress.trim().toLowerCase();
      final password = userPassword.trim();

      // Register user to firebase auth
      final res = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      // save user data to firestore
      await db.doc('users/${res.user.uid}').set({
        'id': res.user.uid,
        'email': email,
        'name': name,
        'joiningDate': Timestamp.now(),
        'whenCreated': Timestamp.now(),
        'isActive': true,
        'role': 'Admin',
      });

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
    String type = 'Employee',
  }) async {
    try {
      final email = userEmail.trim().toLowerCase();
      final password = userPassword.trim();

      // login
      var user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      // get user claims

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
  signout() async {
    await firebaseAuth.signOut();
  }
}
