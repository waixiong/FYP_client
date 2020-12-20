import 'package:flutter/material.dart';

// @Sia
class DecodeImagePage extends StatefulWidget {
  @override
  DecodeImagePageState createState() => new DecodeImagePageState();
}

class DecodeImagePageState extends State<DecodeImagePage>{

  String decodedOutput = "";

  void onChange(String value){
    setState(() => decodedOutput = value);
  }

  void dummyOnChange(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: new Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
                decodedOutput != ""? {
                  SizedBox(height: 16,),
                  new Row(
                    children: [
                      Expanded(
                        child: new Text(
                          decodedOutput, maxLines: 5,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16,),
                }
                : (
                SizedBox(height: 16,)
                ),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        border: Border.all(
                          color: Colors.black,
                          width: 8,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16,),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new RaisedButton(
                      onPressed: dummyOnChange,
                      color: Colors.white,
                      disabledColor: Colors.white,
                      child: new Text("Decode From Gallery",
                        style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}