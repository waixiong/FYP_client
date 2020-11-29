import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../constants/padding.dart';

class PageTitle extends StatelessWidget {
  PageTitle({
    Key key,
    this.titleString, 
    this.margin,
    this.trailing,
  }) : super(key:key);

  final String titleString;
  final EdgeInsets margin;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.fromLTRB(appSidePadding, 0, appSidePadding, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: AutoSizeText(titleString, maxLines: 3, style: Theme.of(context).textTheme.headline3.copyWith(fontWeight: FontWeight.w600),)),
          if (trailing != null) Flexible(child: trailing,),
        ],
      ),
    );
  }
}