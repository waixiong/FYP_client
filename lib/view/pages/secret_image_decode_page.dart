import 'package:flutter/material.dart';
import 'package:imageChat/viewmodel/secret_image_viewmodel.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:image_picker/image_picker.dart';

class SecretImageDecodePage extends StatelessWidget {
  final String urlFromChat; // (String url)
  SecretImageDecodePage({this.urlFromChat});
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {

    FocusNode _secretNode = FocusNode();
    bool _obscureText = true;

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
        viewModelBuilder: () => SecretImageViewModel(),
        onModelReady: (model) => model.imageFromNetwork(urlFromChat),
        builder: (context, model, _) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                ),
                SizedBox(height: 9,),
                GestureDetector(
                  onTap: () {
                    picker.getImage(source: ImageSource.gallery).then((value) => model.imageFromFile(value.path));
                  },
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey,
                    child: Center(
                      child: model.inputImage == null
                          ? Text('Select an image')
                          : Image(image: model.inputImage),
                    ),
                  ),
                ),
                SizedBox(height: 9,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: model.decode,
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(18.0),
                      //   // side: BorderSide()
                      // ),
                      clipBehavior: Clip.antiAlias,
                      child: Text('Decode Image'),
                    )
                  ],
                ),
                SizedBox(height: 9,),
                if(model.busy("encode")) 
                  SizedBox(
                    height: 36, width: 36,
                    child: CircularProgressIndicator(),
                  )
                else 
                  if(model.outputString != null)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Decoded Output'),
                        Container(
                          height: 100, width: double.infinity,
                          padding: EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            // border: Border.all(),
                            // shape: BoxShape.circle,
                            borderRadius: BorderRadius.circular(9),
                            color: Colors.grey[200],
                          ),
                          child: SingleChildScrollView(
                            child: SelectableText(model.outputString),
                          ),
                        )
                      ]
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

class SecretImageDecodeFullPage extends StatelessWidget {
  final String urlFromChat; // (String url)
  SecretImageDecodeFullPage({this.urlFromChat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text("Decode Secret Image",),
        // iconTheme: Theme.of(context).iconTheme.copyWith(color: Theme.of(context).backgroundColor),
      ),
      body: SecretImageDecodePage(urlFromChat: urlFromChat,)
    );
  }
}