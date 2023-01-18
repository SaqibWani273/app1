import 'dart:developer';

import 'package:flutter/material.dart';

class ProfileData extends ChangeNotifier {
  final BuildContext context;
  ProfileData(this.context);
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
  Future<void> signUp() async {
    log(
      'Details Received :\nEmail=${email.text},username=${userName.text},password=${password.text}',
    );
  }
}
