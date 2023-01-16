import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/home_data.dart';
import 'my_video_player.dart';
import 'my_app_bar.dart';
import 'my_drawer.dart';

class Home extends StatefulWidget {
  final HomeData homeData;
  const Home(this.homeData, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Map<String, String>>> _videosDataFuture;

  @override
  void initState() {
    _videosDataFuture = widget.homeData.videosData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('home build');
// declaring them in build for responsiveness
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        log('gestur dector of home');
        //to remove overlay of notifications
        widget.homeData.notificationsEntry?.remove();
        widget.homeData.notificationsEntry = null;
        //to remove any soft keyboard
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(
            deviceWidth,
            deviceHeight * 0.08,
          ), //Size.fromHeight(55.0),
          child: MyAppBar(
            context,
            appBarHeight: deviceHeight * 0.08,
            appBarWidth: deviceWidth,
          ),
        ),
        drawer: SizedBox(
          width: deviceWidth * 0.6,
          child: const MyDrawer(),
        ),
        body: FutureBuilder(
            future: _videosDataFuture,
            builder: ((context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                case ConnectionState.done:
                  {
                    if (snapshot.hasData) {
                      List<Map<String, String>> videosListMap =
                          widget.homeData.videosListMap;
                      return SingleChildScrollView(
                        // physics: NeverScrollableScrollPhysics(),
                        child: SizedBox(
                          height: deviceHeight,
                          child: GridView.builder(
                            itemCount: videosListMap.length,
                            //change padding for responsiveness
                            padding: const EdgeInsets.only(
                              left: 30,
                              top: 20.0,
                              right: 40,
                              bottom: 150.0,
                            ),
                            //  shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 400, //width
                              mainAxisExtent: 310, //height
                              crossAxisSpacing: 15.0,
                              mainAxisSpacing: 15.0,
                            ),
                            itemBuilder: (context, index) {
                              return VideosList(videosListMap, index);
                            },
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Error Occurred ! while fetching data...'),
                          ],
                        ),
                      );
                    }
                  }

                default:
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Loading ...'),
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
              }
            })),
      ),
    );
  }
}

class VideosList extends StatelessWidget {
  final List<Map<String, String>> videosListMap;
  final int index;
  const VideosList(this.videosListMap, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              onTap: (() {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyVideoPlayer(
                      videosListMap[index],
                    ),
                  ),
                );
              }),
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Image.network(
                    videosListMap[index]['imageUrl']!,
                    fit: BoxFit.fitWidth,
                    frameBuilder: (context, child, frame, _) {
                      //a placeholder before image starts to load
                      if (frame == null) {
                        return Container(
                          margin: const EdgeInsets.all(50),
                          color: Colors.grey,
                        );
                      }

                      return child;
                    },
                  ),
                ),
              ),
            ),
            Container(
              height: 20,
              width: 35,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 05.0, bottom: 05.0),
              color: Colors.black87.withOpacity(0.8),
              child: const Text(
                "00:00",
                style: TextStyle(color: Colors.white, fontSize: 13.0),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 90,
          child: Stack(children: [
            ClipRRect(
              //change it to user uploader image
              borderRadius: BorderRadius.circular(50.0),
              child: Image.asset(
                  Provider.of<HomeData>(listen: false, context).thumbnaiImage,
                  fit: BoxFit.fill,
                  height: 40,
                  width: 40),
            ),
            Container(
              height: 90,
              margin: const EdgeInsets.only(left: 08),
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(left: 40),
                  child: Text(
                    videosListMap[index]['description']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 17.0,
                        fontFamily: 'Roboto-Bold',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 40,
                  ),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "User Name",
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 40,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'views',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 05.0, right: 05.0),
                        child: const Icon(
                          Icons.brightness_1,
                          size: 2.5,
                        ),
                      ),
                      const Text(
                        'two days ago',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ]),
            )
          ]),
        ),
      ],
    );
  }
}
