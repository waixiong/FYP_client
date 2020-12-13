import 'dart:async';
import 'dart:io';

import 'package:imageChat/locator.dart';
import 'package:imageChat/service/auth_service.dart';

import '../../viewmodel/chat_viewmodel.dart';
import 'package:flutter/material.dart';
// https://stackoverflow.com/questions/58043499/image-picker-flutter-web-1-9
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:stacked/stacked.dart';

// void main() => runApp(MyApp());

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  final ChatUser user = ChatUser(
    name: "WXiong Chee",
    uid: locator<AuthService>().user.id,
    avatar: locator<AuthService>().user.img,
  );

  final ChatUser otherUser = ChatUser(
    name: "Yeez",
    uid: "25649654",
    avatar: 'https://yeez.getitqec.com/icons/y_192.webp',
  );

  // List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();

  var i = 0;

  @override
  void initState() {
    super.initState();
  }

  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          // messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState.scrollController
          ..animateTo(
            _chatViewKey.currentState.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  // void onSend(ChatMessage message) async {
  //   print(message.toJson());
  //   // TODO: send
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(otherUser.name, style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white),),
      ),
      body: ViewModelBuilder<ChatViewModel>.reactive(
        viewModelBuilder: () => ChatViewModel(self: user, targetUser: otherUser),
        onModelReady: (model) {
          model.getMessagesByTarget();
        },
          builder: (context, model, _) {
            if (model.isBusy) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              );
            } else {
              // List<DocumentSnapshot> items = snapshot.data.documents;
              // var messages = ;
              return DashChat(
                key: _chatViewKey,
                inverted: false,
                onSend: model.postMessage,
                sendOnEnter: true,
                textInputAction: TextInputAction.send,
                user: user,
                inputDecoration:
                    InputDecoration.collapsed(hintText: "Add message here..."),
                dateFormat: DateFormat('yyyy-MMM-dd'),
                timeFormat: DateFormat('HH:mm'),
                messages: model.messages,
                showUserAvatar: false,
                showAvatarForEveryMessage: false,
                scrollToBottom: true,
                onPressAvatar: (ChatUser user) {
                  print("OnPressAvatar: ${user.name}");
                },
                onLongPressAvatar: (ChatUser user) {
                  print("OnLongPressAvatar: ${user.name}");
                },
                inputMaxLines: 5,
                messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                alwaysShowSend: true,
                inputTextStyle: TextStyle(fontSize: 16.0),
                inputContainerStyle: BoxDecoration(
                  border: Border.all(width: 0.0),
                  color: Colors.white,
                ),
                // onQuickReply: (Reply reply) {
                //   setState(() {
                //     messages.add(ChatMessage(
                //         text: reply.value,
                //         createdAt: DateTime.now(),
                //         user: user));

                //     messages = [...messages];
                //   });

                //   Timer(Duration(milliseconds: 300), () {
                //     _chatViewKey.currentState.scrollController
                //       ..animateTo(
                //         _chatViewKey.currentState.scrollController.position
                //             .maxScrollExtent,
                //         curve: Curves.easeOut,
                //         duration: const Duration(milliseconds: 300),
                //       );

                //     if (i == 0) {
                //       systemMessage();
                //       Timer(Duration(milliseconds: 600), () {
                //         systemMessage();
                //       });
                //     } else {
                //       systemMessage();
                //     }
                //   });
                // },
                onLoadEarlier: model.loadEarlier,
                shouldShowLoadEarlier: false,
                showTraillingBeforeSend: true,
                trailing: <Widget>[
                  IconButton(
                    icon: Icon(Icons.photo),
                    onPressed: () async {
                      File result = await ImagePicker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 80,
                        maxHeight: 400,
                        maxWidth: 400,
                      );

                      if (result != null) {
                        // TODO: set text
                        // TODO: send image
                        // TODO: set url

                        ChatMessage message =
                            ChatMessage(text: 'See the natural', user: user, image: 'https://file.angelmortal.xyz/file/testBuc/test_testwebpicture');
                        model.postMessage(message);
                        // TODO: upload
                      }
                    },
                  )
                ],
              );
            }
          }),
    );
  }
}