import 'dart:async';
import 'dart:io';

import 'package:imageChat/locator.dart';
import 'package:imageChat/service/auth_service.dart';
import 'package:imageChat/util/network_config.dart';
import 'package:imageChat/view/pages/secret_image_decode_page.dart';
import 'package:imageChat/view/pages/secret_image_encode_page.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../viewmodel/chat_viewmodel.dart';
import 'package:flutter/material.dart';
// https://stackoverflow.com/questions/58043499/image-picker-flutter-web-1-9
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:stacked/stacked.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'hero_photo_view.dart';

// void main() => runApp(MyApp());

class ChatPage extends StatefulWidget {
  final ChatUser target;
  final ChatUser self;
  ChatPage({@required this.self, @required this.target});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  // final ChatUser user = ChatUser(
  //   name: "WXiong Chee",
  //   uid: locator<AuthService>().user.id,
  //   avatar: locator<AuthService>().user.img,
  // );

  // final ChatUser otherUser = ChatUser(
  //   name: "Yeez",
  //   uid: "25649654",
  //   avatar: 'https://yeez.getitqec.com/icons/y_192.webp',
  // );

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

  void navigateToEncode(ChatViewModel model) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SecretImageEncodeFullPage(sendToChat: model.sendEncodedImage,)));
  }

  void navigateToDecode(ChatViewModel model) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SecretImageDecodeFullPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text(widget.target.name,),
        // iconTheme: Theme.of(context).iconTheme.copyWith(color: Theme.of(context).backgroundColor),
      ),
      body: ViewModelBuilder<ChatViewModel>.reactive(
        viewModelBuilder: () => ChatViewModel(self: widget.self, targetUser: widget.target),
        onModelReady: (model) {
          print('ChatPage ChatViewModel init');
          model.init();
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
              // return Image.file(
              //   File(tempDir.path + '/img.webp'),
              //   alignment: Alignment.center,
              // );
              return DashChat(
                key: model.chatViewKey,
                inverted: false,
                onSend: model.postMessage,
                sendOnEnter: true,
                textInputAction: TextInputAction.send,
                user: model.self,
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
                // alwaysShowSend: true,
                inputTextStyle: TextStyle(fontSize: 16.0),
                inputContainerStyle: BoxDecoration(
                  border: Border.all(width: 0.0),
                  // color: Colors.white,
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
                messageBuilder: _messageBuilder,
                trailing: <Widget>[
                  IconButton(
                    icon: Icon(LineAwesomeIcons.image),
                    onPressed: () => Scaffold.of(context).showSnackBar(SnackBar(content: Text('Currently not able to send image'),)),
                  ),
                  IconButton(
                    icon: Icon(LineAwesomeIcons.key),
                    onPressed: () => navigateToEncode(model),
                  )
                ],
              );
            }
          }),
    );
  }

  Widget _messageBuilder(ChatMessage message) {
    final isUser = message.user.uid == widget.self.uid;
    final constraints = BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: MediaQuery.of(context).size.width);
    final messageContainerDecoration = BoxDecoration(
      color: message.user.containerColor != null
          ? message.user.containerColor
          : isUser
              ? Theme.of(context).accentColor
              : Color.fromRGBO(225, 225, 225, 1),
      borderRadius: BorderRadius.circular(5.0),
    );
    return Align(
      alignment: isUser
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        decoration: messageContainerDecoration,
        margin: EdgeInsets.only(
          bottom: 5.0,
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            // image builder
            message.image != null
                ? GestureDetector(
                    onLongPress: () {},
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HeroPhotoViewWrapper(
                              imageProvider: CachedNetworkImageProvider(message.image),
                              tag: message.image + message.hashCode.toString(),
                              minScale: PhotoViewComputedScale.contained,
                            ),
                          ),
                        ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Hero(
                        transitionOnUserGestures: true,
                        tag: message.image + message.hashCode.toString(),
                        child: CachedNetworkImage(
                          imageUrl: message.image,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          height: constraints.maxHeight * 0.3,
                          width: constraints.maxWidth * 0.7,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ))
                : SizedBox(),
            // TODO: video builder
            // message.video != null
            //     ? Padding(
            //         padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            //         child: CustomVideoPlayer(
            //           url: locator<API>().getChatImagePath(message.video),
            //           height: constraints.maxHeight * 0.3,
            //           width: constraints.maxWidth * 0.8,
            //         ),
            //       )
            //     : SizedBox(),
            // TODO: file holder
            // if (message.customProperties != null)
            //   if (message.customProperties.containsKey('file'))
            //     NetworkFileHolder(
            //         url: locator<API>()
            //             .getChatImagePath(message.customProperties['file'])),
            // Text builder
            if (message.text != null)
              ParsedText(
                parse: const <MatchText>[],
                text: message.text,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            // buttons builder
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: message.buttons ?? [],
            ),
            // Time builder
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                DateFormat('HH:mm').format(message.createdAt),
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}