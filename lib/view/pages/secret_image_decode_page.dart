import 'package:flutter/material.dart';
import 'package:imageChat/viewmodel/secret_image_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SecretImageDecodePage extends StatelessWidget {
  final Function(String) decodeFromChat; // (String url)
  SecretImageDecodePage({this.decodeFromChat});

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
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Secret Key (optional)',
                  ),
                ),
                Text('Image'),
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey,
                  child: Center(child: Image.network('https://res.cloudinary.com/dk-find-out/image/upload/q_80,c_limit,h_80,w_80,f_auto/Geometry2_hdxtr9.jpg', fit: BoxFit.contain,)),
                ),
                SizedBox(height: 9,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RaisedButton(
                      onPressed: () {},
                      child: Text('Decode Image'),
                    )
                  ],
                ),
                SizedBox(height: 9,),
                Text('Decoded Output'),
                Container(
                  height: 100, width: double.infinity,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText('Output will be here, in text (if it is text)\nOutput will be here, in text (if it is text)\nOutput will be here, in text (if it is text)\nOutput will be here, in text (if it is text)\nOutput will be here, in text (if it is text)\nOutput will be here, in text (if it is text)\nOutput will be here, in text (if it is text)\nOutput will be here, in text (if it is text)\nOutput will be here, in text (if it is text)'),
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}

class SecretImageDecodeFullPage extends StatelessWidget {
  final Function(String) decodeFromChat; // (String url)
  SecretImageDecodeFullPage({this.decodeFromChat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Decode Secret Image", style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),),
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Theme.of(context).backgroundColor),
      ),
      body: SecretImageDecodePage(decodeFromChat: decodeFromChat,)
    );
  }
}