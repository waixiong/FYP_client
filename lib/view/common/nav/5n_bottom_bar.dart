import 'dart:async';
import 'dart:math';
import '../../constants/view_setting.dart';
import 'package:flutter/material.dart';

import '../../constants/padding.dart';
import '../../common/nav/profie_dark_mode.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../locator.dart';
import '../../../service/auth_service.dart';

class FiveNBottomBar extends StatelessWidget {
  final StreamController<int> pageIndexController = StreamController<int>.broadcast();

  Stream<int> get pageIndexStream => pageIndexController.stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: 1,
      stream: pageIndexStream,
      builder: (context, snapshot) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: appBottomBarPadding,
              maxWidth: min(512, MediaQuery.of(context).size.width)
            ),
            color: Theme.of(context).canvasColor,
            child: SalomonBottomBar(
              items: [
                SalomonBottomBarItem(icon: Icon(LineAwesomeIcons.facebook_messenger), title: Text('Message')),
                SalomonBottomBarItem(icon: Icon(LineAwesomeIcons.image), title: Text('Image')),
                SalomonBottomBarItem(icon: ProfileDarkMode(), title: Text('${locator<AuthService>().user}')),
              ],

              currentIndex: snapshot.data,
              onTap: (index) => pageIndexController.add(index),
              itemPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              margin: EdgeInsets.symmetric(horizontal: appSidePadding, vertical: 6),
            ),
          ),

          if (MediaQuery.of(context).size.width > desktopCutoff) Flexible(
            // flex: 7,
            child: IgnorePointer(
              child: Container(
                width: double.infinity,
              ),
            ),
          )
        ],
      ),
    );
  }
}