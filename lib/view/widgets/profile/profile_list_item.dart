import '../../constants/padding.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;
  final Function action;

  const ProfileListItem({
    Key key,
    this.icon,
    this.text,
    this.hasNavigation = true,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 8.0 * 5.5,
        margin: EdgeInsets.fromLTRB(appSidePadding, 0, appSidePadding, appPadding_Item),
        padding: EdgeInsets.symmetric(horizontal: 8.0 * 2,),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0 * 3),
          color: Theme.of(context).backgroundColor,
        ),

        child: Row(
          children: <Widget>[
            Icon(this.icon, size: 8.0 * 2.5,),
            SizedBox(width: 8.0 * 1.5),
            Text(this.text,style: Theme.of(context).textTheme.bodyText1,),
            Spacer(),
            if (this.hasNavigation) Icon(LineAwesomeIcons.angle_right, size: 20,),
          ],
        ),
      ),
    );
  }
}
