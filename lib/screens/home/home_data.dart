//import 'dart:html';

// import 'dart:js';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeData extends ChangeNotifier {
  HomeData(BuildContext context);
  //appIcon used in appbar on top
  String appIcon = 'assets/images/app_icon.jpg';
  String thumbnaiImage = 'assets/images/ab_lateef_bhat_modern_ss.png';
  int currentTabIndex = 0;
  String currentCategory = 'home';
  changeCurrentTab(int index) {
    currentTabIndex = index;
    notifyListeners();
  }

  List<Map<String, String>> videosListMap = [];
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
      setVideosListMap(completeVideosList);
    } catch (e) {
      print('error in firebase data fetching/videosData() function');
    }
    return videosListMap;
  }

  setVideosListMap(Map<String, Map> completeVideosList) {
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
  }

  //my custom icon
  IconData MyIcon(String iconName) {
    switch (iconName) {
      case 'home':
        {
          if (currentCategory == 'home') {
            return Icons.home_sharp;
          } else {
            return Icons.home_outlined;
          }
        }
      case 'Category A':
        {
          if (currentCategory == 'Category A') {
            return Icons.video_collection_sharp;
          } else {
            return Icons.video_collection_outlined;
          }
        }
      case 'Category B':
        {
          if (currentCategory == 'Category B') {
            return Icons.speaker_group_sharp;
          } else {
            return Icons.speaker_group_outlined;
          }
        }
      case 'Category C':
        {
          if (currentCategory == 'Category C') {
            return Icons.ac_unit_sharp;
          } else {
            return Icons.ac_unit_outlined;
          }
        }
      case 'Category D':
        {
          if (currentCategory == 'Category D') {
            return Icons.access_time_filled_rounded;
          } else {
            return Icons.access_time_outlined;
          }
        }
      case 'Category E':
        {
          if (currentCategory == 'Category E') {
            return Icons.broken_image_sharp;
          } else {
            return Icons.broken_image_outlined;
          }
        }

      default:
        return Icons.abc_sharp;
    }
  }

  // listtile in drawer
  GestureDetector MyListTile<Widget>(String category, context) {
    return GestureDetector(
      onTap: () => changeCategory(category, context),
      child: ListTile(
        shape: currentCategory == category
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(width: 0.4),
              )
            : null,
        selected: currentCategory == category ? true : false,
        selectedTileColor: Colors.white70,
        leading: Icon(
          MyIcon(category),
          color: currentCategory == category ? Colors.black : Colors.black87,
        ),
        title: Text(
          category,
          style: TextStyle(
            color: currentCategory == category ? Colors.black : Colors.black87,
          ),
        ),
      ),
    );
  }

// to change category in drawer
  changeCategory(String selectedCategory, BuildContext context) {
    currentCategory = selectedCategory;
    if (selectedCategory == 'home') {
      setVideosListMap(completeVideosList);
    } else {
      videosListMap = [];
      print('selected Category = $selectedCategory');

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
    Navigator.of(context).pop();

    notifyListeners();
  }
}
