import 'package:flutter/material.dart';
import 'package:imageChat/viewmodel/optical_label_viewmodel.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stacked/stacked.dart';

class OpticalLabelScanPage extends StatelessWidget {
  OpticalLabelScanPage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(9),
      child: ViewModelBuilder<OpticalLabelViewModel>.reactive(
        viewModelBuilder: () => OpticalLabelViewModel(),
        builder: (context, model, _) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(18.0),
                    //   // side: BorderSide()
                    // ),
                    clipBehavior: Clip.antiAlias,
                    onPressed: () {model.onImageButtonPressed(context);},
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        SizedBox(width: 6),
                        Text('Scan through Camera')
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(18.0),
                    //   // side: BorderSide()
                    // ),
                    clipBehavior: Clip.antiAlias,
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(Icons.photo_library_outlined),
                        SizedBox(width: 6),
                        Text('Photo from Gallery')
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 9,),
                // Text('Decoded Output'),
                // Container(
                //   height: 100, width: double.infinity,
                //   padding: EdgeInsets.all(3),
                //   decoration: BoxDecoration(
                //     border: Border.all()
                //   ),
                //   child: SingleChildScrollView(
                //     child: SelectableText('Output will be here, in text (if it is text)\nOutput will be here, in text (if it is text)\nOutput will be here, in text (if it is text)\nOutput will be here, in text (if it is text)\nOutput will be here, in text (if it is text)\nOutput will be here, in text (if it is text)\nOutput will be here, in text (if it is text)\nOutput will be here, in text (if it is text)\nOutput will be here, in text (if it is text)'),
                //   ),
                // )
              ],
            ),
          );
        }
      ),
    );
  }
}