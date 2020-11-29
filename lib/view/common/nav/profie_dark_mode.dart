import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileDarkMode extends StatelessWidget {
  // final String image = 'https://images.unsplash.com/photo-1514315384763-ba401779410f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=jpg&fit=crop&w=630&q=50';

  @override
  Widget build(BuildContext context) {
    final Box hive = Hive.box('0');

    // return ValueListenableBuilder(
    //   valueListenable: hive.listenable(keys: ['isDark']),
    //   builder: (context, _, __) => IgnorePointer(
    //     child: Switch(
    //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //       // activeColor: Theme.of(context).accentColor,
    //       activeThumbImage: NetworkImage(image),

    //       onChanged: (val) => hive.put('isDark', val),
    //       value: hive.get('isDark', defaultValue: false),
    //     ),
    //   ),
    // );

    return ValueListenableBuilder(
      valueListenable: hive.listenable(keys: ['isDark']),
      builder: (context, _, __) => GestureDetector(
        // child: CircleAvatar(
        //   maxRadius: 16,
        //   backgroundImage: NetworkImage(image),
        // ),

        child: Icon(LineAwesomeIcons.user_circle,),

        onLongPress: () => hive.put('isDark', !(hive.get('isDark', defaultValue: false) as bool)),
      ),
    );
  }
}