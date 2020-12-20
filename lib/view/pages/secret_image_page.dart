import 'package:flutter/material.dart';
import './secret_image_decode_page.dart';
import 'package:stacked/stacked.dart';

import 'secret_image_encode_page.dart';

class SecretImagePage extends StatefulWidget {
  final Function(String) decodeFromChat;
  final Function(String) encodeToChat;

  SecretImagePage({this.decodeFromChat, this.encodeToChat});

  @override
  State<StatefulWidget> createState() => _SecretImagePageState();
}

class _SecretImagePageState extends State<SecretImagePage> with SingleTickerProviderStateMixin<SecretImagePage> {

  TabController _pageController;

  _SecretImagePageState() {
    _pageController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Secret Image", style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),),
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Theme.of(context).backgroundColor),
        bottom: TabBar(
          controller: _pageController,
          tabs: [
            Tab(icon: Text("Generate Image", style: Theme.of(context).textTheme.subtitle1,)),
            Tab(icon: Text("Decode Image", style: Theme.of(context).textTheme.subtitle1,))
          ],
        ),
      ),
      body: TabBarView(
        controller: _pageController,
        children: [
          SecretImageEncodePage(),
          SecretImageDecodePage(),
        ],
      )
    );
  }
}