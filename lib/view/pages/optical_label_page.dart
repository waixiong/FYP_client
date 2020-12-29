import 'package:flutter/material.dart';
import 'package:imageChat/view/pages/optical_label_scan_page.dart';
import 'package:imageChat/view/pages/optical_label_generation_page.dart';
import './secret_image_decode_page.dart';

import 'secret_image_encode_page.dart';

class OpticalLabelPage extends StatefulWidget {

  OpticalLabelPage();

  @override
  _OpticalLabelPageState createState() => _OpticalLabelPageState();
}

class _OpticalLabelPageState extends State<OpticalLabelPage> with SingleTickerProviderStateMixin<OpticalLabelPage> {

  TabController _pageController;

  _OpticalLabelPageState() {
    _pageController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Optical Label",),
        bottom: TabBar(
          controller: _pageController,
          tabs: [
            Tab(icon: Text("Scan Label", style: Theme.of(context).textTheme.subtitle1,)),
            Tab(icon: Text("Generate Label", style: Theme.of(context).textTheme.subtitle1,))
          ],
        ),
      ),
      body: TabBarView(
        controller: _pageController,
        children: [
          OpticalLabelScanPage(),
          OpticalLabelGenerationPage(),
        ],
      )
    );
  }
}