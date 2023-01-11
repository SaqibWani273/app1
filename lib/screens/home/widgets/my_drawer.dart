import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/home_data.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('drawer build');
    final homeData = Provider.of<HomeData>(context, listen: false);
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 120,
            child: DrawerHeader(
              child: GestureDetector(
                onTap: () {
                  print('image clicked');
                },
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
                        maxWidth: 50.0,
                      ),
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'FLutterAPP',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: homeData.listTiles
                .map(((listItem) => Container(
                      child: GestureDetector(
                        //context is needed to call navigator.pop(context)
                        onTap: (() => homeData.changeCategory(
                            listItem['title'], context)),
                        child: Card(
                          color: homeData.currentCategory == listItem['title']
                              ? Colors.grey[400]
                              : Colors.white,
                          child: ListTile(
                            selected:
                                homeData.currentCategory == listItem['title']
                                    ? true
                                    : false,
                            selectedTileColor: Colors.white70,
                            leading: Icon(
                              homeData.currentCategory == listItem['title']
                                  ? listItem['filledIcon']
                                  : listItem['outlinedIcon'],
                              color: Colors.black,
                            ),
                            title: Text(
                              listItem['title'],
                              style: TextStyle(
                                color: homeData.currentCategory ==
                                        listItem['title']
                                    ? Colors.black
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )))
                .toList(),
          ),
        ],
      ),
    );
  }
}
