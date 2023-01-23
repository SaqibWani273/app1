import 'dart:developer';

import 'package:app_for_publishing/screens/profile/profile_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/all_screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home/models/home_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeData(context),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileData(context),
        ),
      ],
      child: const MyApp(),
    ),
    debugShowCheckedModeBanner: false,
  ));
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
    log('main.dart build called');

    return GestureDetector(
      //to do :  detect  swipes

      onTap: () {
        log('gesture detector of main scaffold');
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: TabBarView(
          controller: _tabController,
          children: [
            Consumer<HomeData>(
              builder: (context, homeData, _) => Home(homeData),
            ),
            const Audios(),
            Consumer<ProfileData>(
              builder: (context, profileData, child) => const Profile(),
            ),
          ],
        ),
        bottomNavigationBar: myBottomNavigationBar(),
      ),
    );
  }

  Widget myBottomNavigationBar() {
    // listen :false is important bcz i only want
    // to update value and dont care about its effect
    final homeData = Provider.of<HomeData>(listen: false, context);
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
                onPressed: () {
                  _tabController.index = 0;

                  homeData.changeCurrentTab(_tabController.index);
                },
                icon: const Icon(Icons.home),
              ),
            ),
            Tab(
              icon: IconButton(
                iconSize: 40,
                tooltip: 'Audios',
                onPressed: () {
                  _tabController.index = 1;
                  homeData.changeCurrentTab(_tabController.index);
                },
                icon: const Icon(
                  Icons.music_note_outlined,
                ),
              ),
            ),
            Tab(
              icon: IconButton(
                iconSize: 40,
                tooltip: 'Profile',
                onPressed: () {
                  _tabController.index = 2;
                  homeData.changeCurrentTab(_tabController.index);
                },
                icon: const Icon(Icons.account_box_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
