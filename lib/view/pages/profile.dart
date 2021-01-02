import '../../locator.dart';
import '../../model/user.dart';
import '../../service/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../constants/padding.dart';
import '../widgets/profile/profile_list_item.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileLayout extends StatelessWidget {
  final Box hive = Hive.box('0');

  final User user = locator<AuthService>().user;
  
  @override
  Widget build(BuildContext context) {

    _logout() async {
      DialogResponse response = await locator<DialogService>().showConfirmationDialog(
        title: 'Logout',
        confirmationTitle: 'Logout',
        description: 'Are you sure wanna logout?',
        dialogPlatform: DialogPlatform.Material,
      );

      if(response.confirmed) {
        await locator<AuthService>().signOut();
      }
    }

    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: 8.0 * 10,
            width: 8.0 * 10,
            margin: EdgeInsets.only(top: 8.0 * 3),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: 8.0 * 5,
                  backgroundImage: NetworkImage(user?.img), // 'assets/profile.jpg'
                ),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: Container(
                //     height: 8.0 * 2.5,
                //     width: 8.0 * 2.5,
                //     decoration: BoxDecoration(
                //       color: Theme.of(context).accentColor,
                //       shape: BoxShape.circle,
                //     ),
                //     child: Center(
                //       heightFactor: 8.0 * 1.5,
                //       widthFactor: 8.0 * 1.5,
                //       child: Icon(
                //         LineAwesomeIcons.pen,
                //         color: Theme.of(context).canvasColor,
                //         size: (8.0 * 1.5),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(height: appPadding_Item),

          Text(user?.name,style: Theme.of(context).textTheme.headline6,),
          SizedBox(height: 2),

          Opacity(opacity: 0.7, child: Text(user?.email, style: Theme.of(context).textTheme.caption,)),
          SizedBox(height: 16.0),

          // Container(
          //   height: 8.0 * 4,
          //   width: 8.0 * 20,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(8.0 * 3),
          //     gradient: LinearGradient(colors: [Colors.purple, Colors.blue], begin: Alignment.topRight, end: Alignment.centerLeft)
          //   ),
          //   child: Center(
          //     child: Text('Upgrade to PRO', 
          //       style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
          //     ),
          //   ),
          // ),
        ],
      ),
    );

    var themeSwitcher = AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      crossFadeState:
          Theme.of(context).brightness == Brightness.dark
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
      firstChild: GestureDetector(
        onTap: () =>
          hive.put('isDark', !(hive.get('isDark', defaultValue: true) as bool)),
        child: Icon(
          LineAwesomeIcons.sun,
          size: 24,
        ),
      ),
      secondChild: GestureDetector(
        onTap: () =>
            hive.put('isDark', !(hive.get('isDark', defaultValue: false) as bool)),
        child: Icon(
          LineAwesomeIcons.moon,
          size: 24,
        ),
      ),
    );

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: appSidePadding + 24),
        profileInfo,
        themeSwitcher,
        SizedBox(width: appSidePadding),
      ],
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 8.0 * 5),
          header,
          SizedBox(height: appPadding_Category),
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                ProfileListItem(
                  icon: LineAwesomeIcons.user_shield,
                  text: 'Privacy',
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.question_circle,
                  text: 'About',
                ),
                // ProfileListItem(
                //   icon: LineAwesomeIcons.cog,
                //   text: 'Settings',
                // ),
                ProfileListItem(
                  icon: LineAwesomeIcons.user_plus,
                  text: 'Invite a Friend',
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.alternate_sign_out,
                  text: 'Logout',
                  hasNavigation: false,
                  action: _logout
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
