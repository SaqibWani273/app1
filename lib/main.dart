import 'package:flutter/material.dart';

import 'screens/all_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

//singleTicker... is for animation
class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  //this => _MyAppState class
  late final _tabController = TabController(length: 3, vsync: this);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Home(),
            Audios(),
            Profile(),
          ],
        ),
        bottomNavigationBar: myBottomNavigationBar(),
      ),
    );
  }

  Widget myBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: TabBar(
          labelColor: Colors.black,
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              //icon: Icon(Icons.home),
              icon: IconButton(
                iconSize: 40,
                tooltip: 'Home',
                onPressed: () => _tabController.index = 0,
                icon: const Icon(Icons.home),
              ),
            ),
            Tab(
              icon: IconButton(
                iconSize: 40,
                tooltip: 'Audios',
                onPressed: () => _tabController.index = 1,
                icon: const Icon(
                  Icons.music_note_outlined,
                ),
              ),
            ),
            Tab(
              icon: IconButton(
                iconSize: 40,
                tooltip: 'Profile',
                onPressed: () => _tabController.index = 2,
                icon: const Icon(Icons.account_box_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
