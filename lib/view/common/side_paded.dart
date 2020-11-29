import '../constants/padding.dart';
import 'package:flutter/material.dart';

class SidePaded extends StatelessWidget {
  SidePaded({Key key, this.child}) : super(key:key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appSidePadding),
      child: child,
    );
  }
}