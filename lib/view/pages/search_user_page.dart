import 'package:flutter/material.dart';
import 'package:imageChat/viewmodel/search_user_viewmodel.dart';
import 'package:stacked/stacked.dart';
import '../constants/padding.dart';

class SearchUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _textController = TextEditingController();
    var _nameTextController = TextEditingController();
    return ViewModelBuilder<SearchUserViewmodel>.reactive(
      viewModelBuilder: () => SearchUserViewmodel(),
      builder: (context, model, _) {
        return Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.white,
            title: Text('Search User'),
            // iconTheme: Theme.of(context).iconTheme.copyWith(color: Theme.of(context).backgroundColor),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          labelText: 'Enter email to search',
                          errorText: model.errorString
                        ),
                        textInputAction: TextInputAction.next,
                        onSubmitted: model.search,
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.all(9),
                      child: GestureDetector(
                        child: Icon(Icons.search),
                        onTap: () => model.search(_textController.text),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: model.isBusy
                    ? SizedBox(
                      height: 48, width: 48,
                      child: CircularProgressIndicator(),
                    )
                    : model.user == null
                      ? model.notFound
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Opacity(opacity: 0.7, child: Text(_textController.text, style: Theme.of(context).textTheme.caption,)),
                              SizedBox(height: 16.0),
                              TextField(
                                controller: _nameTextController,
                                decoration: InputDecoration(
                                  labelText: 'Enter name',
                                  errorText: model.errorString
                                ),
                                textInputAction: TextInputAction.next,
                                onSubmitted: model.invite,
                              ),
                              SizedBox(height: 16.0),
                              GestureDetector(
                                onTap: () => model.invite(_nameTextController.text),
                                child: Container(
                                  height: 8.0 * 4,
                                  width: 8.0 * 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0 * 3),
                                    gradient: LinearGradient(colors: [Colors.purple, Colors.blue], begin: Alignment.topRight, end: Alignment.centerLeft)
                                  ),
                                  child: Center(
                                    child: Text('Invite', 
                                      style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                          : Container()
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 8.0 * 5,
                            backgroundImage: NetworkImage(model.user.img), // 'assets/profile.jpg'
                          ),
                          SizedBox(height: appPadding_Item),
                          Text(model.user.name,style: Theme.of(context).textTheme.headline6,),
                          SizedBox(height: 2),
                          Opacity(opacity: 0.7, child: Text(_textController.text, style: Theme.of(context).textTheme.caption,)),
                          SizedBox(height: 16.0),
                          GestureDetector(
                            onTap: () => model.navigateToChat(context),
                            child: Container(
                              height: 8.0 * 4,
                              width: 8.0 * 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0 * 3),
                                gradient: LinearGradient(colors: [Colors.purple, Colors.blue], begin: Alignment.topRight, end: Alignment.centerLeft)
                              ),
                              child: Center(
                                child: Text('Start To Chat', 
                                  style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                ),
              )
            ]
          ),
        );
      }
    );
  }
}