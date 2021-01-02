import 'package:flutter/material.dart';

enum FixedColor {
  Red,
  Green,
  Blue
}

class SelectionColorPainter extends CustomPainter {
  const SelectionColorPainter(this.fixedColor, {this.fixedValue = 0});

  final FixedColor fixedColor;
  final int fixedValue;

  Color get _vColor {
    switch(fixedColor) {
      case FixedColor.Red:
        return Color.fromARGB(255, fixedValue * 32 + 16, 255, 0);
      case FixedColor.Green:
        return Color.fromARGB(255, 255, fixedValue * 32 + 16, 0);
      case FixedColor.Blue:
        return Color.fromARGB(255, 255, 0, fixedValue * 32 + 16);
      default:
        return Color.fromARGB(255, 255, 0, 0);
    }
  }

  Color get _hColor {
    switch(fixedColor) {
      case FixedColor.Blue:
        return Color.fromARGB(255, 0, 255, fixedValue * 32 + 16);
      case FixedColor.Green:
        return Color.fromARGB(255, 0, fixedValue * 32 + 16, 255);
      case FixedColor.Red:
        return Color.fromARGB(255, fixedValue * 32 + 16, 0, 255);
      default:
        return Color.fromARGB(255, 0, 0, 255);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient gradientV = LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topLeft,
      colors: [Colors.black, _vColor],
    );
    final Gradient gradientH = LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.bottomRight,
      colors: [Colors.black, _hColor],
    );
    canvas.drawRect(
      rect, 
      Paint()
        ..shader = gradientV.createShader(rect)
    );
    canvas.drawRect(
      rect,
      Paint()
        ..blendMode = BlendMode.plus
        ..shader = gradientH.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}