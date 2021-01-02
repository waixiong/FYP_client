import 'package:flutter/material.dart';
import 'package:imageChat/view/widgets/color_widget.dart';
import 'package:imageChat/viewmodel/secret_image_viewmodel.dart';

class FormatSelectionDialog extends StatelessWidget {

  FormatSelectionDialog(this.model, {this.encoded = false});

  final SecretImageViewModel model;
  final bool encoded;

  @override
  Widget build(BuildContext context) {
    
    return StatefulBuilder(
      builder: (context, setState) {

        int _format = model.custom
          ? model.fixedColor == FixedColor.Red
              ? 1
              : model.fixedColor == FixedColor.Blue
                  ? 3
                  : 2
          : 0;
        print(model.format);
        return SimpleDialog(
          title: Text('Format Setting'),
          contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 16),
          children: [
            DropdownButton<Format>(
              items: [
                DropdownMenuItem<Format>(
                  child: Text('Sia Pattern'),
                  value: Format.SiaPattern,
                ),
                DropdownMenuItem<Format>(
                  child: Text('Cheelaunator'),
                  value: Format.Cheelaunator,
                )
              ], 
              onChanged: (value) {
                model.changePatternFormat(value);
                setState((){});
              },
              value: model.format,
            ),
            SizedBox(height: 9,),
            if(model.format == Format.Cheelaunator)
              StatefulBuilder(
                builder: (context, setState2) {

                  _customFormat(int value) {
                    _format = value;
                    switch(value) {
                      case 1:
                        model.fixedColor = FixedColor.Red;
                        model.custom = true;
                        break;
                      case 2:
                        model.fixedColor = FixedColor.Green;
                        model.custom = true;
                        break;
                      case 3:
                        model.fixedColor = FixedColor.Blue;
                        model.custom = true;
                        break;
                      default:
                        model.custom = false;
                    }
                    setState2((){});
                  }

                  _fixedValueChange(value) {
                    model.fixedValue = value.toInt();
                    setState2((){});
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Radio<int>(
                            activeColor: Colors.grey,
                            value: 0,
                            groupValue: _format,
                            onChanged: _customFormat,
                          ),
                          Text('General')
                        ],
                      ),
                      Row(
                        children: [
                          Radio<int>(
                            activeColor: Colors.red,
                            value: 1,
                            groupValue: _format,
                            onChanged: _customFormat,
                          ),
                          Text('RFix'),
                          Radio<int>(
                            activeColor: Colors.green,
                            value: 2,
                            groupValue: _format,
                            onChanged: _customFormat,
                          ),
                          Text('GFix'),
                          Radio<int>(
                            activeColor: Colors.blue,
                            value: 3,
                            groupValue: _format,
                            onChanged: _customFormat,
                          ),
                          Text('BFix'),
                        ],
                      ),
                      if(model.custom && encoded)
                        Slider(
                          value: model.fixedValue.toDouble(),
                          min: 0, max: 8,
                          divisions: 8, 
                          activeColor: model.fixedColor == FixedColor.Red
                              ? Colors.red : model.fixedColor == FixedColor.Blue
                                  ? Colors.blue
                                  : Colors.green,
                          inactiveColor: Colors.grey,
                          label: model.fixedValue.toString(),
                          onChanged: _fixedValueChange
                        ),
                      if(model.custom)
                        Container(
                          height: 160,
                          child: StatefulBuilder(
                            builder: (context, painterState) {
                              return _SelectionColorPainterRenderer(model.fixedColor, fixedValue: model.fixedValue);
                              return model.fixedValue < 8
                                  ? CustomPaint(
                                    painter: SelectionColorPainter(model.fixedColor, fixedValue: model.fixedValue),
                                    child: SizedBox(
                                      height: 160,
                                      width: double.infinity,
                                    ),
                                  )
                                  : _SelectionColorPainterRenderer(model.fixedColor, fixedValue: model.fixedValue);
                            },
                          ),
                        )
                    ],
                  );
                }
              )
          ],
        );
      }
    );
  }
}

class _SelectionColorPainterRenderer extends StatefulWidget {
  final FixedColor fixedColor;
  final int fixedValue;

  _SelectionColorPainterRenderer(this.fixedColor, {this.fixedValue = 0});

  _SelectionColorPainterRendererState createState() => _SelectionColorPainterRendererState();
}

class _SelectionColorPainterRendererState extends State<_SelectionColorPainterRenderer> with TickerProviderStateMixin{
  Tween<double> _tween;
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _tween = Tween<double>(begin: 0, end: 7);
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    animation = _tween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SelectionColorPainter(widget.fixedColor, fixedValue: widget.fixedValue < 8
        ? widget.fixedValue
        : animation.value.round()
      ),
      child: SizedBox(
        height: 160,
        width: double.infinity,
      ),
    );
  }
}