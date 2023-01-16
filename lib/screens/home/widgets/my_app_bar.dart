import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/home_data.dart';

class MyAppBar extends StatelessWidget {
  final double appBarHeight;
  final double appBarWidth;

  MyAppBar(
    BuildContext context, {
    super.key,
    required this.appBarHeight,
    required this.appBarWidth,
  });

  @override
  Widget build(BuildContext context) {
    HomeData homeData = Provider.of<HomeData>(context, listen: false);
    TextEditingController searchController = TextEditingController();
    log('appbar rebult');
    return AppBar(
        elevation: 3.0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        //icontheme for appbar icons
        iconTheme: const IconThemeData(
          color: Colors.black,
          size: 30,
          opacity: 0.8,
        ),
        // automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  print('image clicked');
                },
                child: Container(
                    constraints: BoxConstraints(
                      maxHeight: appBarHeight * 0.9,
                      maxWidth: 200.0,
                    ),
                    // padding: EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.asset(
                          homeData.appIcon,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: 200.0,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'FLutterAPP',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: appBarHeight * 0.35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 50,
                  maxWidth: 50,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: searchController,
                            onSubmitted: (value) {
                              print(value);
                              homeData.searchForVideos(
                                value.trim(),
                                context,
                              );
                            },
                            autofocus: false,
                            decoration: const InputDecoration(
                                hintText: 'Search  videos here'),
                            keyboardType: TextInputType.name,
                          ),
                          IconButton(
                            onPressed: () {
                              homeData.searchForVideos(
                                  searchController.text.trim(), context);
                              //to remove keyboard
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            icon: const Icon(
                              Icons.search_outlined,
                              size: 40,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  //show overlay only if  overlay
                  // is not displayed currently
                  //or remove it if displayed
                  homeData.notificationsEntry == null
                      ? homeData.notificationsOverlay(context)
                      : {
                          homeData.notificationsEntry?.remove(),
                          homeData.notificationsEntry = null,
                        };
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Stack(alignment: Alignment.topRight, children: [
                    const Icon(
                      Icons.notifications_none_rounded,
                      size: 50,
                      color: Colors.black,
                    ),
                    if (homeData.nOfNotifications != 0)
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            //to do : change it later
                            homeData.nOfNotifications.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                  ]),
                ),
              ),
            ),
          ],
        ));
  }
}
