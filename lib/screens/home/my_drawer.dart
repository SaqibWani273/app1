import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_data.dart';

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
          homeData.MyListTile('home', context),
          homeData.MyListTile('Category A', context),
          homeData.MyListTile('Category B', context),
          homeData.MyListTile('Category C', context),
          homeData.MyListTile('Category D', context),
          homeData.MyListTile('Category E', context),
        ],
      ),
    );
  }
}
