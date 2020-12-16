import 'package:flutter/material.dart';
import 'package:imageChat/viewmodel/secret_image_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SecretImageEncodePage extends StatelessWidget {
  final Function(String) sendToChat; // (String url)
  SecretImageEncodePage({this.sendToChat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(9),
      child: ViewModelBuilder<SecretImageViewModel>.reactive(
        viewModelBuilder: () => SecretImageViewModel(),
        builder: (context, model, _) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Input Text',
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Secret Key (optional)',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 9,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      onPressed: () {}, 
                      child: Text('Clear')
                    ),
                    RaisedButton(
                      onPressed: () {},
                      child: Text('Encode Image'),
                    )
                  ],
                ),
                SizedBox(height: 9,),
                Text('Output Image'),
                Container(
                  height: 200,
                  color: Colors.grey,
                  child: Center(child: Text('Image'),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      onPressed: () {}, 
                      child: Text('Save')
                    ),
                    RaisedButton(
                      onPressed: () {},
                      child: Text('Send'),
                    )
                  ],
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

class SecretImageEncodeFullPage extends StatelessWidget {
  final Function(String) sendToChat; // (String url)
  SecretImageEncodeFullPage({this.sendToChat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Encode Secret Image", style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),),
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Theme.of(context).backgroundColor),
      ),
      body: SecretImageEncodePage(sendToChat: sendToChat,)
    );
  }
}