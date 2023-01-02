import 'package:flutter/cupertino.dart';

class HomeData extends ChangeNotifier {
  HomeData(BuildContext context);
  String appIcon = 'assets/images/app_icon.jpg';
  String thumbnaiImage = 'assets/images/ab_lateef_bhat_modern_ss.png';
  int currentTabIndex = 0;
  changeCurrentTab(int index) {
    currentTabIndex = index;
    notifyListeners();
  }
}
