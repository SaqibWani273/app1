import 'package:app_for_publishing/screens/home/home_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget {
  final double appBarHeight;
  final double appBarWidth;

  const MyAppBar(
    BuildContext context, {
    super.key,
    required this.appBarHeight,
    required this.appBarWidth,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    print('appbar rebult');
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
                        Image.asset(Provider.of<HomeData>(context).appIcon,
                            fit: BoxFit.cover),
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
                            },
                            autofocus: false,
                            decoration: InputDecoration(
                              hintText: Provider.of<HomeData>(context)
                                          .currentTabIndex ==
                                      0
                                  ? 'Search  videos here'
                                  : 'Search for Audios ',
                            ),
                            keyboardType: TextInputType.name,
                          ),
                          IconButton(
                            onPressed: () {},
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
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ));
  }
}
