import 'package:flutter/material.dart';
import 'package:imageChat/viewmodel/secret_image_viewmodel.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stacked/stacked.dart';

class SecretImageEncodePage extends StatelessWidget {
  final Function(String, String) sendToChat; // (String url)
  SecretImageEncodePage({this.sendToChat});

  @override
  Widget build(BuildContext context) {

    FocusNode _textFocusNode = FocusNode();
    FocusNode _secretNode = FocusNode();
    bool _obscureText = true;

    _textEditingComplete() {
      FocusScope.of(context).requestFocus(_secretNode);
    }

    _editingComplete() {
      FocusScope.of(context).unfocus(disposition: UnfocusDisposition.previouslyFocusedChild);
      print('Unfocus');
    }

    _onClickSetting(SecretImageViewModel model) async {
      showDialog(context: context, builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              title: Text('Format Setting'),
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
                )
              ],
            );
          }
        );
      });
    }

    return Padding(
      padding: EdgeInsets.all(9),
      child: ViewModelBuilder<SecretImageViewModel>.reactive(
        viewModelBuilder: () => SecretImageViewModel(sendToChat: sendToChat),
        builder: (context, model, _) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(3),
                  // decoration: BoxDecoration(
                  //   border: Border.all()
                  // ),
                  child: Column(
                    children: [
                      // TextField(
                      //   decoration: InputDecoration(
                      //     labelText: 'Input Text',
                      //   ),
                      //   controller: model.inputText,
                      // ),
                      Row(
                        children: [
                          Expanded(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Encode With " + (model.format == Format.Cheelaunator? "Cheelaunator" : "SiaPattern"), style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),),
                          )),
                          IconButton(
                            onPressed: () => _onClickSetting(model),
                            icon: Icon(LineAwesomeIcons.cog),
                          )
                        ],
                      ),
                      TextFormField(
                        enabled: model.isBusy ? false : model.busy("encode")? false : model.busy("decode")? false : true,
                        controller: model.inputText,
                        focusNode: _textFocusNode,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: model.format == Format.Cheelaunator? () => _editingComplete() : () => _textEditingComplete(),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.black,
                        autocorrect: true,
                        decoration: InputDecoration(
                          fillColor: Colors.grey[200],
                          filled: true,
                          labelText: "InputText",
                          labelStyle: TextStyle(
                              color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      // TextField(
                      //   decoration: InputDecoration(
                      //     labelText: 'Secret Key (optional)',
                      //   ),
                      //   controller: model.secretText,
                      // ),
                      SizedBox(height: 3,),
                      StatefulBuilder(
                        builder: (context, setState) => TextFormField(
                          enabled: model.isBusy ? false : model.busy("encode")? false : model.busy("decode")? false : model.format == Format.Cheelaunator? false : true,
                          controller: model.secretText,
                          focusNode: _secretNode,
                          onEditingComplete: () => _editingComplete(),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          cursorColor: Colors.black,
                          obscureText: _obscureText,
                          autocorrect: false,
                          decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            filled: true,
                            labelText: "Secret (Optional)",
                            labelStyle: TextStyle(color: Colors.black,),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(Icons.remove_red_eye),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 9,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(18.0),
                      //   // side: BorderSide()
                      // ),
                      clipBehavior: Clip.antiAlias,
                      onPressed: model.clear, 
                      child: Text('Clear')
                    ),
                    SizedBox(width: 3,),
                    ElevatedButton(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(18.0),
                      //   // side: BorderSide()
                      // ),
                      clipBehavior: Clip.antiAlias,
                      onPressed: model.encode,
                      child: Text('Encode Image'),
                    )
                  ],
                ),
                if(model.busy("encode")) 
                  SizedBox(
                    height: 36, width: 36,
                    child: CircularProgressIndicator(),
                  )
                else
                  if(model.outputImg != null)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 9,),
                        Container(
                          height: 200,
                          color: Colors.grey,
                          child: Center(
                            child: Image.memory(
                              model.outputImg.file.readAsBytesSync(),
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            model.busy('save')
                                ? CircularProgressIndicator()
                                : TextButton(
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(18.0),
                                  //   // side: BorderSide()
                                  // ),
                                  clipBehavior: Clip.antiAlias,
                                  onPressed: model.save,
                                  child: Text('Save')
                                ),
                            SizedBox(width: 3),
                            model.busy('send')
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(18.0),
                                  //   // side: BorderSide()
                                  // ),
                                  clipBehavior: Clip.antiAlias,
                                  onPressed: model.send,
                                  child: Text('Send'),
                                )
                          ],
                        )
                      ],
                    ),
                SizedBox(height: 120,)
              ],
            ),
          );
        }
      ),
    );
  }
}

class SecretImageEncodeFullPage extends StatelessWidget {
  final Function(String, String) sendToChat; // (String url)
  SecretImageEncodeFullPage({this.sendToChat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text("Encode Secret Image", ),
        // iconTheme: Theme.of(context).iconTheme.copyWith(color: Theme.of(context).backgroundColor),
      ),
      body: SecretImageEncodePage(sendToChat: sendToChat,)
    );
  }
}