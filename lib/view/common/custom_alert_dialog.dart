import '../common/side_paded.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  CustomAlertDialog({
    Key key,
    this.title = 'Try again',
    this.description = 'Something is missing',
  }) : super(key:key);

  String title;
  String description;
  

  @override
  Widget build(BuildContext context) {
    bool _lightTheme = Theme.of(context).brightness == Brightness.light;

    return Dialog(
      clipBehavior: Clip.hardEdge,
      backgroundColor: Colors.black54,

      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).canvasColor, Colors.purple],
            begin: _lightTheme ? Alignment(0.25, 0.2) : Alignment(-0.25, -0.2),
            end: _lightTheme ? Alignment(1, -1) : Alignment(-1, -1),
          ),
          // borderRadius: BorderRadius.circular(16),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.w600),),
              SizedBox(height: 16,),
              Text(description, style: Theme.of(context).textTheme.bodyText1,),
            ],
          ),
        ),
      ),
    );
  }
}