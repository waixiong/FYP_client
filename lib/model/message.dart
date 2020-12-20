import 'package:dash_chat/dash_chat.dart';
import 'package:hive/hive.dart';
import 'package:imageChat/locator.dart';
import 'package:imageChat/service/db.dart';
import 'package:imageChat/service/grpc/chat.pbgrpc.dart' as pbChat;

part 'message.g.dart';

@HiveType(typeId: 1)
class Message extends HiveObject {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String senderId;

  @HiveField(2)
  final String receiverId;

  @HiveField(3)
  final String text;

  @HiveField(4)
  final String img;

  @HiveField(5)
  final String attachment;

  @HiveField(6)
  final DateTime time;

  @HiveField(7)
  bool read;

  Message({this.id, this.senderId, this.receiverId, this.text, this.img, this.attachment, this.time, this.read});

  factory Message.fromProto(pbChat.Message m) {
    return Message(
      id: m.id,
      senderId: m.senderId,
      receiverId: m.receiverId,
      text: m.text,
      img: m.img,
      attachment: m.attachment,
      time: DateTime.fromMillisecondsSinceEpoch(m.timestamp.toInt()),
      read: false
    );
  }

  factory Message.fromJson(Map<String, dynamic> m) {
    return Message(
      id: m['id'],
      senderId: m['senderId'],
      receiverId: m['receiverId'],
      text: m['text'],
      img: m['img'],
      attachment: m['attachment'],
      time: DateTime.fromMillisecondsSinceEpoch(int.parse(m['timestamp'])),
      read: m['read']
    );
  }

  Future<ChatMessage> toChatMessage() async {
    return ChatMessage(
      text: text, 
      user: (await locator<DB>().getUser(senderId)).toChatUser(),
      image: img.isNotEmpty? img:null,
      createdAt: time,
      id: id,
      // TODO: decode button
    );
  }
}

