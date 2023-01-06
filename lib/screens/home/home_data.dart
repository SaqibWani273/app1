import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class HomeData extends ChangeNotifier {
  HomeData(BuildContext context);
  //appIcon used in appbar on top
  String appIcon = 'assets/images/app_icon.jpg';
  String thumbnaiImage = 'assets/images/ab_lateef_bhat_modern_ss.png';
  int currentTabIndex = 0;
  changeCurrentTab(int index) {
    currentTabIndex = index;
    notifyListeners();
  }

  final List<Map<String, String>> videosListMap = [];
  Future<List<Map<String, String>>> videosData() async {
    try {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref('completeVideosList');
      final dataAtRef = await ref.get();

      //casting data response to Map
      final completeVideosList = Map<String, Map>.from(
        dataAtRef.value! as Map<Object?, Object?>,
      );
      //deep casting and traversing to get the actual data
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
    } catch (e) {
      print('error in firebase data fetching/videosData() function');
    }
    return videosListMap;
  }
}
