import 'dart:developer';
import 'package:flutter/material.dart';

import 'profile_data.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final ProfileData _profileData = ProfileData();
  @override
  Widget build(BuildContext context) {
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
              children: _profileData.textFields
                  .map(
                    (key, value) => MapEntry(
                      key,
                      Column(
                        children: [
                          TextFormField(
                            controller: _profileData.textFields[key]
                                ['controller'],
                            validator: (value) {
                              if (value == null ||
                                  value.length <
                                      _profileData.textFields[key]
                                          ['minLength']) {
                                return _profileData.textFields[key]
                                    ['errorMessage'];
                                //   return 'error';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: _profileData.textFields[key]
                                  ['hintText'],
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
                    log('signup pressed');
                    if (_formKey.currentState!.validate() &&
                        password.text == confirmPassword.text)
                    //to do here...
                    //  show snackbar if passwords do not match
                    {
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
