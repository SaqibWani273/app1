import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../widgets/my_video_player.dart';

class HomeData extends ChangeNotifier {
  BuildContext context;
  HomeData(this.context);
  //appIcon used in appbar on top
  String appIcon = 'assets/images/app_icon.jpg';
  String thumbnaiImage = 'assets/images/ab_lateef_bhat_modern_ss.png';
  int currentTabIndex = 0;
  List<Map<String, String>> videosListMap = [];
  List<Map<String, String>> searchVideosListMap = [];
  late Map<String, Map> completeVideosList;
  late OverlayState myOverlayState;
  OverlayEntry? notificationsEntry;
  var nOfNotifications = 1;
  //var deviceSize=MediaQuery.of(context).size;

  //categories in drawer of home tab
  String currentCategory = 'Home';
  changeCurrentTab(int index) {
    currentTabIndex = index;
    notifyListeners();
  } //changeCurrentTab()

  Future<List<Map<String, String>>> videosData() async {
    try {
      log('future videosData()');
      DatabaseReference ref =
          FirebaseDatabase.instance.ref('completeVideosList');
      final dataAtRef = await ref.get();

      //casting data response to Map
      completeVideosList = Map<String, Map>.from(
        dataAtRef.value! as Map<Object?, Object?>,
      );
      //deep casting and traversing to get the actual data
      setVideosListMap();
    } catch (e) {
      print('error in firebase data fetching/videosData() function');
    }
    return videosListMap;
  } //videosData()

  setVideosListMap() {
    videosListMap = [];
    completeVideosList.forEach(
      (categoryType, categoryMap) {
        categoryMap.forEach((userId, value) {
          // List<Map> videosList = value as List<Map>;
          // print(videosList.length);
          final userMap = Map<String, Map>.from(value);
          userMap.forEach((videoId, value) {
            // List<String> videosUrl = videoMap['videoUrl'];
            // print('${videoMap.toString()} ......................');
            final videoMap = Map<String, String>.from(value);
            videosListMap.add(videoMap);
          });
        });
      },
    );
  } //setVideosListMap()

  // list of listTiles data
  final List<Map<String, dynamic>> listTiles = [
    {
      'title': 'Home',
      'filledIcon': Icons.home_filled,
      'outlinedIcon': Icons.home_outlined
    },
    {
      'title': 'Category A',
      'filledIcon': Icons.category_sharp,
      'outlinedIcon': Icons.category_outlined,
    },
    {
      'title': 'Category B',
      'filledIcon': Icons.access_time_filled,
      'outlinedIcon': Icons.access_time_outlined,
    },
    {
      'title': 'Category C',
      'filledIcon': Icons.document_scanner_sharp,
      'outlinedIcon': Icons.document_scanner_outlined,
    },
    {
      'title': 'Category D',
      'filledIcon': Icons.cloud_done_sharp,
      'outlinedIcon': Icons.cloud_done_outlined,
    },
    {
      'title': 'Category E',
      'filledIcon': Icons.sms_rounded,
      'outlinedIcon': Icons.sms_outlined,
    },
  ]; //list listTiles
// to change category in drawer
  void changeCategory(String selectedCategory) {
    currentCategory = selectedCategory;
    //if category == home get all the videos
    if (selectedCategory == 'Home') {
      setVideosListMap();
    }
    // else get the particular category videos
    else {
      videosListMap = [];

      Map selectedMapCategory = completeVideosList['$selectedCategory']!;
      selectedMapCategory.forEach((userId, value) {
        // List<Map> videosList = value as List<Map>;

        final userMap = Map<String, Map>.from(value);
        userMap.forEach((videoId, value) {
          // List<String> videosUrl = videoMap['videoUrl'];

          final videoMap = Map<String, String>.from(value);
          videosListMap.add(videoMap);
        });
      });
    }

    notifyListeners();
  } // changeCategory

  searchForVideos(String data, BuildContext context) {
    searchVideosListMap = [];

    //searching from firebase result
    completeVideosList.forEach(
      (categoryType, categoryMap) {
        categoryMap.forEach((userId, value) {
          // List<Map> videosList = value as List<Map>;
          // print(videosList.length);
          final userMap = Map<String, Map>.from(value);
          userMap.forEach((videoId, value) {
            // List<String> videosUrl = videoMap['videoUrl'];
            // print('${videoMap.toString()} ......................');
            final videoMap = Map<String, String>.from(value);
            if (videoMap['description']!.contains(
                  RegExp(data, caseSensitive: false),
                ) ||
                videoMap['category']!.contains(
                  RegExp(data, caseSensitive: false),
                )) {
              searchVideosListMap.add(videoMap);
            }
          });
        });
      },
    );
    if (searchVideosListMap.isNotEmpty) {
      videosListMap = searchVideosListMap;
    } else {
      //to do :
      //maybe show a no data found screen instead of snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No Data found !'),
        ),
      );
    }

    notifyListeners();
  } //searchForVideos()

  notificationsOverlay(BuildContext context) {
    myOverlayState = Overlay.of(context)!;
    notificationsEntry = OverlayEntry(
      builder: ((context) {
        log('entry1');
        final deviceHeight = MediaQuery.of(context).size.height;
        final deviceWidth = MediaQuery.of(context).size.width;
        return Positioned(
            left: deviceWidth * 0.1,
            top: deviceHeight * 0.1,
            right: deviceWidth * 0.1,
            height: deviceHeight * 0.8,
            // width: deviceWidth * 0.6,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Container(
                color: Colors.white,
                child: ListView(
                  children: videosListMap
                      .asMap()
                      .map((index, videoMap) => MapEntry(
                            index,
                            Material(
                              child: GestureDetector(
                                onTap: () {
                                  notificationsEntry?.remove();
                                  notificationsEntry = null;
                                  //to do :  change here
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MyVideoPlayer(
                                        videosListMap[index],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  color: index % 2 == 0
                                      ? Colors.grey[50]
                                      : Colors.white,
                                  child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          videoMap['imageUrl']!,
                                        ),
                                      ),
                                      title: Text(videoMap['description']!),
                                      trailing: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 40),
                                            child: Image.network(
                                                videoMap['imageUrl']!),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.more_vert),
                                            onPressed: (() {
                                              log('popup menu');
                                              //to do: show popup menu

                                              PopupMenuButton(
                                                //  position: PopupMenuPosition.,
                                                itemBuilder: ((context) => [
                                                      PopupMenuItem(
                                                        child: TextButton(
                                                          child:
                                                              Text('button1'),
                                                          onPressed: (() {
                                                            log('button 1 in notifications');
                                                          }),
                                                        ),
                                                      ),
                                                      PopupMenuItem(
                                                        child: TextButton(
                                                          child:
                                                              Text('button2'),
                                                          onPressed: (() {
                                                            log('button 2 in notifications');
                                                          }),
                                                        ),
                                                      ),
                                                    ]),
                                              );
                                            }),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ),
                          ))
                      .values
                      .toList(),
                ),
              ),
            ));
      }),
    );
    myOverlayState.insert(notificationsEntry!);
  }
}
