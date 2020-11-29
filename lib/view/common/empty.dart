import 'package:flutter/material.dart';

import '../common/page_title.dart';
import '../constants/padding.dart';

class EmptyPage extends StatelessWidget {
  EmptyPage({
    Key key,
    this.title,
    this.subtitle,
    this.buttonText,
    this.onTap,
  }) : super(key:key);

  final PageTitle title;
  final String subtitle;
  final String buttonText;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: appVerticalPadding),
        title ?? Container(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.13,),
        Image.asset('assets/empty.png', width: MediaQuery.of(context).size.width * 0.7,),
        Text(subtitle, style: Theme.of(context).textTheme.overline,),
        SizedBox(height: 8,),
        FlatButton(
          padding: EdgeInsets.zero,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0))),
          child: Ink(
            decoration: const BoxDecoration(
              // borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              gradient: LinearGradient(colors: [Colors.purple, Colors.blue], begin: Alignment.centerRight, end: Alignment.centerLeft),
            ),
            
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(buttonText, style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white)),
            ),
          ),

          onPressed: onTap,
        ),
      ],
    );
  }
}