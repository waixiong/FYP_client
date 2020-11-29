import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class TextWithHelp extends StatelessWidget {
  TextWithHelp({
    Key key,
    this.text,
    this.onHelpTap,
  }) : super(key:key);

  Text text;
  Function onHelpTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        text,
        SizedBox(width: 2,),
        InkWell(
          child: Opacity(
            opacity: 0.5,
            child: Transform.scale(
              scale: 0.8,
              alignment: Alignment.topLeft,
              child: Icon(LineAwesomeIcons.question_circle, size: 16,)
            ),
          ),

          onTap: onHelpTap,
        ),
      ],
    );
  }
}