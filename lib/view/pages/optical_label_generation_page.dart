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
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Input Text',
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 9,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(18.0),
                      //   // side: BorderSide()
                      // ),
                      clipBehavior: Clip.antiAlias,
                      onPressed: () {}, 
                      child: Text('Clear')
                    ),
                    SizedBox(width: 3,),
                    ElevatedButton(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(18.0),
                      //   // side: BorderSide()
                      // ),
                      clipBehavior: Clip.antiAlias,
                      onPressed: () {},
                      child: Text('Generate'),
                    )
                  ],
                ),
                SizedBox(height: 9,),
                // Text('Output Image'),
                // Container(
                //   height: 200,
                //   color: Colors.grey,
                //   child: Center(child: Text('Image'),),
                // ),
              ],
            ),
          );
        }
      ),
    );
  }
}