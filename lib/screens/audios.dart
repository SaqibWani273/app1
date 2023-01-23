import 'dart:developer';

import 'package:flutter/material.dart';

class Audios extends StatefulWidget {
  const Audios({super.key});

  @override
  State<Audios> createState() => _AudiosState();
}

class _AudiosState extends State<Audios> {
  @override
  Widget build(BuildContext context) {
    log('audios build');
    return Scaffold(
      body: Container(
          child: Center(
        child: Text("Audios"),
      )),
    );
  }
}
