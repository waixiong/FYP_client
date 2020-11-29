import 'package:flutter/material.dart';

class GenerateCodePage extends StatefulWidget {
  @override
  GenerateCodePageState createState() => new GenerateCodePageState();
}

class GenerateCodePageState extends State<GenerateCodePage>{

  String textInput = "";

  void onChange(String value){
    setState(() => textInput = value);
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

              SizedBox(height: 16,),
              new Row(
                children: [
                  Expanded(
                    child: new TextField(
                      decoration: new InputDecoration(
                          labelText: "Message",
                          hintText: "Message",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                      ),
                      onChanged: onChange,
                      keyboardType: TextInputType.multiline,
                      minLines: 4,//Normal textInputField will be displayed
                      maxLines: 5,// when user presses enter it will adapt to it
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
                    child: new Text("Generate",
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
