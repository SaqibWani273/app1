import 'package:app_for_publishing/screens/home/home_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/all_screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: ChangeNotifierProvider(
      //now anyone  in myapp who is interested in homedata
      //can become a consumer of it
      create: (context) => HomeData(context),
      child: MyApp(),
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
    print('mzin.dart build called');
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          deviceWidth,
          deviceHeight * 0.08,
        ), //Size.fromHeight(55.0),
        child: Consumer<HomeData>(
          builder: (context, homeData, child) => MyAppBar(
            context,
            appBarHeight: deviceHeight * 0.08,
            appBarWidth: deviceWidth,
            currentTab: _tabController,
            homeData: homeData,
          ),
        ),
      ),
      drawer: SizedBox(
        width: deviceWidth * 0.6,
        child: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
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
