import '../constants/view_setting.dart';
import 'package:flutter/material.dart';

bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width > desktopCutoff;