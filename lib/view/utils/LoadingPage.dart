import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({this.message = ''});
  
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 48, width: 48,
              child: CircularProgressIndicator(),
            ),

            if (message.isNotEmpty) Padding(
              padding: EdgeInsets.all(12),
              child: Text(message, style: Theme.of(context).textTheme.subtitle1,),
            ),
          ],
        ),
      ),
    );
  }
}