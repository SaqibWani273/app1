import 'package:flutter/material.dart';

final TextEditingController email = TextEditingController();
final TextEditingController password = TextEditingController();
final TextEditingController userName = TextEditingController();
final TextEditingController confirmPassword = TextEditingController();

class ProfileData extends ChangeNotifier {
  Map textFields = {
    'userName': {
      'hintText': 'Enter Username',
      'minLength': 9,
      'errorMessage': 'Enter Proper Username',
      'controller': userName
    },
    'email': {
      'hintText': 'Enter  Email',
      'minLength': 10,
      'errorMessage': 'Enter a Valid email address',
      'controller': email,
    },
    'password': {
      'hintText': 'Enter Password',
      'minLength': 10,
      'errorMessage': 'Enter a Strong Password',
      'controller': password,
    },
    'confirmPassword': {
      'hintText': 'Confirm Password',
      'minLength': 10,
      'errorMessage': 'Passwords Do not Match',
      'controller': confirmPassword,
    },
  };
}
