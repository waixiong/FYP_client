import 'package:imageChat/view/constants/padding.dart';
import 'package:flutter/material.dart';
import '../../locator.dart';
import '../../service/auth_service.dart';

class LoginPage extends StatefulWidget {
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool loading = false;

  _signIn() async {
    setState((){ loading = true; });
    try {
      await locator<AuthService>().signIn();
    } catch(e) {
      //
    }
    setState((){ loading = false; });
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(appSidePadding, appSidePadding, 0, 0),
          child: Text('Image\nChat', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.white),),
        ),

        Align(
          alignment: Alignment(-1, 0.25),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: appSidePadding),
            child: Text(
              'Hide\nmessage\nin image', 
              style: MediaQuery.of(context).size.height < 641
                ? Theme.of(context).textTheme.headline3.copyWith(color: Colors.grey)
                : Theme.of(context).textTheme.headline2.copyWith(color: Colors.grey, height: 1.25),
            ),
          ),
        ),
        
        Align(
          alignment: Alignment(0, 0.75),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: appSidePadding,),
            child: FlatButton(
              splashColor: Colors.grey,
              color: Theme.of(context).canvasColor,
              padding: EdgeInsets.zero,
              // borderSide: BorderSide(color: Colors.white, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),

              onPressed: _signIn,

              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Spacer(),

                    Image(image: AssetImage("assets/google_logo.png"), height: 24.0),

                    SizedBox(width: 16,),

                    Text('Sign in with Google', style: Theme.of(context).textTheme.bodyText1,),

                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}