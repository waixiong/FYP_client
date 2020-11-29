import 'package:flutter/material.dart';
import '../../pages/ScanCodePage.dart';
import '../../pages/GenerateCodePage.dart';

class QRCodeTopBar extends StatefulWidget {
  @override
  _QRCodeTopBarState createState() => new _QRCodeTopBarState();
}

class _QRCodeTopBarState extends State<QRCodeTopBar>{

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("QR Code", textAlign: TextAlign.center, style: TextStyle(fontSize: 30),),
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
                      icon: Text("Generate Code", style: TextStyle(fontSize: 24),),
                    ),
                    Tab(
                      icon: Text("Scan Code", style: TextStyle(fontSize: 24),),
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
                  GenerateCodePage(),

                  // second tab bar view widget
                  ScanCodePage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}