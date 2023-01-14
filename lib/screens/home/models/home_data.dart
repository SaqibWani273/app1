import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeData extends ChangeNotifier {
  HomeData(BuildContext context);
  //appIcon used in appbar on top
  String appIcon = 'assets/images/app_icon.jpg';
  String thumbnaiImage = 'assets/images/ab_lateef_bhat_modern_ss.png';
  int currentTabIndex = 0;
  //categories in drawer of home tab
  String currentCategory = 'Home';
  changeCurrentTab(int index) {
    currentTabIndex = index;
    notifyListeners();
  } //changeCurrentTab()

  List<Map<String, String>> videosListMap = [];
  List<Map<String, String>> searchVideosListMap = [];
  late Map<String, Map> completeVideosList;
  Future<List<Map<String, String>>> videosData() async {
    try {
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
  }
}
