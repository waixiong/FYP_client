import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:imageChat/locator.dart';
import 'package:imageChat/view/pages/chat_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:transparent_image/transparent_image.dart';

StreamController<List<Map<dynamic, dynamic>>> chatStreamController = StreamController<List<Map<dynamic, dynamic>>>();
Stream<List<Map<dynamic, dynamic>>> chatStream() {
  return chatStreamController.stream;
}

class ChatList extends StatefulWidget {
  ChatList({Key key, @required this.self}) : super(key: key) {
    //
  }

  // final String name;
  final ChatUser self;

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();
  var i = 0;

  @override
  void initState() {
    super.initState();
  }

  void openChat(BuildContext context) {
    //
  }

  // Widget chatWidget(BuildContext context, Chat chat) {
  //   if(chat is DirectChat) {
  //     return ListTile(
  //       leading: Icon(Icons.person),
  //       title: Text('${chat.participant.name}'),
  //       subtitle: Text('message'),
  //       onTap: () {
  //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatWidget(chat: chat, self: widget.self,)));
  //       },
  //     );
  //   } else if(chat is GroupChat) {
  //     return ListTile(
  //       leading: Icon(Icons.people),
  //       title: Text('${chat.name}'),
  //       subtitle: Text('message'),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Messaging", style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white),),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) => Card(
          child:ListTile(
          leading: CircleAvatar(
            radius: 8.0 * 5,
            backgroundImage: NetworkImage('https://yeez.getitqec.com/icons/y_192.webp'), // 'assets/profile.jpg'
          ),
          title: Text('Yeez'),
          subtitle: Text('Yeez Digital Menu'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage()));
          },
        ),
        ),
        itemCount: 1,
      ),
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