import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileData extends ChangeNotifier {
  final BuildContext context;
  ProfileData(this.context) {
    init(context);
  }
  static final TextEditingController email = TextEditingController();
  static final TextEditingController password = TextEditingController();
  static final TextEditingController userName = TextEditingController();
  static final TextEditingController confirmPassword = TextEditingController();

//regular Wxpression Map for from validations
  Map<String, RegExp> regularExp = {
    //starts with letter ,min. 8 chars and containing only
    //letters ,digits and _
    'userName': RegExp(r'^[A-Za-z][A-Za-z0-9_]{7,29}$'),
    //alphabets123@azAz123.cdd
    'email': RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]"),
    // ?=. means must have
    'password': RegExp(r"(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]){7,}"),
    'confirmPassword': RegExp(r"(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]){7,}"),
  };
  Map<String, Map> textFields = {
    'userName': {
      'hintText': 'Enter Username',
      'errorMessage': 'Min 8-char with underscore , digits & letters only',
      'controller': userName,
    },
    'email': {
      'hintText': 'Enter  Email',
      'errorMessage': 'Enter a Valid email address',
      'controller': email,
    },
    'password': {
      'hintText': 'Enter Password',
      'errorMessage': 'Min. 8-chars with atleast 1 upper case and 1 digit',
      'controller': password,
    },
    'confirmPassword': {
      'hintText': 'Confirm Password',
      'errorMessage': '',
      'controller': confirmPassword,
    },
  };
  String userState = 'loading';
  late UserCredential newUser;

//called by constructor
  Future<void> init(BuildContext context) async {
    //FirebaseAuth.instance.currentUser?.delete();
    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user == null) {
        userState = 'null';
      } else {
        //without reloading firebase doesnot automatically
        //update isemailVerified status

        await user.reload();
        if (user.emailVerified) {
          //send to login screen
          log('email verified');
          userState = 'loggedOut';
        } else if (!user.emailVerified) {
          //send to emailVerification screen
          log('email not verified ${user.toString()}');
          //  log(FirebaseAuth.instance.currentUser.toString());
          userState = 'emailNotVerified';
        }
      }

      notifyListeners();
    });
  }

  Future<void> signUp() async {
    newUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.text,
      password: password.text,
    );
    // log(newUser.toString());
    // await newUser.user?.sendEmailVerification();
    // await newUser.user?.reload();
    // if (newUser.user!.emailVerified) {
    //   await FirebaseAuth.instance.signInWithCredential(
    //     newUser.credential!,
    //   );
    //   log('isSignedIn = $isSignedIn ${newUser.user.toString()}');
    //   isSignedIn = true;
    //   notifyListeners();
    // }
  }

  Future<void> verifyEmail() async {
    log(FirebaseAuth.instance.currentUser.toString());
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }

  Future<void> delete() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      userState = 'null';
    } on FirebaseAuthException catch (exception) {
      log('firebaseAuth error=${exception.code}');
    } catch (e) {
      log(e.toString());
    }
  }
}
