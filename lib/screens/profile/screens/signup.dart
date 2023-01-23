import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../profile_data.dart';

class SingUp extends StatefulWidget {
  const SingUp({super.key});

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  late final ProfileData _profileData;
  final _formKey = GlobalKey<FormState>();
  late Map textFieldMap;
  late String? password;
  @override
  Widget build(BuildContext context) {
    _profileData = Provider.of<ProfileData>(context, listen: false);
    textFieldMap = _profileData.textFields;
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
          child: Column(
        children: [
          TextButton(
            onPressed: _profileData.delete,
            child: Text("delete"),
          ),
        ],
      )),
      body: Container(
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
                              controller:
                                  _profileData.textFields[key]!['controller'],
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
                                    !_profileData.regularExp[key]!
                                        .hasMatch(textFieldValue)) {
                                  return _profileData
                                      .textFields[key]!['errorMessage'];
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                hintText:
                                    _profileData.textFields[key]!['hintText'],
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Creating Account ... !'),
                          ),
                        );
                        FocusManager.instance.primaryFocus?.unfocus();
                        _profileData.signUp();
                        log('form validated');
                        VerifyEmail();
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
      ),
    );
  }
}

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    final _profileData = Provider.of<ProfileData>(context, listen: false);
    return Container(
        child: AlertDialog(
      title: const Center(
        child: Text(
          'Verify Your Email !',
          style: TextStyle(fontSize: 24),
        ),
      ),
      content: Text(
        "we'll send a email confirmation link to the email address provided",
        style: TextStyle(fontSize: 18),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                _profileData.delete();
              },
              child: Text('cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _profileData.verifyEmail();
              },
              child: Text('ok'),
            ),
          ],
        )
      ],
    ));
  }
}
