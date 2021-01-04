import 'package:flutter/material.dart';
import 'package:imageChat/viewmodel/secret_image_viewmodel.dart';
import 'package:stacked/stacked.dart';

class OpticalLabelGenerationPage extends StatelessWidget {
  OpticalLabelGenerationPage();

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
                    decoration: BoxDecoration(border: Border.all()),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Input Text',
                          ),
                          controller: model.inputText,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FlatButton(
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(18.0),
                          //   // side: BorderSide()
                          // ),
                          clipBehavior: Clip.antiAlias,
                          onPressed: model.clear,
                          child: Text('Clear')),
                      SizedBox(
                        width: 3,
                      ),
                      ElevatedButton(
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(18.0),
                        //   // side: BorderSide()
                        // ),
                        clipBehavior: Clip.antiAlias,
                        onPressed: model.encode,
                        child: Text('Generate'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  if (model.busy("encode"))
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: CircularProgressIndicator(),
                    )
                  else if (model.outputImg != null)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 9,
                        ),
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
                                    child: Text('Save')),
                            SizedBox(width: 3),
//                            model.busy('send')
//                                ? CircularProgressIndicator()
//                                : ElevatedButton(
//                                    // shape: RoundedRectangleBorder(
//                                    //   borderRadius: BorderRadius.circular(18.0),
//                                    //   // side: BorderSide()
//                                    // ),
//                                    clipBehavior: Clip.antiAlias,
//                                    onPressed: model.send,
//                                    child: Text('Send'),
//                                  )
                          ],
                        )
                      ],
                    )
                  else if (model.encodeErr != null)
                    Padding(
                      padding: EdgeInsets.all(9),
                      child: Text(
                        model.encodeErr,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(
                    height: 120,
                  )
                  // Text('Output Image'),
                  // Container(
                  //   height: 200,
                  //   color: Colors.grey,
                  //   child: Center(child: Text('Image'),),
                  // ),
                ],
              ),
            );
          }),
    );
  }
}
