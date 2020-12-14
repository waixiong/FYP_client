import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:imageChat/locator.dart';
import 'package:imageChat/view/pages/chat_page.dart';
import 'package:imageChat/view/pages/search_user_page.dart';
import 'package:imageChat/viewmodel/chatlist_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:transparent_image/transparent_image.dart';

class ChatList extends StatelessWidget {
  ChatList({Key key}) : super(key: key) {
    //
  }

  @override
  Widget build(BuildContext context) {
    
    return ViewModelBuilder<ChatListViewModel>.reactive(
      viewModelBuilder: () => ChatListViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, _) {
        return Scaffold(
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("Messaging", style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),),
            iconTheme: Theme.of(context).iconTheme.copyWith(color: Theme.of(context).backgroundColor),
            actions: [
              Padding(
                padding: EdgeInsets.all(9),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchUserPage())),
                  child: Icon(Icons.person_add, color: Theme.of(context).backgroundColor,),
                ),
              )
            ],
          ),
          body: model.isBusy
            ? Center(
              child: SizedBox(
                width: 48, height: 48,
                child: CircularProgressIndicator(),
              ),
            )
            : model.users.length == 0
              ? Center(
                child: Text('No message'),
              )
              : ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  print(model.users[index].toJson());
                  print(model.messagesList[model.users[index]]);
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 8.0 * 5,
                      backgroundImage: NetworkImage(model.users[index].avatar), // 'assets/profile.jpg'
                    ),
                    title: Text(model.users[index].name),
                    subtitle: Text(
                      model.messagesList[model.users[index]] == null? 'No messages' :
                          model.messagesList[model.users[index]].image == null? model.messagesList[model.users[index]].text : '[Image] ' 
                            + model.messagesList[model.users[index]].text),
                    onTap: () {
                      model.navigateToChat(model.users[index]);
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage()));
                    },
                  );
                },
                itemCount: model.users.length,
              ),
        );
      }
    );
  }
}

ChatMessage convertFCMDataToMessage(Map<String, String> data) {
  return ChatMessage(
    text: data["params.content"], 
    user: ChatUser(
      uid: data["params.senderId"]
    ),
    createdAt: DateTime(0, 0, 0, 0, 0, 0, int.parse(data["params.timestamp"]))
  );
  // data["params.chatId"] = message.ChatId
  // data["params.senderId"] = message.SenderId
  // data["params.content"] = message.Content
  // data["params.timestamp"] = strconv.FormatInt(message.Timestamp.UnixNano()/1000000, 10)
}