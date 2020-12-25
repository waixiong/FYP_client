import 'package:flutter/material.dart';

// @Sia
class GenerateImagePage extends StatefulWidget {
  @override
  GenerateImagePageState createState() => new GenerateImagePageState();
}

class GenerateImagePageState extends State<GenerateImagePage>{

  String secretMessage = "";
  String secretKey = "";

  void secretMessageOnChange(String value){
    setState(() => secretMessage = value);
  }

  void secretKeyOnChange(String value){
    setState(() => secretKey = value);
  }

  void dummyOnChange(){
    //
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
                SizedBox(height: 16,),
                new Row(
                  children: [
                    Expanded(
                      child: new TextField(
                        decoration: new InputDecoration(
                          // labelText: "Secret Message",
                          hintText: "Secret Message",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        onChanged: secretMessageOnChange,
                        keyboardType: TextInputType.multiline,
                        minLines: 4,//Normal textInputField will be displayed
                        maxLines: 5,// when user presses enter it will adapt to it
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16,),
                new Row(
                  children: [
                    Expanded(
                      child: new TextField(
                        decoration: new InputDecoration(
                          // labelText: "Secret Key(Optional)",
                          hintText: "Secret Key(Optional)",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        onChanged: secretKeyOnChange,
                        keyboardType: TextInputType.multiline,
                        minLines: 2,//Normal textInputField will be displayed
                        maxLines: 3,// when user presses enter it will adapt to it
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
                      child: new Text("Generate Image",
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