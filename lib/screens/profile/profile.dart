import 'dart:developer';
import 'package:flutter/material.dart';

import 'profile_data.dart';

class Profile extends StatefulWidget {
  final ProfileData _profileData;
  const Profile(this._profileData, {super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  late RegExp _regExp;
  late Map textFieldMap;
  late String? password;

  @override
  Widget build(BuildContext context) {
    textFieldMap = widget._profileData.textFields;
    var deviceSize = MediaQuery.of(context).size;
    log('profile build');
    return Container(
      height: deviceSize.height,
      padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.2),
      //  color: Colors.green,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            Column(
              children: widget._profileData.textFields
                  .map(
                    (key, value) => MapEntry(
                      key,
                      Column(
                        children: [
                          TextFormField(
                            controller: widget
                                ._profileData.textFields[key]!['controller'],
                            validator: (textFieldValue) {
                              //check password=confirm password
                              if (key == 'password') {
                                password = textFieldValue;
                              } else if (key == 'confirmPassword' &&
                                  password != textFieldValue) {
                                return 'Passwords Do not Match';
                              }

                              //form validation using rexExp
                              if (textFieldValue == null ||
                                  !widget._profileData.regularExp[key]!
                                      .hasMatch(textFieldValue)) {
                                return widget._profileData
                                    .textFields[key]!['errorMessage'];
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: widget
                                  ._profileData.textFields[key]!['hintText'],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    // widget.appState.signOut();
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget._profileData.signUp();
                      log('form validated');
                    }
                  },
                  icon: const Icon(Icons.lock_outline_rounded),
                  label: const Text('Sign Up'),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
