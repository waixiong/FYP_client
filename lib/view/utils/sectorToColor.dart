import 'package:flutter/material.dart';

const c = 256*256*256;

Color sector2Color(String value) {
  return Color(value.hashCode % c + 0xFF000000);
}