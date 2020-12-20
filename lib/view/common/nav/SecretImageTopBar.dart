import 'package:flutter/material.dart';
import '../../pages/DecodeImagePage.dart';
import '../../pages/GenerateImagePage.dart';

// @Sia
class SecretImageTopBar extends StatefulWidget {
  @override
  _SecretImageTopBarState createState() => new _SecretImageTopBarState();
}

class _SecretImageTopBarState extends State<SecretImageTopBar>{

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Secret Image", textAlign: TextAlign.center, style: TextStyle(fontSize: 30),),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            // the tab bar with two items
            SizedBox(
              height: 50,
              child: AppBar(
                bottom: TabBar(
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.black,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                      icon: Text("Generate Image", style: TextStyle(fontSize: 24),),
                    ),
                    Tab(
                      icon: Text("Decode Image", style: TextStyle(fontSize: 24),),
                    ),
                  ],
                ),
              ),
            ),

            // create widgets for each tab bar here
            Expanded(
              child: TabBarView(
                children: [
                  // first tab bar view widget
                  GenerateImagePage(),

                  // second tab bar view widget
                  DecodeImagePage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}